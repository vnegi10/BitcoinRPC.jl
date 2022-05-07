## https://developer.bitcoin.org/reference/rpc/getbestblockhash.html

"""
    show_best_block_hash(auth::UserAuth)

Returns the hash of the best (tip) block in the most-work fully-validated chain.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`

# Example
```julia-repl
julia> show_best_block_hash(auth)
"00000000000000000004202bf6a4b09fcfde643a4a1d206f18949308bc505011"
```
"""
function show_best_block_hash(auth::UserAuth)
    return do_try_catch(auth, "getbestblockhash")
end


## https://developer.bitcoin.org/reference/rpc/getblock.html

"""
    show_block(auth::UserAuth; blockhash::String, verbosity::Int64 = 1)

Get block data depending on selected verbosity.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`

# Optional keywords
- `verbosity::Int64` : If verbosity is 0, returns a string that is serialized, hex-encoded data 
                       for block `hash`. If verbosity is 1, returns an object with information 
                       about block `hash`. If verbosity is 2, returns an object with information 
                       about block `hash` and information about each transaction.

# Example
```julia-repl
julia> show_block(auth, blockhash = show_best_block_hash(auth), verbosity = 1)
Dict{String, Any} with 18 entries:
  "time"              => DateTime("2022-05-07T01:13:07")
  "difficulty"        => 2.97944e13
  "bits"              => "17097275"
  "previousblockhash" => "00000000000000000007c2e512cf0b3f99cec4334c3499f4d477babc63a1b77b"
  "merkleroot"        => "d0fda1281cec9719be434acb24a81715f98ac0948a445f1b6b4e967d8781615c"
```
"""
function show_block(auth::UserAuth; blockhash::String, verbosity::Int64 = 0)

    return do_try_catch(auth, "getblock"; params = [blockhash, verbosity])
end


## https://developer.bitcoin.org/reference/rpc/getblockchaininfo.html

"""
    show_blockchain_info(auth::UserAuth)

Returns an object containing various state info regarding blockchain processing.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`

# Example
```julia-repl
julia> show_blockchain_info(auth)
Dict{String, Any} with 13 entries:
  "verificationprogress" => 0.999998
  "difficulty"           => 2.97944e13
  "chain"                => "main"
  "initialblockdownload" => false
  "size_on_disk"         => 459765806919
...
```
"""
function show_blockchain_info(auth::UserAuth)
    return do_try_catch(auth, "getblockchaininfo")
end


## https://developer.bitcoin.org/reference/rpc/getblockcount.html

"""
    show_block_count(auth::UserAuth)

Returns the height of the most-work fully-validated chain.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`

# Example
```julia-repl
julia> show_block_count(auth)
735241
```
"""
function show_block_count(auth::UserAuth)
    return do_try_catch(auth, "getblockcount")
end


## https://developer.bitcoin.org/reference/rpc/getblockhash.html

"""
    show_block_hash(auth::UserAuth; height::Int64 = 0)

Returns hash of block in best-block-chain at height provided.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`
- `height::Int64` : Height of the desired block, default is set to 0.

# Example
```julia-repl
julia> show_block_hash(auth, height = 696969)
"0000000000000000000b3e2716da675f99df43134a67fc1987c5590f1c370472"
```
"""
function show_block_hash(auth::UserAuth; height::Int64 = 0)
    
    @assert 0 ≤ height ≤ show_block_count(auth) "Invalid block height"

    return do_try_catch(auth, "getblockhash", params = [height])
end


## https://developer.bitcoin.org/reference/rpc/getblockheader.html

"""
    show_block_header(auth::UserAuth; blockhash::String, verbose::Bool=true)

Returns the contents of the block header.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`
- `blockhash::String` : Hash of the desired block

# Optional keywords
- `verbose::Bool` : If verbose is false, returns a string that is serialized, hex-encoded 
                    data for blockheader `hash`. If verbose is true (default), returns an 
                    object with information about blockheader `hash`.

# Result
```julia-repl
julia> show_block_header(auth, blockhash = show_block_hash(auth, height = 700_000))
Dict{String, Any} with 15 entries:
  "time"              => DateTime("2021-09-11T04:14:32")
  "difficulty"        => 1.84152e13
  "bits"              => "170f48e4"
  "previousblockhash" => "0000000000000000000aa3ce000eb559f4143be419108134e0ce71042fc636eb"
  "nextblockhash"     => "00000000000000000002f39baabb00ffeb47dbdb425d5077baa62c47482b7e92"
...
```
"""
function show_block_header(auth::UserAuth; blockhash::String, verbose::Bool=true)

    return do_try_catch(auth, "getblockheader", params = [blockhash, verbose])
end


## https://developer.bitcoin.org/reference/rpc/getblockstats.html

"""
    show_block_stats(auth::UserAuth; hashORheight::StringOrInt = 0, stats = "")

Compute per block statistics for a given window. All amounts are in BTC.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`

# Optional keywords
- `hashORheight::StringOrInt` : Block hash or height
- `stats` : Specific group of stats, e.g. ["avgfee", "utxo_increase"]  

# Example
```julia-repl
julia> show_block_stats(auth, hashORheight = 500_000)
Dict{String, Any} with 29 entries:
  "avgtxsize"           => 388
  "time"                => DateTime("2017-12-18T18:35:25")
  "totalfee"            => 3.39352
  "utxo_increase"       => 1899
  "total_out"           => 1401737618054
...
```
"""
function show_block_stats(auth::UserAuth; hashORheight::StringOrInt = 0, stats = "")

    result = ""
    
    get_params() = isempty(stats) ? [hashORheight] : [hashORheight, stats]
        
    result = do_try_catch(auth, "getblockstats", params = get_params())
    sato_to_btc!(result)

    return result
end


## https://developer.bitcoin.org/reference/rpc/getchaintips.html

"""
    show_chain_tips(auth::UserAuth)

Return information about all known tips in the block tree, including the main chain as well 
as orphaned branches.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`

# Example
```julia-repl
julia> show_chain_tips(auth)
1-element Vector{Any}:
 Dict{String, Any}("height" => 735239, "branchlen" => 0, "status" => "active", "hash" => ...
```
"""
function show_chain_tips(auth::UserAuth)
    return do_try_catch(auth, "getchaintips")
end


## https://developer.bitcoin.org/reference/rpc/getchaintxstats.html

"""
    show_chain_txstats(auth::UserAuth; nblocks::Int64 = 144, blockhash::String = "")

Compute statistics about the total number and rate of transactions in the chain for a 
given search window.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`

# Optional keywords
- `nblocks::Int64` : Size of the window in number of blocks, default is 144 (~ 1 day). If 
                     blockhash is not specified, stats are calculated until latest height.
- `blockhash::String` : The hash of the block that ends the window. Default is empty, which
                        means stats are shown until latest height.

# Example
```julia-repl
julia> show_chain_txstats(auth, nblocks = 1440, blockhash = show_block_hash(auth, height = 700_000))
Dict{String, Any} with 8 entries:
  "txcount"                   => 669566382
  "window_tx_count"           => 2512428
  "time"                      => DateTime("2021-09-11T04:14:32")
  "window_interval"           => 821264
  "window_final_block_height" => 700000
  "window_final_block_hash"   => "0000000000000000000590fc0f3eba193a278534220b2b37e9849e1a770ca959"
  "window_block_count"        => 1440
  "txrate"                    => 3.05922
````
"""
function show_chain_txstats(auth::UserAuth; nblocks::Int64 = 144, blockhash::String = "")

    @assert 0 ≤ nblocks ≤ show_block_count(auth) "Invalid size of block window"

    result = ""

    if isempty(blockhash)
        result = do_try_catch(auth, "getchaintxstats", params = [nblocks])
    else
        result = do_try_catch(auth, "getchaintxstats", params = [nblocks, blockhash])
    end

    return result
end


## https://developer.bitcoin.org/reference/rpc/getdifficulty.html

"""
    show_difficulty(auth::UserAuth)

Returns the proof-of-work difficulty as a multiple of the minimum difficulty.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`

# Example
```julia-repl
julia> show_difficulty(auth)
2.979440758931208e13
```
"""
function show_difficulty(auth::UserAuth)
    return do_try_catch(auth, "getdifficulty")
end


## https://developer.bitcoin.org/reference/rpc/getmempoolancestors.html

"""
    show_mempool_ancestors(auth::UserAuth; txid::String, verbose::Bool = true)

If txid is in the mempool, returns all in-mempool ancestors.
"""
function show_mempool_ancestors(auth::UserAuth; txid::String, verbose::Bool = true)

    return do_try_catch(auth, "getmempoolancestors", params = [txid, verbose])
end


## https://developer.bitcoin.org/reference/rpc/getmempooldescendants.html

"""
    show_mempool_descendents(auth::UserAuth; txid::String, verbose::Bool = true)

If txid is in the mempool, returns all in-mempool descendants.
"""
function show_mempool_descendents(auth::UserAuth; txid::String, verbose::Bool = true)

    return do_try_catch(auth, "getmempooldescendants", params = [txid, verbose])
end


## https://developer.bitcoin.org/reference/rpc/getmempoolentry.html

"""
    show_mempool_entry(auth::UserAuth; txid::String)

Returns mempool data for a given transaction.
"""
function show_mempool_entry(auth::UserAuth; txid::String)

    return do_try_catch(auth, "getmempoolentry", params = [txid])
end


## https://developer.bitcoin.org/reference/rpc/getmempoolinfo.html

"""
    show_mempool_info(auth::UserAuth)

Returns details on the active state of the TX memory pool.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`

# Example
```julia-repl
julia> show_mempool_info(auth)
Dict{String, Any} with 9 entries:
  "unbroadcastcount" => 0
  "maxmempool"       => 1000000000
  "bytes"            => 1272046
  "loaded"           => true
  "usage"            => 6281104
  ...
"""
function show_mempool_info(auth::UserAuth)

    return do_try_catch(auth, "getmempoolinfo")
end


## https://developer.bitcoin.org/reference/rpc/getrawmempool.html

"""
    show_mempool_raw(auth::UserAuth; verbose::Bool = false, mempool_sequence::Bool = false)

Returns all transaction ids in memory pool as a json array of string transaction ids.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`

# Example
```julia-repl
julia> show_mempool_raw(auth)
2225-element Vector{String}:
 "46db70c88170e584b6787adc7561a6aa06ddce51f8bcd34bd4576ce0114e55ea"
 "5e17a3b3bf10e137050734ac884fb496e5933ebc7401764f62c60b18f58df891"
 "3fa233c8bcb8f2002b4997507c36a887c76359719c643a7e93541a7230f84b9c"
 ...
```
"""
function show_mempool_raw(auth::UserAuth; verbose::Bool = false, mempool_sequence::Bool = false)

    result = do_try_catch(auth, "getrawmempool", params = [verbose, mempool_sequence])

    return String.(result)
end


## https://developer.bitcoin.org/reference/rpc/gettxout.html

"""
    show_tx_out(auth::UserAuth; txid::String, n::Int64 = 1, include_mempool::Bool = true)

Returns details about an unspent transaction output.
"""
function show_tx_out(auth::UserAuth; txid::String, n::Int64 = 1, include_mempool::Bool = true)

    return do_try_catch(auth, "gettxout", params = [txid, n, include_mempool])    
end


## https://developer.bitcoin.org/reference/rpc/gettxoutproof.html

## Not added because of the following limitation:

#= Returns a hex-encoded proof that “txid” was included in a block. By default this function 
only works sometimes. This is when there is an unspent output in the utxo for this transaction.
To make it always work, you need to maintain a transaction index, using the -txindex command line
option or specify the block in which the transaction is included manually (by blockhash).=#


## https://developer.bitcoin.org/reference/rpc/gettxoutsetinfo.html

"""

Returns statistics about the unspent transaction output set.
"""
function show_tx_out_setinfo(auth::UserAuth; hash_type::String = "hash_serialized_2")

    return do_try_catch(auth, "gettxoutsetinfo", params = [hash_type])
end


## https://developer.bitcoin.org/reference/rpc/preciousblock.html
## Not sure what's the use of this one, skipping for now.

## https://developer.bitcoin.org/reference/rpc/savemempool.html
## Skipping for now

## https://developer.bitcoin.org/reference/rpc/scantxoutset.html
## Skipping for now

## https://developer.bitcoin.org/reference/rpc/verifychain.html
"""
    verify_chain(auth::UserAuth; checklevel::Int64 = 1, nblocks::Int64 = 10)

Verifies blockchain database.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`

# Optional keywords
- `checklevel::Int64` : Control the thoroughness of block verification. Each level includes 
                        the checks of the previous levels. Default is level 1.                      

                        - level 0 reads the blocks from disk
                        - level 1 verifies block validity
                        - level 2 verifies undo data
                        - level 3 checks disconnection of tip blocks
                        - level 4 tries to reconnect the blocks
- `nblocks::Int64` : number of blocks to check, default is set to 10

# Example
```julia-repl
julia> verify_chain(auth, nblocks = 100)
true
```
"""
function verify_chain(auth::UserAuth; checklevel::Int64 = 1, nblocks::Int64 = 10)

    return do_try_catch(auth, "verifychain", params = [checklevel, nblocks])
end


## https://developer.bitcoin.org/reference/rpc/verifytxoutproof.html
## Skipping for now
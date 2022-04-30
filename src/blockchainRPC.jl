## https://developer.bitcoin.org/reference/rpc/getbestblockhash.html

"""
    get_best_block_hash(auth::UserAuth)

Returns the hash of the best (tip) block in the most-work fully-validated chain.
"""
function get_best_block_hash(auth::UserAuth)
    return do_try_catch(auth, "getbestblockhash")
end


## https://developer.bitcoin.org/reference/rpc/getblock.html

"""
    get_block(auth::UserAuth; blockhash::String, verbosity::Int64 = 0)

Get block data depending on selected verbosity.
"""
function get_block(auth::UserAuth; blockhash::String, verbosity::Int64 = 0)

    return do_try_catch(auth, "getblock"; params = [blockhash, verbosity])
end


## https://developer.bitcoin.org/reference/rpc/getblockchaininfo.html

"""
    get_blockchain_info(auth::UserAuth)

Returns an object containing various state info regarding blockchain processing.
"""
function get_blockchain_info(auth::UserAuth)
    return do_try_catch(auth, "getblockchaininfo")
end


## https://developer.bitcoin.org/reference/rpc/getblockcount.html

"""
    get_block_count(auth::UserAuth)

Returns the height of the most-work fully-validated chain.
"""
function get_block_count(auth::UserAuth)
    return do_try_catch(auth, "getblockcount")
end


## https://developer.bitcoin.org/reference/rpc/getblockhash.html

"""
    get_block_hash(auth::UserAuth; height::Int64 = 0)

Returns hash of block in best-block-chain at height provided.
"""
function get_block_hash(auth::UserAuth; height::Int64 = 0)
    
    @assert 0 ≤ height ≤ get_block_count(auth) "Invalid block height"

    return do_try_catch(auth, "getblockhash", params = [height])
end


## https://developer.bitcoin.org/reference/rpc/getblockheader.html

"""
    get_block_header(auth::UserAuth; blockhash::String, verbose::Bool=true)

If verbose is false, returns a string that is serialized, hex-encoded data for blockheader `hash`.

If verbose is true, returns an Object with information about blockheader `hash`.
"""
function get_block_header(auth::UserAuth; blockhash::String, verbose::Bool=true)

    return do_try_catch(auth, "getblockheader", params = [blockhash, verbose])
end


## https://developer.bitcoin.org/reference/rpc/getblockstats.html

"""
    get_block_stats(auth::UserAuth; hashORheight::StringOrInt = 0, stats = "")

Compute per block statistics for a given window. All amounts are in satoshis.
"""
function get_block_stats(auth::UserAuth; hashORheight::StringOrInt = 0, stats = "")

    result = ""

    if isempty(stats)
        result = do_try_catch(auth, "getblockstats", params = [hashORheight])
    else
        result = do_try_catch(auth, "getblockstats", params = [hashORheight, stats])
    end

    all_keys = keys(result) |> collect

    # Convert Satoshis to BTC
    for key in all_keys
        if occursin("fee", key)
            result[key] /= 1e8
        end
    end

    return result
end


## https://developer.bitcoin.org/reference/rpc/getchaintips.html

"""
    get_chain_tips(auth::UserAuth)

Return information about all known tips in the block tree, including the main chain as well 
as orphaned branches.
"""
function get_chain_tips(auth::UserAuth)
    return do_try_catch(auth, "getchaintips")
end


## https://developer.bitcoin.org/reference/rpc/getchaintxstats.html

"""
    get_chain_txstats(auth::UserAuth; nblocks::Int64 = 144, blockhash::String = "")

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
julia> get_chain_txstats(auth, nblocks = 1440, blockhash = get_block_hash(auth, height = 700000))
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
function get_chain_txstats(auth::UserAuth; nblocks::Int64 = 144, blockhash::String = "")

    @assert 0 ≤ nblocks ≤ get_block_count(auth) "Invalid size of block window"

    result = ""

    if isempty(blockhash)
        result = do_try_catch(auth, "getchaintxstats", params = [nblocks])
    else
        result = do_try_catch(auth, "getchaintxstats", params = [nblocks, blockhash])
    end

    return result
end
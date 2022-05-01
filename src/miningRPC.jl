## https://developer.bitcoin.org/reference/rpc/getblocktemplate.html
## Skipping for now


##https://developer.bitcoin.org/reference/rpc/getmininginfo.html

"""
    show_mining_info(auth::UserAuth)

Returns a json object containing mining-related information.
"""
function show_mining_info(auth::UserAuth)
    return do_try_catch(auth, "getmininginfo")
end


## https://developer.bitcoin.org/reference/rpc/getnetworkhashps.html

"""
    show_network_hashps(auth::UserAuth; nblocks::Int64 = -1, height::Int64 = -1)

Returns the estimated network hashes per second based on the selected 
number of blocks.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`

# Optional keywords
- `nblocks::Int64` : Size of the window in number of blocks, used for estimation of the 
                     network hashes per second. Default is set to -1, which specifies
                     since last difficulty change.
- `height::Int64` : Estimate the network speed at the time when a certain block was found.

# Example
```julia-repl
julia> show_network_hashps(auth, nblocks = 144)
2.435873902493952e20

julia> show_network_hashps(auth, height = 144)
900742.2065335643
```
"""
function show_network_hashps(auth::UserAuth; nblocks::Int64 = -1, height::Int64 = -1)

    @assert -1 ≤ height ≤ show_block_count(auth) "Invalid block height"
    @assert     nblocks ≤ show_block_count(auth) "Invalid number of blocks"

    return do_try_catch(auth, "getnetworkhashps", params = [nblocks, height])
end


## https://developer.bitcoin.org/reference/rpc/prioritisetransaction.html
## Skipping for now

## https://developer.bitcoin.org/reference/rpc/submitblock.html
## Skipping for now

## https://developer.bitcoin.org/reference/rpc/submitheader.html
## Skipping for now
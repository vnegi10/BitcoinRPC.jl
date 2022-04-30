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


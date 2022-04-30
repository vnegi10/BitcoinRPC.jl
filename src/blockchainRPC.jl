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
## https://developer.bitcoin.org/reference/rpc/getbestblockhash.html

"""
    get_best_block_hash(auth::UserAuth)

Returns the hash of the best (tip) block in the most-work fully-validated chain.
"""
function get_best_block_hash(auth::UserAuth)

    result = ""

    try
        result = post_request(auth, "getbestblockhash", params = [])
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found"
        else
            @info "Could not retrieve data, try again!"
        end
    end

    return result
end


## https://developer.bitcoin.org/reference/rpc/getblock.html

"""
    get_block(auth::UserAuth; blockhash::String, verbosity::Int64 = 0)

Get block data depending on selected verbosity.
"""
function get_block(auth::UserAuth; blockhash::String, verbosity::Int64 = 0)

    result = ""

    try
        result = post_request(auth, "getblock", params = [blockhash, verbosity])
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found"
        else
            @info "Could not retrieve data, try again!"
        end
    end

    return result
end
################# Helper functions #################

function do_try_catch(auth::UserAuth, method::String; params = [])

    result = ""

    try
        result = post_request(auth, method; params)
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            code = e.status
            if code == 404
                @warn("input method is likely NOK")
                error("HTTP - Not Found")
                
            elseif code == 500
                @warn("input parameter is likely NOK")
                error("HTTP - Internal Server Error")

            else
                error("$(e)")
            end
        else
            error("Something went wrong, check $(e)!")
        end
    end

    return result
end

# Convert Satoshis to BTC
function sato_to_btc!(result)

    all_keys = keys(result) |> collect

    for key in all_keys
        if occursin("fee", key) || occursin("total_out", key)
            result[key] /= 1e8
        end
    end

    return result
end

# Convert list of params from String to Int64
function convert_to_int(params::String)

    # Example for params input: "[500,501,502,503,504...]"

    all_params = split(params, ",")
	all_params[1] = strip(all_params[1], [ '[' ])
	all_params[end] = strip(all_params[end], [ ']' ])

	params_int = Int64[]

	for par in all_params
		push!(params_int, parse(Int64, par))
	end
    
    return params_int
end

# Get block stats for a specified interval
function get_block_df(auth::UserAuth, weeks::Int64; batchsize::Int64, stats)

    # Ideally, 2016 blocks should be generated every 2 weeks
    num_blocks  = 1008 * weeks
    block_end   = show_block_count(auth)
    block_start = block_end - num_blocks

    df_stats = collect_block_stats_batch(auth, block_start, block_end; 
                                         batchsize = batchsize, 
                                         stats = stats)

    return df_stats
end

# Get network stats for a specified interval
function get_network_df(auth::UserAuth, weeks::Int64; batchsize::Int64)

    # Ideally, 2016 blocks should be generated every 2 weeks
    num_blocks  = 1008 * weeks
    block_end   = show_block_count(auth)
    block_start = block_end - num_blocks

    df_stats = collect_network_stats_batch(auth, block_start, block_end; 
                                           batchsize = batchsize)

    return df_stats
end
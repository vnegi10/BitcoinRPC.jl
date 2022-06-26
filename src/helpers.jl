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
    all_params[1] = strip(all_params[1], ['['])
    all_params[end] = strip(all_params[end], [']'])

    params_int = Int64[]

    for par in all_params
        push!(params_int, parse(Int64, par))
    end

    return params_int
end

# Get block stats for a specified interval
function get_block_df(auth::UserAuth, weeks::Int64; batchsize::Int64, stats)

    # Ideally, 2016 blocks should be generated every 2 weeks
    num_blocks = 1008 * weeks
    block_end = show_block_count(auth)
    block_start = block_end - num_blocks

    df_stats = collect_block_stats_batch(
        auth,
        block_start,
        block_end;
        batchsize = batchsize,
        stats = stats,
    )

    return df_stats
end

# Get network stats for a specified interval
function get_network_df(auth::UserAuth, weeks::Int64; batchsize::Int64)

    # Ideally, 2016 blocks should be generated every 2 weeks
    num_blocks = 1008 * weeks
    block_end = show_block_count(auth)
    block_start = block_end - num_blocks

    df_stats =
        collect_network_stats_batch(auth, block_start, block_end; batchsize = batchsize)

    return df_stats
end

# Convert to per day time interval
function get_daily_data(df_stats::DataFrame, stats_type::String)

    rows, cols = size(df_stats)
    day, col_per_day = Date[], Float64[]
    df_temp = select(df_stats, Not(:time))
    col_name = names(df_temp)[1]
    j = 1

    for i = 2:rows

        # Loop up to the point when date changes, then sum all the entries till then
        if Dates.Date(df_stats[!, :time][i]) != Dates.Date(df_stats[!, :time][i-1])
            start_at = j
            stop_at  = i - 1
            j = i

            # When counter reaches the last day
        elseif i == rows
            start_at = j
            stop_at  = i
        else
            continue
        end

        # df_temp will have only one column which can be selected by its index
        if stats_type == "mean"
            col_value = df_temp[!, 1][start_at:stop_at] |> Statistics.mean
        elseif stats_type == "sum"
            col_value = df_temp[!, 1][start_at:stop_at] |> sum
        end

        push!(day, Dates.Date(df_stats[!, :time][stop_at]))
        push!(col_per_day, col_value)
    end

    df_stats_per_day = DataFrame("time" => day, col_name => col_per_day)

    return df_stats_per_day
end

# Get block time intervals
function get_block_intervals(df_stats::DataFrame)

    # Difference between consecutive blocks
    Δblock_tstamps = df_stats[!, :time][2:end] - df_stats[!, :time][1:end-1]

    # Convert ms to mins
    block_mins = [Δblock_tstamps[i].value / 60000 for i in eachindex(Δblock_tstamps)]

    return DataFrame(block_mins = block_mins)
end
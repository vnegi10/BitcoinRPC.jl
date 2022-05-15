# Generate unicode plots in the REPL for visual analysis of some important metrics

"""
"""
function plot_avg_fee(auth::UserAuth, weeks::Int64; batchsize::Int64 = 50)

    df_stats = get_block_df(auth, weeks, batchsize = batchsize, 
                            stats = ["avgfee", "time"])

    plt = lineplot(df_stats[!, :time], df_stats[!, :avgfee],
                   title  = "Average fee in the block", 
                   xlabel = "Block time", ylabel = "Avg fee [BTC]",
                   xticks = true, yticks = true, 
                   border = :bold,
                   canvas = BrailleCanvas, width = 100, height = 20)

    return plt
end


"""
"""
function plot_max_fee(auth::UserAuth, weeks::Int64; batchsize::Int64 = 50)

    df_stats = get_block_df(auth, weeks, batchsize = batchsize, 
                            stats = ["maxfee", "time"])

    plt = lineplot(df_stats[!, :time], df_stats[!, :maxfee],
                   title  = "Maximum fee in the block", 
                   xlabel = "Block time", ylabel = "Max fee [BTC]",
                   xticks = true, yticks = true, 
                   border = :bold,
                   canvas = BrailleCanvas, width = 100, height = 20)

    return plt
end


"""
"""
function plot_num_txs(auth::UserAuth, weeks::Int64; batchsize::Int64 = 50)

    df_stats = get_block_df(auth, weeks, batchsize = batchsize, 
                            stats = ["txs", "time"])

    plt = lineplot(df_stats[!, :time], df_stats[!, :txs],
                   title  = "Number of transactions", 
                   xlabel = "Block time", ylabel = "Num. txs",
                   xticks = true, yticks = true, 
                   border = :bold,
                   canvas = BrailleCanvas, width = 100, height = 20)

    return plt
end


"""
"""
function plot_total_output(auth::UserAuth, weeks::Int64; batchsize::Int64 = 50)

    df_stats = get_block_df(auth, weeks, batchsize = batchsize, 
                            stats = ["total_out", "time"])

    plt = lineplot(df_stats[!, :time], df_stats[!, :total_out],
                   title  = "Total amount in all outputs (excluding coinbase + rewards)", 
                   xlabel = "Block time", ylabel = "Amount [BTC]",
                   xticks = true, yticks = true, 
                   border = :bold,
                   canvas = BrailleCanvas, width = 100, height = 20)

    return plt
end
# Generate unicode plots in the REPL for visual analysis of some important metrics

"""
"""
function plot_avg_fee(auth::UserAuth, block_start::Int64, block_end::Int64; 
                      batchsize::Int64 = 50)

    df_stats = collect_block_stats_batch(auth, block_start, block_end; 
                                         batchsize = batchsize, 
                                         stats = ["avgfee", "height"])

    plt = lineplot(df_stats[!, :height], df_stats[!, :avgfee],
                   title  = "Average fee in the block", 
                   xlabel = "Block height", ylabel = "Avg fee [BTC]",
                   xticks = true, yticks = true, 
                   border = :bold,
                   canvas = BrailleCanvas, width = 100, height = 20)

    return plt
end


"""
"""
function plot_max_fee(auth::UserAuth, block_start::Int64, block_end::Int64; 
                      batchsize::Int64 = 50)

    df_stats = collect_block_stats_batch(auth, block_start, block_end; 
                                         batchsize = batchsize, 
                                         stats = ["maxfee", "height"])

    plt = lineplot(df_stats[!, :height], df_stats[!, :maxfee],
                   title  = "Maximum fee in the block", 
                   xlabel = "Block height", ylabel = "Max fee [BTC]",
                   xticks = true, yticks = true, 
                   border = :bold,
                   canvas = BrailleCanvas, width = 100, height = 20)

    return plt
end


"""
"""
function plot_num_txs(auth::UserAuth, block_start::Int64, block_end::Int64; 
                      batchsize::Int64 = 50)

    df_stats = collect_block_stats_batch(auth, block_start, block_end; 
                                         batchsize = batchsize, 
                                         stats = ["txs", "height"])

    plt = lineplot(df_stats[!, :height], df_stats[!, :txs],
                   title  = "Number of transactions", 
                   xlabel = "Block height", ylabel = "Num. txs",
                   xticks = true, yticks = true, 
                   border = :bold,
                   canvas = BrailleCanvas, width = 100, height = 20)

    return plt
end


"""
"""
function plot_total_output(auth::UserAuth, block_start::Int64, block_end::Int64; 
                           batchsize::Int64 = 50)

    df_stats = collect_block_stats_batch(auth, block_start, block_end; 
                                         batchsize = batchsize, 
                                         stats = ["total_out", "height"])

    plt = lineplot(df_stats[!, :height], df_stats[!, :total_out],
                   title  = "Total amount in all outputs (excluding coinbase + rewards)", 
                   xlabel = "Block height", ylabel = "Amount [BTC]",
                   xticks = true, yticks = true, 
                   border = :bold,
                   canvas = BrailleCanvas, width = 100, height = 20)

    return plt
end
# Generate unicode plots in the REPL for visual analysis of some important metrics

function plot_avg_fee(auth::UserAuth, block_start::Int64, block_end::Int64; 
                      batchsize::Int64 = 50, stats = ["avgfee", "height"])

    df_stats = collect_block_stats_batch(auth, block_start, block_end; 
                                         batchsize = batchsize, stats = stats)

    plt = lineplot(df_stats[!, :height], df_stats[!, :avgfee],
                   title  = "Average fee in the block", 
                   xlabel = "Block height", ylabel = "Avg fee [BTC]",
                   xticks = true, yticks = true, 
                   border = :bold,
                   canvas = BrailleCanvas, width = 100, height = 20)

    return plt
end


function plot_max_fee(auth::UserAuth, block_start::Int64, block_end::Int64; 
                      batchsize::Int64 = 50, stats = ["maxfee", "height"])

    df_stats = collect_block_stats_batch(auth, block_start, block_end; 
                                        batchsize = batchsize, stats = stats)

    plt = lineplot(df_stats[!, :height], df_stats[!, :maxfee],
                    title  = "Maximum fee in the block", 
                    xlabel = "Block height", ylabel = "Max fee [BTC]",
                    xticks = true, yticks = true, 
                    border = :bold,
                    canvas = BrailleCanvas, width = 100, height = 20)

    return plt
end
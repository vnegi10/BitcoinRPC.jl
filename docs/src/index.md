# User Guide
---

## Overview
BitcoinRPC.jl provides a Julia wrapper to Bitcoin's JSON-RPC API. Most of the 
[blockchain and mining RPCs](https://developer.bitcoin.org/reference/rpc/index.html) 
have been implemented in the form of callable functions. Depending on the operation, a function can return data (either as a DataFrame or Dict) or the associated HTTP response (Dict).

## Available functions
```@index
```

## Blockchain RPCs
```@docs
show_best_block_hash(auth::UserAuth)

show_block(auth::UserAuth; blockhash::String, verbosity::Int64 = 0)

show_blockchain_info(auth::UserAuth)

show_block_count(auth::UserAuth)

show_block_hash(auth::UserAuth; height::Int64 = 0)

show_block_header(auth::UserAuth; blockhash::String, verbose::Bool=true)

show_block_stats(auth::UserAuth; hashORheight::StringOrInt = 0, stats = "")

show_chain_tips(auth::UserAuth)

show_chain_txstats(auth::UserAuth; nblocks::Int64 = 144, blockhash::String = "")

show_difficulty(auth::UserAuth)

show_mempool_ancestors(auth::UserAuth; txid::String, verbose::Bool = true)

show_mempool_descendents(auth::UserAuth; txid::String, verbose::Bool = true)

show_mempool_entry(auth::UserAuth; txid::String)

show_mempool_info(auth::UserAuth)

show_mempool_raw(auth::UserAuth; verbose::Bool = false, mempool_sequence::Bool = false)

show_tx_out(auth::UserAuth; txid::String, n::Int64 = 1, include_mempool::Bool = true)

show_tx_out_setinfo(auth::UserAuth; hash_type::String = "hash_serialized_2")

verify_chain(auth::UserAuth; checklevel::Int64 = 1, nblocks::Int64 = 10)
```

## Mining RPCs
```@docs
show_mining_info(auth::UserAuth)

show_network_hashps(auth::UserAuth; nblocks::Int64 = -1, height::Int64 = -1)
```

## Perform on-chain analytics
```@docs
collect_block_stats(auth::UserAuth, block_start::Int64, block_end::Int64; stats = "")

collect_block_stats_batch(auth::UserAuth, block_start::Int64, block_end::Int64; 
                          batchsize::Int64 = 50, stats = "")

collect_network_stats_batch(auth::UserAuth, block_start::Int64, block_end::Int64;
                            batchsize::Int64 = 50)
```

## Generate unicode plots in the REPL
```@docs
plot_avg_fee(auth::UserAuth, weeks::Int64; batchsize::Int64 = 50)

plot_max_fee(auth::UserAuth, weeks::Int64; batchsize::Int64 = 50)

plot_total_fee(auth::UserAuth, weeks::Int64; batchsize::Int64 = 50)

plot_num_txs(auth::UserAuth, weeks::Int64; batchsize::Int64 = 50)

plot_total_output(auth::UserAuth, weeks::Int64; batchsize::Int64 = 50)

plot_network_hashrate(auth::UserAuth, weeks::Int64; batchsize::Int64 = 50)

plot_network_difficulty(auth::UserAuth, weeks::Int64; batchsize::Int64 = 50)

plot_block_time_dist(auth::UserAuth, weeks::Int64; batchsize::Int64 = 50)
```
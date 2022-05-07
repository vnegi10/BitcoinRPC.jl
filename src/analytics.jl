################# Functions for blockchain and network analytics #################

"""
    collect_block_stats(auth::UserAuth, block_start::Int64, block_end::Int64)

Collect statistics by iterating over a range of blocks.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`
- `block_start::Int64` : Starting block height
- `block_end::Int64` : Ending block height

# Example
```julia-repl
julia> collect_block_stats(auth, 700_000, 700_005)
6×28 DataFrame
 Row │ avgfee      avgfeerate  avgtxsize  blockhash                          height  ins    maxfee      maxfeerate  maxtxsize  medianfe ⋯
     │ Float64     Float64     Int64      String                             Int64   Int64  Float64     Float64     Int64      Float64  ⋯
─────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 0.00012069      1.5e-7       1000  0000000000000000000590fc0f3eba19…  700000   6342  0.014          3.58e-6      86228   1.512e- ⋯
   2 │ 2.078e-5        2.0e-8        956  00000000000000000002f39baabb00ff…  700001   2435  0.00153        2.51e-6      46044   3.36e-6
   3 │ 4.082e-5        8.0e-8        627  00000000000000000001993b6b5e4e3d…  700002    729  0.00059549     3.16e-6      22613   1.363e-
   4 │ 0.00025372      3.5e-7        981  000000000000000000055646f272b32b…  700003    716  0.025465       2.02e-6      35443   1.486e-
   5 │ 5.484e-5        1.1e-7        831  0000000000000000000e360e05cb9d7b…  700004   1174  0.0028332      4.77e-6      53046   1.323e- ⋯
```
"""
function collect_block_stats(auth::UserAuth, block_start::Int64, block_end::Int64; stats = "")

    @assert 0 ≤ block_start < block_end ≤ show_block_count(auth) "Invalid block height"

	results = Dict{String, Any}[]

    get_params(i::Int64) = isempty(stats) ? [i] : [i, stats]		
    
    for i = block_start:block_end
        try
            result = post_request(auth, "getblockstats"; params = get_params(i))
            delete!(result, "feerate_percentiles")
            sato_to_btc!(result)
            push!(results, result)
        catch e
            @info "Ran into error $(e)"
            @info "Could not fetch data for block $(i), will continue to next!"
            continue
        end 
    end   

	df_stats = DataFrame()
    
    try
        df_stats = vcat(DataFrame.(results)...)
    catch e
        @info "Unable to create a DataFrame, check this error: $(e)"
    end

	return df_stats
end


"""
    collect_block_stats_batch(auth::UserAuth, block_start::Int64, 
    block_end::Int64; batchsize::Int64 = 50,
    stats = "")

Collect statistics by iterating over a range of blocks in batches.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`
- `block_start::Int64` : Starting block height
- `block_end::Int64` : Ending block height

# Optional Arguments
- `batchsize::Int64` : Request can be sent in batches of given size, default is set to 50.

# Example
```julia-repl
julia> @time collect_block_stats_batch(auth, 500_000, 505_000, batchsize = 1000)
 25.873394 seconds (3.37 M allocations: 157.842 MiB, 0.21% gc time)
5001×28 DataFrame
  Row │ avgfee      avgfeerate  avgtxsize  blockhash                          height  ins    maxfee     maxfeerate  maxtxsize  medianfe ⋯
      │ Float64     Float64     Int64      String                             Int64   Int64  Float64    Float64     Int64      Float64  ⋯
──────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    1 │ 0.00125685     3.4e-6         388  00000000000000000024fb37364cbf81…  500000   4370  0.0647075    8.84e-6       19850  0.000858 ⋯
    2 │ 0.00137451     3.64e-6        403  0000000000000000005c9959b3216f86…  500001   5176  0.236868     2.79e-5       43980  0.000835
    3 │ 0.00113823     3.41e-6        352  000000000000000000877d93d1412ca6…  500002   5059  0.1          3.141e-5      33674  0.000697
    4 │ 0.00144839     3.64e-6        414  0000000000000000005467c7a728a3dc…  500003   5028  0.187487     1.182e-5      34739  0.000895
    5 │ 0.00150056     2.9e-6         568  0000000000000000005d4da5924742e6…  500004   5303  0.177758     1.908e-5     103927  0.000691 ⋯
...
```
"""
function collect_block_stats_batch(auth::UserAuth, block_start::Int64, 
                                   block_end::Int64; batchsize::Int64 = 50,
                                   stats = "")

    @assert 0 ≤ block_start < block_end ≤ show_block_count(auth) "Invalid block height"

    num_blocks = block_end - block_start + 1
    @assert num_blocks > batchsize "number of blocks too small, use without batch"

    results = ""
    all_results = Any[]
    i = block_start
    last_batch = false

    while i < block_end

        j = i + batchsize

        if j ≥ block_end
            j = block_end
            last_batch = true
        end
        params = JSON.json(i:j)
        
        try
            results = post_request_batch(auth, "getblockstats"; params = params)            
        catch e
            @info "Ran into error $(e)"
            @info "Could not fetch data for blocks $(i) to $(j), will continue to next batch!"
            i = j + 1
            continue
        end
        
        for result in results
            delete!(result, "feerate_percentiles")
            sato_to_btc!(result)
            push!(all_results, result)
        end

        if last_batch
            break
        end

        i = j + 1
    end 
    
    df_stats = DataFrame()
    
    try
        df_stats = vcat(DataFrame.(all_results)...)
    catch e
        @info "Unable to create a DataFrame, check this error: $(e)"
    end

	return df_stats    
end


"""
    collect_network_stats(auth::UserAuth, block_start::Int64, block_end::Int64)

Collect block and network statistics by iterating over a range of blocks.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`
- `block_start::Int64` : Starting block height
- `block_end::Int64` : Ending block height

# Example
```julia-repl
julia> collect_network_stats(auth, 700_000, 700_100)
101×4 DataFrame
 Row │ height  time                 network_hash  difficulty 
     │ Int64   DateTime             Float64       Float64    
─────┼───────────────────────────────────────────────────────
   1 │ 700000  2021-09-11T04:14:32    1.29538e20  1.80963e13
   2 │ 700001  2021-09-11T04:15:02    1.29813e20  1.81346e13
   3 │ 700002  2021-09-11T04:17:07    1.30042e20  1.81666e13
   4 │ 700003  2021-09-11T04:17:57    1.30306e20  1.82036e13
   5 │ 700004  2021-09-11T04:20:45    1.30515e20  1.82327e13
```
"""
function collect_network_stats(auth::UserAuth, block_start::Int64, block_end::Int64)

    @assert 0 ≤ block_start < block_end ≤ show_block_count(auth) "Invalid block height"

    df_stats = collect_block_stats(auth, block_start, block_end, 
                                   stats = ["height", "time"])

    network_hash = [show_network_hashps(auth, height = h) for h in df_stats[!, :height]]

    # Based on calculation from https://en.bitcoin.it/wiki/Difficulty
    # Network hash rate = D * 2**32 / 600
    difficulty = (network_hash * 600) / 2^32
    
    insertcols!(df_stats, :time, :network_hash => network_hash, after = true)
    insertcols!(df_stats, :network_hash, :difficulty => difficulty, after = true)

    return df_stats
end
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

	results = Array{Dict}(undef, block_end - block_start + 1)
	j = 1

	for i = block_start:block_end
        if isempty(stats)
            results[j] = show_block_stats(auth, hashORheight = i)
            delete!(results[j], "feerate_percentiles")
        else
            results[j] = show_block_stats(auth, hashORheight = i, stats = stats)
        end		
		j += 1
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
    collect_network_stats(auth::UserAuth, block_start::Int64, block_end::Int64)

Collect block and network statistics by iterating over a range of blocks.

# Arguments
- `auth::UserAuth` : User credentials, e.g. `auth = UserAuth("username", "password", port)`
- `block_start::Int64` : Starting block height
- `block_end::Int64` : Ending block height

# Example
```julia-repl
julia> collect_network_stats(auth, 700_000, 700_100)
101×3 DataFrame
 Row │ height  time                 network_hash 
     │ Int64   DateTime             Float64      
─────┼───────────────────────────────────────────
   1 │ 700000  2021-09-11T04:14:32    1.29538e20
   2 │ 700001  2021-09-11T04:15:02    1.29813e20
   3 │ 700002  2021-09-11T04:17:07    1.30042e20
   4 │ 700003  2021-09-11T04:17:57    1.30306e20
   5 │ 700004  2021-09-11T04:20:45    1.30515e20
```
"""
function collect_network_stats(auth::UserAuth, block_start::Int64, block_end::Int64)

    @assert 0 ≤ block_start < block_end ≤ show_block_count(auth) "Invalid block height"

    df_stats = collect_block_stats(auth, block_start, block_end, 
                                   stats = ["height", "time"])

    network_hash = [show_network_hashps(auth, height = h) for h = block_start:block_end]
    
    insertcols!(df_stats, :time, :network_hash => network_hash, after = true)

    return df_stats
end
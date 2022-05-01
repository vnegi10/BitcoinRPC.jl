################# Helper functions #################

function do_try_catch(auth::UserAuth, method::String; params = [])

    result = ""

    try
        result = post_request(auth, method; params)
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            @info "404 Not Found"
        else
            @info "Could not retrieve data, try again!"
        end
    end

    return result
end


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
   6 │ 4.076e-5        1.0e-7        552  0000000000000000000add9a48ae518c…  700005   1924  0.00140826     1.6e-6       23237   1.101e-
```
"""
function collect_block_stats(auth::UserAuth, block_start::Int64, block_end::Int64)

    @assert 0 ≤ block_start < block_end ≤ show_block_count(auth) "Invalid block height"

	results = Array{Dict}(undef, block_end - block_start + 1)
	j = 1

	for i = block_start:block_end
		results[j] = show_block_stats(auth, hashORheight = i)
		delete!(results[j], "feerate_percentiles")
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
module BitcoinRPC

export get_best_block_hash,
    get_block,
    UserAuth

using JSON, HTTP, Dates, DataFrames

include("types.jl")
include("request.jl")
include("blockchainRPC.jl")

end # module
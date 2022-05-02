using Test, JSON, Dates, HTTP, BitcoinRPC

# Argument for quiet mode
quiet = length(ARGS) > 0 && ARGS[1] == "q"

errors = false

# Location of test files
filepaths = String[]

for (root, dirs, files) in walkdir(@__DIR__)
    for file in files
        if startswith(file, "test_") && endswith(file, ".jl")
            push!(filepaths, joinpath(root, file))
        end
    end
end

# Get credentials for connecting to local node
user_data = JSON.parsefile("/home/vikas/Documents/Input_JSON/VNEG_RPC_user_data.json")

const AUTH = UserAuth(user_data["user"], 
                      user_data["pass"],
                      user_data["port"])

const BLOCKHASH = show_best_block_hash(AUTH)
const TX_IN_MEMPOOL = show_mempool_raw(AUTH)

println("Running full test suite:")

@time for file in filepaths
    try
        include(file)
        println("\t\033[1m\033[32mPASSED\033[0m: $(file)")
    catch e
        println("\t\033[1m\033[31mFAILED\033[0m: $(file)")
        global errors = true

        # Show detailed tracing when not in quiet mode
        if ~quiet
            showerror(stdout, e, backtrace())
            println()
        end
    end
end

if errors
    @warn "Some tests have failed! Check the results summary above."
end
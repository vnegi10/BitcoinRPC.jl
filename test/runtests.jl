using Test, JSON, Dates, BitcoinRPC

# Argument for quiet mode
quiet = length(ARGS) > 0 && ARGS[1] == "q"

errors = false

all_tests = ["test_blockRPCs.jl",
             "test_chainRPCs.jl",
             "test_mempoolRPCs.jl",
             "test_txRPCs.jl"]

# Get credentials for connecting to local node
user_data = JSON.parsefile("/home/vikas/Documents/Input_JSON/VNEG_RPC_user_data.json")

const AUTH = UserAuth(user_data["user"], 
                      user_data["pass"],
                      user_data["port"])

const BLOCKHASH = get_best_block_hash(AUTH)
const TX_IN_MEMPOOL = get_mempool_raw(AUTH)

println("Running full test suite:")

@time for file in all_tests
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
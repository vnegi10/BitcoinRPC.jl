#= Run tests on chain related RPCs: 
get_chain_tips, get_chain_txstats, get_difficulty,
verify_chain =#

@testset verbose = true "Chain related RPCs" begin

    @testset "get_chain_tips" begin
        @test ~isempty(get_chain_tips(AUTH))        
    end

    @testset "get_chain_txstats" begin

        result_1 = get_chain_txstats(AUTH, nblocks = 1440, 
                                     blockhash = get_block_hash(AUTH, height = 700_000))
        @test ~isempty(result_1)   
        @test result_1["window_final_block_height"] == 700_000

        result_2 = get_chain_txstats(AUTH, nblocks = 2000)
        @test ~isempty(result_2)
        @test result_2["window_block_count"] == 2000
        
    end

    @testset "get_difficulty" begin
        @test ~isempty(get_difficulty(AUTH))        
    end

    @testset "verify_chain" begin
        @test verify_chain(AUTH, nblocks = 10)        
    end

end
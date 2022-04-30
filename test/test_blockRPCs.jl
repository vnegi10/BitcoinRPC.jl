#= Run tests on block related RPCs: 
get_best_block_hash, get_block, get_blockchain_info, get_block_count,
get_block_hash, get_block_header, get_block_stats =#

@testset verbose = true "Block related RPCs" begin

    @testset "get_best_block_hash" begin
        best_hash = get_best_block_hash(AUTH)
        @test ~isempty(best_hash) && length(best_hash) == 64
    end

    @testset "get_block" begin
        @test ~isempty(get_block(AUTH, blockhash = BLOCKHASH, verbosity = 1))        
    end

    @testset "get_blockchain_info" begin
        @test ~isempty(get_blockchain_info(AUTH))        
    end

    @testset "get_block_count" begin
        @test ~isempty(get_block_count(AUTH))        
    end

    @testset "get_block_hash" begin        
        @test get_block_hash(AUTH, height = 500000) == 
        "00000000000000000024fb37364cbf81fd49cc2d51c09c75c35433c3a1945d04"
    end

    @testset "get_block_header" begin
        @test ~isempty(get_block_header(AUTH, blockhash = BLOCKHASH))        
    end

    @testset "get_block_stats" begin
        for input in [BLOCKHASH, 550000]
            @test ~isempty(get_block_stats(AUTH, hashORheight = input))
        end        
    end 

end
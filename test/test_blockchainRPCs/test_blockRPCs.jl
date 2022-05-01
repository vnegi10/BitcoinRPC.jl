#= Run tests on block related RPCs: 
show_best_block_hash, show_block, show_blockchain_info, show_block_count,
show_block_hash, show_block_header, show_block_stats =#

@testset verbose = true "Block related RPCs" begin

    @testset "show_best_block_hash" begin
        best_hash = show_best_block_hash(AUTH)
        @test ~isempty(best_hash) && length(best_hash) == 64
    end

    @testset "show_block" begin
        @test ~isempty(show_block(AUTH, blockhash = BLOCKHASH, verbosity = 1))        
    end

    @testset "show_blockchain_info" begin
        @test ~isempty(show_blockchain_info(AUTH))        
    end

    @testset "show_block_count" begin
        @test ~isempty(show_block_count(AUTH))        
    end

    @testset "show_block_hash" begin        
        @test show_block_hash(AUTH, height = 500_000) == 
        "00000000000000000024fb37364cbf81fd49cc2d51c09c75c35433c3a1945d04"
    end

    @testset "show_block_header" begin
        @test ~isempty(show_block_header(AUTH, blockhash = BLOCKHASH))        
    end

    @testset "show_block_stats" begin
        for input in [BLOCKHASH, 550_000]
            @test ~isempty(show_block_stats(AUTH, hashORheight = input))
        end        
    end 

end
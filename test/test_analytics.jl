# Run tests on functions for blockchain and network analytics

@testset verbose = true "Analytics functions" begin

    @testset "collect_block_stats" begin

        df_stats_1 = collect_block_stats(AUTH, 700_000, 700_010)
        rows, cols = size(df_stats_1)
        @test rows == 11 && cols == 28

        df_stats_2 = collect_block_stats(AUTH, 700_000, 700_100, 
                                         stats = ["avgfee", "utxo_increase"])
        rows, cols = size(df_stats_2)
        @test rows == 101 && cols == 2

    end

    @testset "collect_network_stats" begin

        df_stats = collect_network_stats(AUTH, 700_000, 700_100)
        rows, cols = size(df_stats)
        @test rows == 101 && cols == 3

    end
    
end
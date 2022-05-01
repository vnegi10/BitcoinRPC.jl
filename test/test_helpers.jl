# Run tests on helper functions

@testset verbose = true "Helper functions" begin

    @testset "collect_block_stats" begin

        df_stats_1 = collect_block_stats(AUTH, 700_000, 700_010)
        rows, cols = size(df_stats_1)
        @test rows == 11 && cols == 28

        df_stats_2 = collect_block_stats(AUTH, 700_000, 700_100, 
                                         stats = ["avgfee", "utxo_increase"])
        rows, cols = size(df_stats_2)
        @test rows == 101 && cols == 2

    end

end
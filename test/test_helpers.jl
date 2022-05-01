# Run tests on helper functions

@testset verbose = true "Helper functions" begin

    @testset "collect_block_stats" begin

        df_stats = collect_block_stats(AUTH, 700_000, 700_010)
        rows, cols = size(df_stats)
        @test rows == 11 && cols == 28

    end

end
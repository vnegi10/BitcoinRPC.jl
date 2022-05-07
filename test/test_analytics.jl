# Run tests on functions for blockchain and network analytics

@testset verbose = true "Analytics functions" begin

    @testset "collect_block_stats" begin

        df_stats_1 = collect_block_stats(AUTH, 700_000, 700_010)
        rows, cols = size(df_stats_1)

        @test rows == 11 && cols == 28
        @test df_stats_1[!, :avgtxsize][5] == 831
        @test df_stats_1[!, :maxtxsize][10] == 46079

        df_stats_2 = collect_block_stats(AUTH, 700_000, 700_100, 
                                         stats = ["avgfee", "utxo_increase"])                                         
        rows, cols = size(df_stats_2)

        @test rows == 101 && cols == 2
        @test df_stats_2[!, :utxo_increase][5] == -129
        @test isapprox(df_stats_2[!, :avgfee][10], 3.048e-5; atol = 1e-5)

        # Test if batch mode results are the same as in normal mode
        df_stats_1b = collect_block_stats_batch(AUTH, 700_000, 700_010, batchsize = 3)
        rows, cols = size(df_stats_1b)
        @test rows == 11 && cols == 28
        @test df_stats_1b[!, :avgtxsize][5] == 831
        @test df_stats_1b[!, :maxtxsize][10] == 46079

        df_stats_2b = collect_block_stats_batch(AUTH, 700_000, 700_100, 
                                                stats = ["avgfee", "utxo_increase"], batchsize = 3)                                         
        rows, cols = size(df_stats_2b)

        @test rows == 101 && cols == 2
        @test df_stats_2b[!, :utxo_increase][5] == -129
        @test isapprox(df_stats_2b[!, :avgfee][10], 3.048e-5; atol = 1e-5)

    end

    @testset "collect_network_stats" begin

        df_stats = collect_network_stats_batch(AUTH, 700_000, 700_100, batchsize = 42)
        rows, cols = size(df_stats)

        @test rows == 101 && cols == 4
        @test isapprox(df_stats[!, :network_hash][5], 1.305148094815497e20; 
                                                             atol = 0.5e20)
        @test df_stats[!, :time][10] == DateTime(2021,9,11,5,13,25)        

    end

end
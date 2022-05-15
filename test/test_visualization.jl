# Run tests on functions for visualization

@testset verbose = true "Plotting functions" begin

    @testset "plot_avg_fee" begin
        plt = plot_avg_fee(AUTH, 1, batchsize = 25)
        @test sizeof(plt) > 0
    end

    @testset "plot_max_fee" begin
        plt = plot_max_fee(AUTH, 1, batchsize = 10)
        @test sizeof(plt) > 0
    end

    @testset "plot_total_fee" begin
        plt = plot_total_fee(AUTH, 1, batchsize = 100)
        @test sizeof(plt) > 0
    end

    @testset "plot_num_txs" begin
        plt = plot_num_txs(AUTH, 1, batchsize = 100)
        @test sizeof(plt) > 0
    end

    @testset "plot_total_output" begin
        plt = plot_total_output(AUTH, 1, batchsize = 250)
        @test sizeof(plt) > 0
    end

    @testset "plot_network_hashrate" begin
        plt = plot_network_hashrate(AUTH, 1, batchsize = 500)
        @test sizeof(plt) > 0
    end

    @testset "plot_network_difficulty" begin
        plt = plot_network_difficulty(AUTH, 1, batchsize = 42)
        @test sizeof(plt) > 0
    end
    
end
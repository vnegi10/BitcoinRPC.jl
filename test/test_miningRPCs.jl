#= Run tests on mining related RPCs: 
show_mining_info, show_network_hashps, =#

@testset verbose = true "Mining related RPCs" begin

    @testset "show_mining_info" begin
        @test ~isempty(show_mining_info(AUTH))        
    end

    @testset "show_network_hashps" begin
        @test ~isempty(show_network_hashps(AUTH, nblocks = 144)) 
        @test isapprox(show_network_hashps(AUTH, height = 144), 900742; atol = 10)            
    end

end
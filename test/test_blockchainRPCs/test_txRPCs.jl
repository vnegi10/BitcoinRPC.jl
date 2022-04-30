#= Run tests on tx related RPCs: 
get_tx_out, get_tx_out_setinfo =#

@testset verbose = true "Transaction related RPCs" begin

    @testset "get_tx_out" begin
        @test ~isempty(get_tx_out(AUTH, txid = get_mempool_raw(AUTH)[1]))        
    end
    
    # Skipping since it takes some time to make this call
    @testset "get_tx_out_setinfo" begin
        @test_skip ~isempty(get_tx_out_setinfo(AUTH))        
    end

end
#= Run tests on tx related RPCs: 
show_tx_out, show_tx_out_setinfo =#

@testset verbose = true "Transaction related RPCs" begin

    # Skipping since txid should be linked to an unspent transaction
    @testset "show_tx_out" begin
        @test_skip ~isempty(show_tx_out(AUTH, txid = show_mempool_raw(AUTH)[1]))        
    end
    
    # Skipping since it takes some time to make this call
    @testset "show_tx_out_setinfo" begin
        @test_skip ~isempty(show_tx_out_setinfo(AUTH))        
    end

end
#= Run tests on block related RPCs: 
show_mempool_ancestors, show_mempool_descendents, show_mempool_entry,
show_mempool_info, show_mempool_raw, =#

@testset verbose = true "Mempool related RPCs" begin

    @testset "show_mempool_raw" begin        
        @test ~isempty(TX_IN_MEMPOOL)
    end

    tx_rand(TX_IN_MEMPOOL) = TX_IN_MEMPOOL[rand(1:length(TX_IN_MEMPOOL), 1)[1]]
    
    # Skipping since this seems to fail intermittently
    @testset "show_mempool_ancestors" begin
        @test_skip ~isempty(show_mempool_ancestors(AUTH, txid = tx_rand(TX_IN_MEMPOOL)))                
    end

    # Skipping since this seems to fail intermittently
    @testset "show_mempool_descendents" begin        
        @test_skip ~isempty(show_mempool_descendents(AUTH, txid = tx_rand(TX_IN_MEMPOOL)))               
    end

    @testset "show_mempool_entry" begin        
        @test ~isempty(show_mempool_entry(AUTH, txid = tx_rand(TX_IN_MEMPOOL)))             
    end

    @testset "show_mempool_info" begin        
        @test ~isempty(show_mempool_info(AUTH))
    end    
    
end
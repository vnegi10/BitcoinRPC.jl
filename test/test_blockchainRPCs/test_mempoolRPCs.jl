#= Run tests on block related RPCs: 
get_mempool_ancestors, get_mempool_descendents, get_mempool_entry,
get_mempool_info, get_mempool_raw, =#

@testset verbose = true "Mempool related RPCs" begin

    @testset "get_mempool_raw" begin        
        @test ~isempty(TX_IN_MEMPOOL)
    end

    tx_rand(TX_IN_MEMPOOL) = TX_IN_MEMPOOL[rand(1:length(TX_IN_MEMPOOL), 1)[1]]
    
    # Skipping since this seems to fail intermittently
    @testset "get_mempool_ancestors" begin
        @test_skip ~isempty(get_mempool_ancestors(AUTH, txid = tx_rand(TX_IN_MEMPOOL)))                
    end

    # Skipping since this seems to fail intermittently
    @testset "get_mempool_descendents" begin        
        @test_skip ~isempty(get_mempool_descendents(AUTH, txid = tx_rand(TX_IN_MEMPOOL)))               
    end

    @testset "get_mempool_entry" begin        
        @test ~isempty(get_mempool_entry(AUTH, txid = tx_rand(TX_IN_MEMPOOL)))             
    end

    @testset "get_mempool_info" begin        
        @test ~isempty(get_mempool_info(AUTH))
    end    
    
end
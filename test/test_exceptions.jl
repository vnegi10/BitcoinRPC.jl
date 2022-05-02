# Test if exceptions are thrown as expected

@testset verbose = true "Exception handling" begin

    # Asking for stats from non-existent blocks
    future_block = show_block_count(AUTH) + 100_000

    @test_throws ErrorException show_block_stats(AUTH; hashORheight = future_block)
    
end    
using leetcode
using Test

@testset "Problem1 tests" begin
    @test leetcode.problem1([2,7,11,15], 9) == [1 2]
    @test leetcode.problem1([2,7,11,15], 13) == [1 3]
    @test leetcode.problem1([6,3,2,4], 6) == [3 4]
    @test leetcode.problem1([3,3], 6) == [1 2]
end

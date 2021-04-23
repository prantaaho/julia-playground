using leetcode
using Test, Documenter

@testset verbose = true "Problem1 tests" begin
    doctest(leetcode, manual=false)
    @test problem1([2,7,11,15], 9) == [1 2]
    @test problem1([2,7,11,15], 13) == [1 3]
    @test problem1([6,3,2,4], 6) == [3 4]
    @test problem1([3,3], 6) == [1 2]
end


@testset verbose = true "Problem7 tests" begin

    @testset verbose = true "a-variant" begin
        doctest(leetcode, manual=false)
        @test problem7a(123) == 321
        @test problem7a(120) == 21
        @test problem7a(0) == 0
        @test problem7a(-456) == -654
        @test problem7a(1123456789) == 0
    end

    @testset verbose = true "b-variant" begin
        doctest(leetcode, manual=false)
        @test problem7b(123) == 321
        @test problem7b(120) == 21
        @test problem7b(0) == 0
        @test problem7b(-456) == -654
        @test problem7b(1123456789) == 0
    end
end



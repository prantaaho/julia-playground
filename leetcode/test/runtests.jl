using leetcode
using Test, Documenter

# Add module level doctest metadata to load module
DocMeta.setdocmeta!(leetcode, :DocTestSetup, :(using leetcode); recursive=true)

@testset verbose = true "Doctests" begin
    doctest(leetcode, manual=false)
end

@testset verbose = true "Problem1 tests" begin
    @test problem1([2,7,11,15], 9) == [1 2]
    @test problem1([2,7,11,15], 13) == [1 3]
    @test problem1([6,3,2,4], 6) == [3 4]
    @test problem1([3,3], 6) == [1 2]
end


@testset verbose = true "Problem7 tests" begin

    @testset verbose = true "a-variant" begin
        @test problem7a(123) == 321
        @test problem7a(120) == 21
        @test problem7a(0) == 0
        @test problem7a(-456) == -654
        @test problem7a(1123456789) == 0
    end

    @testset verbose = true "b-variant" begin
        @test problem7b(123) == 321
        @test problem7b(120) == 21
        @test problem7b(0) == 0
        @test problem7b(-456) == -654
        @test problem7b(1123456789) == 0
    end
end

@testset verbose = true "Problem9 tests" begin
    @test problem9(121) == true
    @test problem9(123) == false
    @test problem9(-121) == false
    @test problem9(12321) == true
    @test problem9(0) == true
end

@testset verbose = true "Problem12 tests" begin
    @test problem12(3) == "III"
    @test problem12(5) == "V"
    @test problem12(4) == "IV"
    @test problem12(146) == "CXLVI"
    @test problem12(442) == "CDXLII"
    @test problem12(2888) == "MMDCCCLXXXVIII"
    @test problem12(1996) == "MCMXCVI"
end

@testset verbose = true "Problem13 tests" begin
    @test problem13("III") == 3
    @test problem13("V") == 5
    @test problem13("IV") == 4
    @test problem13("CXLI") == 141
    @test problem13("CDXLII") == 442
    @test problem13("MMCMX") == 2910
    @test problem13("MCMXCVI") == 1996
end

@testset verbose = true "Problem14 tests" begin
    @test problem14(["flower","flow","flight"]) == "fl"
    @test problem14(["dog","racecar","car"]) == ""
    @test problem14(["flower","flow"]) == "flow"
end

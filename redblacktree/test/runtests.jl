using redblacktree
using Test


@testset verbose = true "RBNode tests" begin
    
    # Simple node
    n = RBNode(5, "foo")
    @test n.key == 5
    @test n.parent === nothing
    @test n.left === nothing
    @test n.right === nothing

end

@testset verbose = true "Tree rotate tests" begin

    @testset "Left rotate" begin
        t = RedBlackTree(RBNode(4, "b"))
        insert!(t, 6, "b")
        insert!(t, 8, "b")
    
        @test t.root.key == 6
        @test t.root.left.key == 4
        @test t.root.right.key == 8            
    end

    @testset "Right rotate" begin
        t = RedBlackTree(RBNode(8, "b"))
            insert!(t, 6, "b")
            insert!(t, 4, "b")

            @test t.root.key == 6
            @test t.root.left.key == 4
            @test t.root.right.key == 8
    end

    @testset "Right-left rotate" begin
        t = RedBlackTree(RBNode(4, "b"))
        insert!(t, 8, "b")
        insert!(t, 6, "b")

        @test t.root.key == 6
        @test t.root.left.key == 4
        @test t.root.right.key == 8
    end

    @testset "Left-right rotate" begin
        t = RedBlackTree(RBNode(8, "b"))
        insert!(t, 4, "b")
        insert!(t, 6, "b")

        @test t.root.key == 6
        @test t.root.left.key == 4
        @test t.root.right.key == 8
    end
end
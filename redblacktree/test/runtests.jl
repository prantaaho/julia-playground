using redblacktree
using Test


@testset verbose = true "RBNode tests" begin
    
    # Simple node
    n = RBNode(5)
    @test n.key == 5
    @test n.parent === nothing
    @test n.left === nothing
    @test n.right === nothing

end

@testset "Tree rotate tests" begin

    @testset "Left rotate" begin
        t = RedBlackTree(RBNode(4))
        insert!(t, 6)
        insert!(t, 8)
    
        @test t.root.key == 6
        @test t.root.left.key == 4
        @test t.root.right.key == 8            
    end

    @testset "Right rotate" begin
        t = RedBlackTree(RBNode(8))
            insert!(t, 6)
            insert!(t, 4)

            @test t.root.key == 6
            @test t.root.left.key == 4
            @test t.root.right.key == 8
    end

    @testset "Right-left rotate" begin
        t = RedBlackTree(RBNode(4))
        insert!(t, 8)
        insert!(t, 6)

        @test t.root.key == 6
        @test t.root.left.key == 4
        @test t.root.right.key == 8
    end

    @testset "Left-right rotate" begin
        t = RedBlackTree(RBNode(8))
        insert!(t, 4)
        insert!(t, 6)

        @test t.root.key == 6
        @test t.root.left.key == 4
        @test t.root.right.key == 8
    end

    @testset "Multiple inserts" begin
        t = RedBlackTree(RBNode(6))
        for k ∈ (10, 8, 4, 7, 5)
            insert!(t, k)
        end
    end
end

@testset verbose = true "Node search" begin
    
    @testset "hashkey" begin
        t = RedBlackTree(RBNode(6))
        insert!(t, 4)
        insert!(t, 8)
        insert!(t, 5)
        
        @test haskey(t, 6)
        @test haskey(t, 4)
        @test haskey(t, 5)
        @test haskey(t, 8)

        @test 5 in t
        # @test 7 ∉ t  # Requires iterate to be implemented
    end
end 

@testset verbose = true "Node deletions" begin
    
    @testset "leafnode" begin
        # Right leaf
        t = RedBlackTree(RBNode(6))
        insert!(t, 4)
        insert!(t, 8)
        
        delete!(t, 8)

        @test t.root.key == 6
        @test t.root.right === nothing
        @test t.root.left.key == 4
        @test t.size == 2

        # Left leaf
        t = RedBlackTree(RBNode(6))
        insert!(t, 4)
        insert!(t, 8)
        delete!(t, 4)

        @test t.root.key == 6
        @test t.root.left === nothing
        @test t.root.right.key == 8
        @test t.size == 2

    end

    @testset "other deletions" begin
        # Second level delete
        t = RedBlackTree(RBNode(6))
        for k ∈ (10, 8, 4, 7, 5)
            insert!(t, k)
        end

        delete!(t, 6)
        @test black_nodes(t) == 3

        # Bigger tree
        t = RedBlackTree(RBNode(6))
        for k ∈ (10, 3, 2, 8, 4, 7, 5)
            insert!(t,k)
        end

        delete!(t, 3)
        @test black_nodes(t) == 3

    end

end 
module redblacktree

export RBNode, RedBlackTree, plottree, black_nodes, height

import Base: insert!, delete!, haskey, in, length

using Plots

mutable struct RBNode{K}
    key::K
    parent::Union{RBNode{K}, Nothing}
    left::Union{RBNode{K}, Nothing}
    right::Union{RBNode{K}, Nothing}
    is_red::Bool
    is_left::Bool
end
	
function RBNode(key)
    RBNode(key, nothing, nothing, nothing, true, false)
end


mutable struct RedBlackTree{K}
    root::Union{RBNode{K}, Nothing}
    size::Int
end

function RedBlackTree(key::K) where K
    n = RBNode(key)
    n.is_red = false
    RedBlackTree(n, 1)
end

function RedBlackTree(n::RBNode{K}) where K
    n.is_red = false
    RedBlackTree(n, 1)
end

Base.length(tree::RedBlackTree) = tree.size


function left_rotate!(tree::RedBlackTree, node::RBNode)
    tmp = node.right
    node.right = tmp !== nothing ? tmp.left : nothing
    if node.left !== nothing
        node.right.parent = node
        node.right.is_left = false
    end
    tmp.parent = node.parent
    if tmp.parent === nothing
        node.is_red = tmp.is_red
        tree.root = tmp
        tree.root.is_red = false
    else
        if node.is_left
            tmp.is_left = true
            tmp.parent.left = tmp
        else
            tmp.is_left = false
            tmp.parent.right = tmp
        end
    end
    tmp.left = node
    node.is_left = true
    node.parent = tmp
end

function right_rotate!(tree::RedBlackTree, node::RBNode)
    tmp = node.left
    node.left = tmp !== nothing ? tmp.right : nothing
    if node.left !== nothing
        node.left.parent = node
        node.left.is_left = true
    end
    tmp.parent = node.parent
    if tmp.parent === nothing
        node.is_red = tmp.is_red
        tree.root = tmp
        tree.root.is_red = false
    else
        if node.is_left
            tmp.is_left = true
            tmp.parent.left = tmp
        else
            tmp.is_left = false
            tmp.parent.right = tmp
        end
    end
    tmp.right = node
    node.is_left = false
    node.parent = tmp
end
    
function left_right_rotate!(tree::RedBlackTree, node::RBNode)
    left_rotate!(tree, node.parent)
    right_rotate!(tree, node.parent)
end

function right_left_rotate!(tree::RedBlackTree, node::RBNode)
    right_rotate!(tree, node.parent)
    left_rotate!(tree, node.parent)
end

function rotate(tree::RedBlackTree, node::RBNode)
    if node.is_left
        if node.parent.is_left
            right_rotate!(tree, node.parent.parent)
            node.is_red = true
            node.parent.is_red = false
            if node.parent.right !== nothing
                node.parent.right.is_red = true
            end
        else
            right_left_rotate!(tree, node)
            node.is_red = false
            node.right.is_red = true
            node.left.is_red = true
        end
    else
        if !node.parent.is_left
            left_rotate!(tree, node.parent.parent)
            node.is_red = true
            node.parent.is_red = false
            if node.parent.right !== nothing
                node.parent.right.is_red = true
            end
        else
            left_right_rotate!(tree, node)
            node.is_red = false
            node.right.is_red = true
            node.left.is_red = true
        end
    end
end

function correct_tree(tree::RedBlackTree, node::RBNode)
    if node.parent.parent === nothing
        aunt = nothing
    else
        if node.parent.is_left
            aunt = node.parent.parent.right
        else
            aunt = node.parent.parent.left
        end
    end
    if aunt === nothing || !aunt.is_red
        return rotate(tree, node)
    end
    # Do color flip
    if aunt !== nothing
        aunt.is_red = false
    end
    node.parent.parent.is_red = true
    node.parent.is_red = false
    tree.root.is_red = false
end

function check_color(tree::RedBlackTree, node::Nothing)
end

function check_color(tree::RedBlackTree, node::RBNode)
    if node.parent === nothing
        return
    end
    if node.is_red && node.parent.is_red
        correct_tree(tree, node)
    end
    check_color(tree, node.parent)
end

function add_child!(parent::RBNode{K}, new_node::RBNode{K}) where K
    if parent.key == new_node.key
        return false
    end
    if new_node.key < parent.key
        if parent.left === nothing
            parent.left = new_node
            new_node.is_left = true
            new_node.parent = parent
        else
            add_child!(parent.left, new_node)
        end
    else
        if parent.right === nothing
            parent.right = new_node
            new_node.is_left = false
            new_node.parent = parent
        else
            add_child!(parent.right, new_node)
        end
    end
    new_node.is_red = true
end
 
function insert!(tree::RedBlackTree{K}, new_node::RBNode{K}) where K
    if tree.root === nothing
        tree.root = new_node
        tree.root.is_red = false
        tree.size = 1
    else
        if add_child!(tree.root, new_node)			
            tree.size = tree.size + 1
            check_color(tree, new_node)
        end
    end
end

function insert!(tree::RedBlackTree{K}, key::K) where K
    node = RBNode(key)
    insert!(tree, node)
end

function height(node::Nothing)
    0
end
    
function height(node::RBNode)
    left_height = height(node.left) + 1
    right_height = height(node.right) + 1
    max(left_height, right_height)
end

function height(tree::RedBlackTree)
    height(tree.root)
end


function black_nodes(node::Nothing)
    1
end

function black_nodes(node::RBNode)
    right_black_nodes = black_nodes(node.right)
    left_black_nodes = black_nodes(node.left)		
    @assert right_black_nodes == left_black_nodes "Black nodes don't match :("
    if !node.is_red
        left_black_nodes = left_black_nodes + 1
    end
    left_black_nodes
end

function black_nodes(tree::RedBlackTree)
    black_nodes(tree.root)
end


function search_tree(node::RBNode{K}, key::K) where K
    if node.key == key
        return node
    elseif node.left !== nothing && node.key > key 
        return search_tree(node.left, key)
    elseif node.right !== nothing && node.key < key 
        return search_tree(node.right, key)
    end
    return nothing
end

function Base.haskey(tree::RedBlackTree{K}, key::K) where K
    return search_tree(tree.root, key) !== nothing
end

Base.in(key, tree::RedBlackTree) = haskey(tree::RedBlackTree, key)

function remove_leaf!(tree::RedBlackTree{K}, node::RBNode{K}) where K
    @assert node.left === nothing && node.right === nothing "Not a leaf node $(node.key)"
    if node.is_left
        node.parent.left = nothing
    else
        node.parent.right = nothing
    end
    tree.size -= 1
    return tree
end

function Base.delete!(tree::RedBlackTree{K}, key::K) where K
    node = search_tree(tree.root, key)
    if node === nothing
        return tree
    end
    return delete!(tree, node)
end

function Base.delete!(tree::RedBlackTree{K}, node::RBNode{K}) where K
    if node === nothing
        return tree
    end
    # Remove leaf node
    if node.left === nothing && node.right === nothing
        return remove_leaf!(tree, node)
    end

    # Find the closest nodes
    replacement_r = node.right
    if replacement_r !== nothing
        while replacement_r.left !== nothing
            replacement_r = replacement_r.left
        end
    end
    replacement_l = node.left
    if replacement_l !== nothing
        while replacement_l.right !== nothing
            replacement_l = replacement_l.right
        end
    end

    # Replace node with leaf and remove leaf
    if replacement_r !== nothing
        node.key = replacement_r.key
        delete!(tree, replacement_r)
        if ! replacement_r.is_red  # Removal of black node causes imbalance
            correct_tree(tree, replacement_l)
        end
    else
        node.key = replacement_l.key
        delete!(tree, replacement_l)
        if ! replacement_l.is_red  # Removal of black node causes imbalance
            correct_tree(tree, replacement_r)
        end
    end
    return tree
end

#=
begin
	insert!(t2, 1, "b")
	insert!(t2, 0, "b")
	insert!(t2, 10, "b")
	#insert!(t2, 5, "b")
	insert!(t2, 15, "b")
	insert!(t2, 12, "b")
	t2
end
=#

function plot_node!(node::RBNode, x, y, px, py, scale)
    rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])

    bw = 1.2
	bh = 0.45

    if node.left !== nothing
        plot_node!(node.left, x - (scale/2), y - 1.2, x, y, scale/2)
    end
    if node.right !== nothing
        plot_node!(node.right, x + (scale/2) , y - 1.2, x, y, scale/2)
    end
    plot!([x, px].+0.5*bw, [y, py].+0.5*bh, color=:black)
    plot!(rectangle(bw,bh,x,y), color=node.is_red ? :darkred : :gray40, 
    annotations=(x + 0.5*bw, y + 0.5*bh, text("$(node.key)", :green3)))
end

function plottree(tree::RedBlackTree)
	x = 1
	y = 10
	plot(x, y, legend=:none)
	plot_node!(tree.root, x, y, x,y, height(tree)^2)
	
end

end # module

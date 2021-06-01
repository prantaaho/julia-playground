module redblacktree

export RBNode, RedBlackTree

import Base: insert!

# using Plots

mutable struct RBNode{K,V}
    key::K
    value::V
    parent::Union{RBNode{K,V}, Nothing}
    left::Union{RBNode{K,V}, Nothing}
    right::Union{RBNode{K,V}, Nothing}
    is_red::Bool
    is_left::Bool
end
	
function RBNode(key, value)
    RBNode(key, value, nothing, nothing, nothing, true, false)
end


mutable struct RedBlackTree
    root::Union{RBNode, Nothing}
    size::Int
end

function RedBlackTree(key, value)
    n = RBNode(key,value)
    n.is_red = false
    RedBlackTree(n, 1)
end

function RedBlackTree(n::RBNode)
    n.is_red = false
    RedBlackTree(n, 1)
end

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

function add_child!(parent::RBNode, new_node::RBNode)
    if parent.key == new_node.key
        parent.value = new_node.value
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
        
function insert!(tree::RedBlackTree, new_node::RBNode)
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

function insert!(tree::RedBlackTree, key, value)
    node = RBNode(key, value)
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

# ╔═╡ 0b6a7cc9-e70d-4109-bc6c-702effae6ba9
let
	rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])
	
	bw = 1.2
	bh = 0.45
	
	x = 10
	y = 10

	function plot_node!(node::RBNode, x, y, px, py, scale)
		if node.left != nothing
			plot_node!(node.left, x - (scale), y - 1.2, x, y, scale-1)
		end
		if node.right != nothing
	  		plot_node!(node.right, x + (scale) , y - 1.2, x, y, scale-1)
		end
		plot!([x, px].+0.5*bw, [y, py].+0.5*bh, color=:black)
		plot!(rectangle(bw,bh,x,y), color=node.is_red ? :darkred : :gray40, 
		annotations=(x + 0.5*bw, y + 0.5*bh, text("$(node.key): $(node.value)", :green3)))
	end

	plot(x, y, legend=:none)
	plot_node!(t2.root, x, y, x,y, height(t2))

	
end

# ╔═╡ c499645e-4f83-4c84-af11-cad560b46288
"[$(t.root.key)]"

# ╔═╡ Cell order:
# ╠═c6b0f5a7-dd39-42c7-9cbd-64844235f135
# ╠═32a43c3f-3c37-4642-bbc5-0c536619f2c4
# ╠═480bd3ee-713f-4ff5-b3a6-3b4373884a5b
# ╠═c1ea8484-c10b-4ab6-966e-fdc356fd486c
# ╠═5fbb1e84-9968-4dcf-b726-4da7cfe6c859
# ╠═6a2095d7-0809-43bc-81af-8cad3bb9d9d1
# ╠═b9f6884e-92a1-4f60-a339-8263cd1878cd
# ╠═01692ce8-7882-4189-9af1-e9282aac0d6e
# ╠═0b6a7cc9-e70d-4109-bc6c-702effae6ba9
# ╠═c499645e-4f83-4c84-af11-cad560b46288

=#
end # module

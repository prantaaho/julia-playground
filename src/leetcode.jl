module leetcode

export problem1, problem7a, problem7b

"""
    problem1(nums::Vector{Int}, trgt::Int)

Given an array of integers nums and an integer target, return indices of the two
numbers such that they add up to target.

You may assume that each input would have exactly one solution, and you may not
use the same element twice.

Constraints:

* 2 <= nums.length <= 10^3
* ``-10^9`` <= nums[i] <= ``10^9``
* ``-10^9`` <= target <= ``10^9``
* Only one valid answer exists.

[https://leetcode.com/problems/two-sum/](https://leetcode.com/problems/two-sum/)

# Examples
```jldoctest; setup = :(using leetcode)
julia> problem1([8,3,4,5], 8)
1×2 Matrix{Int64}:
 2  4
```
"""
function problem1(nums::Vector{Int}, trgt::Int)
    for (idx1, val1) in enumerate(nums)
        val1 >= trgt && continue
        for (idx2, val2) in enumerate(nums[idx1+1:end])
            val1 + val2 == trgt && return idx1 .+ [0 idx2]
        end
    end
end  # problem1


"""
    problem7a(x::Int)

Given a signed 32-bit integer ``x``, return ``x`` with its digits reversed. If reversing
``x`` causes the value to go outside the signed 32-bit integer range ``[-2^{31}, 2^{31} -
1]``, then return 0.

a-variant is solution with integer arithmetics.

# Examples
```jldoctest; setup = :(using leetcode)
julia> problem7a(123)
321

julia> problem7a(-123)
-321
````
"""
function problem7a(x::Int32)
    y = abs(x)
    inverse::Int32 = 0
    try
        while y > 0
            inverse = inverse * 10 + y % 10
            y = y ÷ 10
        end
        sign(x) * inverse
    catch InexactError
        0
    end
end
function problem7a(x::Int64)
    try
        problem7a(Int32(x))
    catch InexactError
        0
    end
end

"""
    problem7b(x::Int)

Given a signed 32-bit integer ``x``, return ``x`` with its digits reversed. If reversing
``x`` causes the value to go outside the signed 32-bit integer range ``[-2^{31}, 2^{31} -
1]``, then return 0.

b-variant is solution with string casting.

# Examples
```jldoctest; setup = :(using leetcode)
julia> problem7b(123)
321

julia> problem7b(-123)
-321
````
"""
function problem7b(x::Int)
    try
        sign(x) * parse(Int32, reverse(string(abs(x))))
    catch InexactError
        0
    end
end

end # module

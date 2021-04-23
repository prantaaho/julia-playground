module leetcode

"""
Given an array of integers nums and an integer target, return indices of the two
numbers such that they add up to target.

You may assume that each input would have exactly one solution, and you may not
use the same element twice.

Constraints:

* 2 <= nums.length <= 10^3
* -10^9 <= nums[i] <= 10^9
* -10^9 <= target <= 10^9
* Only one valid answer exists.

https://leetcode.com/problems/two-sum/

# Examples

"""
function problem1(nums::Vector{Int}, trgt::Int)
    for (idx1, val1) in enumerate(nums)
        val1 >= trgt && continue
        for (idx2, val2) in enumerate(nums[idx1+1:end])
            val1 + val2 == trgt && return idx1 .+ [0 idx2]
        end
    end
end

end # module

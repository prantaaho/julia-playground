module leetcode

export problem1, problem7a, problem7b, problem9, problem12, problem13, problem14

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

## Examples
```jldoctests
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
    problem7a(x::Int32)
    problem7a(x::Int64)

Given a signed 32-bit integer ``x``, return ``x`` with its digits reversed. If reversing
``x`` causes the value to go outside the signed 32-bit integer range ``[-2^{31}, 2^{31} -
1]``, then return 0.

a-variant is solution with integer arithmetics.

## Examples
```jldoctests
julia> problem7a(123)
321

julia> problem7a(-123)
-321
```
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

## Examples
```jldoctests
julia> problem7b(123)
321

julia> problem7b(-123)
-321
```
"""
function problem7b(x::Int)
    try
        sign(x) * parse(Int32, reverse(string(abs(x))))
    catch InexactError
        0
    end
end


"""
    problem9(x::Int)

Given an integer x, return true if x is palindrome integer.

An integer is a palindrome when it reads the same backward as forward. For
example, 121 is palindrome while 123 is not.

## Examples
```jldoctests
julia> problem9(121)
true

julia> problem9(123)
false
```
"""
function problem9(x::Int)
    s = string(x)
    s == reverse(s)
end


"""
    problem12(x::Int)

Roman numerals are represented by seven different symbols: ``I, V, X, L, C, D``
and ``M``.

| Symbol | Value
|--------|--------
|  I     |   1
|  V     |   5
|  X     |   10
|  L     |   50
|  C     |   100
|  D     |   500
|  M     |   1000


For example, 2 is written as ``II`` in Roman numeral, just two one's added
together. 12 is written as ``XII``, which is simply ``X + II``. The number 27 is
written as ``XXVII``, which is ``XX + V + II``.

Roman numerals are usually written largest to smallest from left to right.
However, the numeral for four is not ``IIII``. Instead, the number four is written
as ``IV``. Because the one is before the five we subtract it making four. The same
principle applies to the number nine, which is written as ``IX``. There are six
instances where subtraction is used:

* ``I`` can be placed before ``V`` (5) and ``X`` (10) to make 4 and 9. 
* ``X`` can be placed before``L`` (50) and ``C`` (100) to make 40 and 90. 
* ``C`` can be placed before ``D`` (500) and ``M`` (1000) to make 400 and 900. 

Given an integer, convert it to a roman numeral.

## Examples

```jldoctests
julia> problem12(3)
"III"

julia> problem12(42)
"XLII"

julia> problem12(0)
ERROR: ArgumentError: Input value must be in ]0,4000[
[...]
```
"""
function problem12(x::Int)
    if ! (0 < x < 4000)
        throw(ArgumentError("Input value must be in ]0,4000["))
    end
    romandecs = ['M' 'C' 'X' 'I'; ' ' 'D' 'L' 'V'; ' ' 'M' 'C' 'X']
    roman = ""
    for p in 3:-1:0
        div = x ÷ 10^p
        x = x % 10^p
        if div < 4
            roman *= romandecs[1,4-p]^div
        elseif div == 4
            roman *= romandecs[1,4-p] * romandecs[2,4-p]
        elseif div < 9
            roman *= romandecs[2,4-p] * romandecs[1,4-p]^(div-5)
        else
            roman *= romandecs[1,4-p] * romandecs[3,4-p]
        end
    end
    roman
end


"""
    problem13(romannumber::String)

Roman numerals are represented by seven different symbols: ``I, V, X, L, C, D``
and ``M``.

| Symbol | Value 
|--------|-------
|  I     | 1 
|  V     | 5 
|  X     | 10 
|  L     | 50 
|  C     | 100 
|  D     | 500 
|  M     | 1000

For example, 2 is written as ``II`` in Roman numeral, just two one's added together.
12 is written as ``XII``, which is simply ``X + II``. The number 27 is written as ``XXVII``,
which is ``XX + V + II``.

Roman numerals are usually written largest to smallest from left to right.
However, the numeral for four is not ``IIII``. Instead, the number four is written
as ``IV``. Because the one is before the five we subtract it making four. The same
principle applies to the number nine, which is written as ``IX``. There are six
instances where subtraction is used:

* ``I`` can be placed before ``V`` (5) and ``X`` (10) to make 4 and 9. 
* ``X`` can be placed before``L`` (50) and ``C`` (100) to make 40 and 90. 
* ``C`` can be placed before ``D`` (500) and ``M`` (1000) to make 400 and 900. 

Given a roman numeral, convert it to an integer

## Examples

```jldoctests
julia> problem13("XLII")
42
```
"""
function problem13(romannumber::String)
    romans = Dict('I' => 1, 'V' => 5, 'X' => 10, 'L' => 50, 'C' => 100, 'D' => 500, 'M' => 1000)
    decimal = 0
    prev = 0
    for char in romannumber
        val = romans[char]
        # Set ENV["JULIA_DEBUG"] = leetcode to enable logging
        # @debug "Variables: " prev val
        if prev > 0 && prev < val
            decimal += val - prev
            prev = 0
        else
            decimal += prev
            prev = val
        end
    end
    decimal += prev
end

"""
    problem14(words::Vector{String})

Write a function to find the longest common prefix string amongst an array of strings.

If there is no common prefix, return an empty string "".

## Examples

```jldoctests
julia> problem14(["flower","flow","flight"])
"fl"
```
"""
function problem14(words::Vector{String})
    common = ""
    for letters in zip(words...)
        if length(unique(letters)) == 1  # Could also use Set
            common *= letters[1]
        else
            break
        end
    end
    common
end

end # module

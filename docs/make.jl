# Add module source to load path
push!(LOAD_PATH,"../src/")

using Documenter, leetcode

# Add module level doctest metadata to load module
DocMeta.setdocmeta!(leetcode, :DocTestSetup, :(using leetcode); recursive=true)

# Generate docs
makedocs(
    root    = ".",
    source  = "src",
    build   = "build",
    clean   = true,
    doctest = true,
    modules = Module[leetcode],
    repo    = "",
    highlightsig = true,
    sitename = "LeetCode",
    expandfirst = [],
)

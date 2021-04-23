# LeetCode excercises with Julia

## Packages

* **Revise** for reloading modified package automaticaly to REPL.
* **Test** for unit tests
* **Documenter** for doctests

## Building documentation

Run in `docs` directory:

    julia --project=.. -- make.jl

## Running tests

    pkg> activate
    pkg> test

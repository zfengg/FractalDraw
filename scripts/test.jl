using DrWatson
quickactivate(findproject())

using Pkg
Pkg.instantiate()

# include(srcdir("IFSs.jl"))
# using IFSs

include(srcdir("IFS.jl"))

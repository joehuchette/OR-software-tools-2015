Pkg.add("SimJulia")
using SimJulia
include(Pkg.dir("SimJulia") * "/test/example_1.jl")

addprocs(2)

@parallel for i in 1:2
	println("Hello from core $(myid())")
end
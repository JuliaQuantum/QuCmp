module QuCmp

using QuBase,QuDynamics

export ComputBasis

abstract AbstractQC{N}

ComputBasis(n::Int) = FiniteBasis(ntuple(x->2,n))


include("const.jl")
include("utils/LogicExpr.jl")
include("utils/math.jl")
include("Adiabatic/Adiabatic.jl")
include("circuit/Circuit.jl")

end # module

using Expokit
import Base: show,bin
export Gate,Hadamard,X,Y,Z,Circuit,addgate!,HadamardUnit

abstract QuCircuit{N}<:AbstractQC{N}

include("state.jl")
include("op.jl")
include("gates.jl")
include("qcircuit.jl")
include("process.jl")
include("chp.jl")

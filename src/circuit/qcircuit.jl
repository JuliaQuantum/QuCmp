############################
# Circuits
############################

type Circuit{N} <: QuCircuit{N}
    gates::Array{GateUnit,1}
end

Circuit(num::Integer,gates::Array{GateUnit,1}) = Circuit{num}(gates)
Circuit(num::Integer)=Circuit{num}(Array(GateUnit,0))

# TODO
# function show(io::IO,circuit::Circuit)
# end


############################
# Circuit Constructor
############################

max(a::Int) = a

# NOTE
# Should we open AbstractGateUnit as API for users?

function addgate!{N,M}(circuit::QuCircuit{N},gate::AbstractGateUnit{M})
  push!(circuit.gates,gate)
  sort!(circuit,gates,alg=QuickSort,by=x->x.pos[1])
end

# For gate units
function addgate!{T,N,M}(circuit::QuCircuit{N},gate::Gate{T,M},pos::Vector{Int})
    # Bounds check
    @assert length(pos)==M+1 "number of qubits do not match"
    @assert maximum(pos[2:end])<=N "bit's id out of range, maximum is $N"

    addgate!(circuit,GateUnit(gate,pos))
end

addgate!{T,N,M}(circuit::QuCircuit{N},gate::Gate{T,M},pos::Int...) = addgate!(circuit,gate,collect(pos))

# for controled gates
function addgate!{T,N,M}(circuit::QuCircuit{N},gate::Gate{T,M},pos::Vector{Int},ctrl::Vector{Int})
    # Bounds check
    @assert length(pos)+length(ctrl) == M+1
    @assert max(maximum(pos[2:end]),maximum(ctrl)) <= N "bit's id out of range, maximum is $N"

    addgate!(circuit,CtrlGateUnit(gate,pos,ctrl))
end

function removegate!{N}(circuit::QuCircuit{N},pos::Vector{Int})
    for i in eachindnex(circuits.gates)
        if circuits.gates.pos == pos
            deleteat!(circuits.gates,i)
        end
    end
end

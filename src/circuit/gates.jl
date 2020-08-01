##########################
# Gates
##########################

type Gate{T,N}
    name::AbstractString
    op::AbstractOp{T,N}
    Gate{T,N}(name::AbstractString,op::AbstractOp{T,N}) = new(name,op)
end

Gate{N}(name::AbstractString,op::MatrixOp{N})=Gate{AbstractMatrix,N}(name,op)

Hadamard = Gate("Hadamard gate",OP_Hadamard)
X        = Gate("Paili X",OP_sigmax)
Y        = Gate("Paili Y",OP_sigmay)
Z        = Gate("Paili Z",OP_sigmaz)

function call{T,N}(gate::Gate{T,N})
    return gate.op()
end


"""
An AbstractGateUnit should at least contain one element called `pos`,
for definition of `pos`, please refer to the docs of `GateUnit`
"""
abstract AbstractGateUnit{N}


"""
GateUnit
---

GateUnit is for the gate unit in a circuit

pos:
the first number in pos is the the column number
the second number in pos is the bits' IDs that is realted to this gate
eg.

'''
  --block 1--|----block 2----|
1 -----------|---------------|
2 ----[A]----|---------------|
3 -----------|---------------|
4 -----------|-----[   ]-----|
5 -----------|-----[ B ]-----|
6 -----------|-----[   ]-----|
'''

The position of gate B is (2,4,5,6)
"""

type GateUnit{T,N}<:AbstractGateUnit{N}
    gate::Gate{T,N}
    pos::Vector{Int}
    # TODO : time layer?
    # time_layer::Real

    GateUnit{T,N}(gate::Gate{T,N},pos::Vector{Int})=new(gate,pos)
end

GateUnit{T,N}(gate::Gate{T,N},pos::Vector{Int}) = GateUnit{T,N}(gate,pos)
GateUnit{T,N}(gate::Gate{T,N},pos::Tuple{Int}) = GateUnit{T,N}(gate,collect(pos))
GateUnit{T,N}(gate::Gate{T,N},pos::Int...) = GateUnit{T,N}(gate,collect(pos))

type CtrlGateUnit{T,N}<:AbstractGateUnit{N}
    gate::Gate{T,N}
    pos::Vector{Int}
    ctrl::Vector{Int}
end

# CtrlGateUnit{T,N}(gate::Gate{T,N},pos::Vector{Int},ctrl::Vector{Int}) = CtrlGateUnit{T,N}(gate,pos,ctrl)

bitnum{N}(unit::AbstractGateUnit{N}) = N

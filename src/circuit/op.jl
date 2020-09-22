abstract AbstractOp{T,N}

##################################
#  Matrix Operators
##################################

type MatrixOp{N}<:AbstractOp{AbstractMatrix,N}
    name::AbstractString
    mat::AbstractMatrix
end

MatrixOp(num::Integer,name::AbstractString,mat::AbstractMatrix) = MatrixOp{num}(name,mat)

function call{N}(matop::MatrixOp{N})
    return [matop.mat[:,i] for i=1:size(matop.mat,2)]
end

function call{N}(matop::MatrixOp{N},state::AbstractVector)
    return matop.mat*state
end

function show{N}(io::IO,matop::MatrixOp{N})
    println("$N bits matrix operator $(matop.name):")
    show(matop.mat)
end


OP_Hadamard = MatrixOp(1,"Hadamard",hadamard)
# Pauli Groups
OP_sigmax   = MatrixOp(1,"Pauli Sigma X",σ₁)
OP_sigmay   = MatrixOp(1,"Pauli Sigma Y",σ₂)
OP_sigmaz   = MatrixOp(1,"Pauli Sigma Z",σ₃)

# TODO
# this comes from linalg/uniformscaling.jl
# same operators should be overloaded
immutable IdentityOp{T<:Number}<:AbstractOp{T}
    λ::T
end

OP_I = IdentityOp(1)

##################################
# Function Operators
##################################

const FUNCTION_OP_PARA_INF = -1

"""
Function operators should be able to accept AbstractSparseVector inputs

The member `f` should be an one input only function
"""
type FunctionOp{N}<:AbstractOp{Function,N}
    name::AbstractString
    f::Function
end

function basis(n::Int)
    return [i->sparsevec(Dict[i=>1]) for i=1:2^n]
end

function call{N}(funcop::FunctionOp{N})
    res = Array(Array{Complex,1},0)
    for i in basis(N)
        push!(res,funcop.f(i))
    end
    return res
end

function call{N}(funcop::FunctionOp{N},state::AbstractVector)
    return funcop(state)
end

function TimeOp{N}(state::QuState{N};Hamiltonian=I,dt=1e-6)
    return expmv(-im*dt,Hamiltonian,state.s)
end

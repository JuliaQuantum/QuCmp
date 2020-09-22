
import Base: +,-,*,/,^
export stlzState

# TODO: QuIDD

# NOTE
# N is the number of bits in a quantum array

abstract AbstractQuArray{N}

# TODO
# QuIDD encoding array
# type QuIDDArray{T,N}<:AbstractQuArray{N}
# end

type QuState{T,N}<:AbstractQuArray{N}
    s::AbstractVector{T}
end

(+)(A::QuState,B::QuState) = A.s+B.s
(-)(A::QuState,B::QuState) = A.s-B.s
(*)(A::QuState,B::QuState) = A.s*B.s
(/)(A::QuState,B::QuState) = A.s/B/s
(^)(A::QuState,b::Real) = A.s^b


# TODO
# show(io::IO,state::AbstractQuArray)
# show(io::IO,state::QuState)
# show(io::IO,state::QuIDDArray)

type stlzState{N}<:AbstractQuArray{N}
    X::AbstractMatrix # (2n+1)*n matrix for stabilizer/destabilizer x bits
    Z::AbstractMatrix # (2n+1)*n matrix for z bits
    R::AbstractVector # phase bits: 0 for +1, 1 for i, 2 for -1, 3 for -i. Normally either 0 or 2
end

stlzState(X::BitMatrix,Z::BitMatrix,R::BitVector) = stlzState{length(R)/2}(X,Z,R)

function stlzState(n::Int)
    X = spzeros(Bool,2n,n)
    Z = spzeros(Bool,2n,n)
    R = spzeros(Bool,2n)

    X[1:n,:] = speye(n)
    Z[n+1:2n,:] = speye(n)

    return stlzState{n}(X,Z,R)
end

function copy!(A::stlzState,B::stlzState)
    copy!(A.X,B.X)
    copy!(A.Z,B.Z)
    copy!(A.R,B.R)

    return A
end

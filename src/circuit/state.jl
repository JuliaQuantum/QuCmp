# TODO: QuIDD

# NOTE
# N is the number of bits in a quantum array

abstract AbstractQuArray{N}

# TODO
# QuIDD encoding array
# type QuIDDArray{T,N}<:AbstractQuArray{N}
# end

type QuArray{T,N}<:AbstractQuArray{N}
    s::AbstractVector{T}
end

(+)(A::QuState,B::QuState) = A.s+B.s
(-)(A::Qustate,B::QuState) = A.s-B.s
(*)(A::QuState,B::QuState) = A.s*B.s
(/)(A::QuState,B::QuState) = A.s/B/s
(^)(A::QuState,b::Real) = A.s^b


# TODO
# show(io::IO,state::AbstractQuArray)
# show(io::IO,state::QuState)
# show(io::IO,state::QuIDDArray)

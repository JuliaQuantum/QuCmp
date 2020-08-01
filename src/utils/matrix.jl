#trotter expansion
function trotter(A::AbstractMatrix,B::AbstractMatrix,P::Int64)
    return (expm(full(A/(2*P)))*expm(full(B/P))*expm(full(A/(2*P))))^P
end

function (⊗)(A::AbstractMatrix,B::AbstractMatrix)
    @assert size(A)[1]==size(A)[2]
    @assert size(B)[1]==size(B)[2]

    return kron(A,B)
end

function (⊕)(A::AbstractMatrix,B::AbstractMatrix)
    return full(blkdiag(sparse(A),sparse(B)))
end

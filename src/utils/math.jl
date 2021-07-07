include("matrix.jl")

function normalize!(vec::AbstractVector)
    return vec[:]=vec/norm(vec)
end

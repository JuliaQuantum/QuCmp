# Base Hamiltonian
function bHamilton(bitnum::Int)
    H = sparse(0.5*(I-σ₁))
    Iden = spdiagm([1,1])
    for i=2:bitnum
        H = H⊗Iden
    end

    for i=2:bitnum
        H_BC = Iden
        for j=2:bitnum
            if i==j
                H_BC = H_BC⊗sparse(0.5*(I-σ₁))
            else
                H_BC = H_BC⊗Iden
            end
        end
        H+=H_BC
    end
    return H
end

# problem Hamiltonian
function pHamilton{M,N}(ins::Instance{M,N},n::Integer)
    sum = spzeros(2^n,2^n);
    for clause in ins.c
        sum += spdiagm(Int[clause(i) for i=0:2^n-1])
    end
    return sum
end

export bHamilton,pHamilton

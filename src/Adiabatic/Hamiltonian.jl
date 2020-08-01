# Base Hamiltonian
function bHamilton(bitnum::Int)
    diagv = Array(Complex128,2^bitnum);
    index = 1;
    for i=0:bitnum
        for j = 1:binomial(bitnum,i)
            diagv[index] = i
            index+=1
        end
    end

    return spdiagm(diagv)
end

# problem Hamiltonian for SAT problem
function pHamilton{M,N}(ins::Instance{M,N},n::Integer)
    return spdiagm(Complex128[1-ins(Bits(i)) for i=0:2^n-1])
end

export bHamilton,pHamilton

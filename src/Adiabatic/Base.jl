type AdiaComputer <: QuComput
    ###########################################
    #  Eternal
    ###########################################
    HB::AbstractMatrix      # Base Hamiltonian
    HP::AbstractMatrix      # Problem Hamiltonian
    maxtime::Real           # max evolution time
    n::Int64           # number of bits
    dt::Real                # time step

    ###########################################
    # variable for current state
    ###########################################
    location::Real          # time location
    state::AbstractVector
    eigens::AbstractVecOrMat

    ###########################################
    # measure
    ###########################################

    prob::Real

    ###########################################
    # other
    ###########################################

    nev::Int

    # n is the number of bits
    # maxtime is the max evolution time
    function AdiaComputer{M,N}(ins::Instance{M,N},n::Int,maxtime::Real;dt=1e-2,nev=6)
        HB = bHamilton(n)
        HP = pHamilton(ins,n)
        # set time location to be the beginning
        location = 0
        # prepare the initial state
        state = convert(Array{Complex,1},[1/sqrt(2^n) for i=1:2^n])

        # initialize states
        eigens = eigs(HB,nev=nev,which=:SM)[1].'

        # adjust nev if the number of bits is smaller than 3
        if n<3
            nev = 2^n
            warn("adjusting nev to $(nev)\n")
        end

        # probility
        prob = norm([x==findmin(diag(HP))[2]?1:0 for x=1:2^n])^2

        new(HB,HP,maxtime,n,dt,location,state,eigens,prob,nev)
    end
end

function Hamiltonian(Hs::AdiaComputer)
    return (1-Hs.location)*Hs.HB+Hs.location*Hs.HP
end

export AdiaComputer

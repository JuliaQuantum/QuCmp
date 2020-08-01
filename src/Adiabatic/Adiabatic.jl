################################################################################
#
# This file simulates Adiabatic Quantum Computing
#
################################################################################

export AQC

include("Hamiltonian.jl")
include("AQCShrodingerEq.jl")

typealias AbstractQuVecOrMat Union{QuBase.AbstractQuVector,QuBase.AbstractQuMatrix}

type AQC{N,H<:QuBase.AbstractQuMatrix}<:AbstractQC{N}
    eq::AQCShrodingerEq
    state::AbstractQuVecOrMat
    tlist
    method

    function AQC(HP::H,method,dt,maxtime)
        eq = AQCShrodingerEq(HP,maxtime)
        tlist = 0.:dt:maxtime
        state = QuArray(convert(Array{Complex128,1},[1/sqrt(2^N) for i=1:2^N]),ComputBasis(N))
        new(eq,state,tlist,method)
    end
end

AQC{H<:QuBase.AbstractQuMatrix}(HP::H,n::Int;method = QuODE45(),dt = 1e-2, maxtime = 1.0) = AQC{n,H}(HP,method,dt,maxtime)


function Base.start(aqc::AQC)
    init_state = aqc.state
    t_state = start(aqc.tlist)
    t,t_state = next(aqc.tlist,t_state)
    return QuPropagatorState(init_state,t,t_state)
end

function Base.next(aqc::AQC, qustate::QuPropagatorState)
    current_qustate = qustate.state
    current_t = qustate.t
    t,t_state = next(aqc.tlist, qustate.t_state)
    next_qustate = aqc.state = propagate(aqc.method, aqc.eq, t, current_t, current_qustate)
    return (t, next_qustate), QuPropagatorState(next_qustate, t, t_state)
end

Base.done(aqc::AQC, qustate::QuPropagatorState) = done(aqc.tlist, qustate.t_state)

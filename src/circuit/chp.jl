# These functions are based on C functions in the chp.c program by Scott Aaronson
# These are pure Julia implementations, and do not link to the chp.c library
# chp.c is Copyright (c), Scott Aaronson, and is not allowed for commercial use



###########################
# Stablizer Circuit
# Circuits with only Hadamard, C-NOT, R (Phase)
# followed by only one bits measurement
###########################


export stlzCircuit,HadamardUnit,CNOTUnit,PhaseUnit

type stlzCircuit{N} <: QuCircuit{N}
    gates::Array{GateUnit,1}
end

stlzCircuit(num::Integer,gates::Array{GateUnit,1}) = stlzCircuit{num}(gates)
stlzCircuit(num::Integer) = stlzCircuit{num}(Array(GateUnit,0))

type HadamardUnit<:AbstractGateUnit{1}
    pos::Int
end

function process!{N}(unit::HadamardUnit,input::stlzState{N})
  a = unit.pos
  # swap x_{ia} with z_{ia}
  vec_temp = Array(Int,Int(2*N))
  vec_temp[:] = input.X[:,a]
  input.X[:,a] = input.Z[:,a]
  input.Z[:,a] = vec_temp[:]

  for i = 1:2N
      input.R[i] $= input.X[i,a]&input.Z[i,a]
  end

  return input
end

type CNOTUnit<:AbstractGateUnit{1}
    pos::Int
    ctrl::Int
end

function process!{N}(unit::CNOTUnit,input::stlzState{N})
    a = unit.pos
    b = unit.ctrl

    r = input.R
    x = input.X
    z = input.Z

    for i=1:2N
        r[i] $= x[i,a] & z[i,b] & (x[i,b]$z[i,a]$1)
        x[i,b] $= x[i,a]
        z[i,a] $= z[i,b]
    end
    return input
end

type PhaseUnit<:AbstractGateUnit{1}
    pos::Int
end

function process!{N}(unit::PhaseUnit,input::stlzState{N})
    a = unit.pos
    for i=1:2N
        input.R[i] $= input.X[i,a] & input.Z[i,a]
        input.Z[i,a] $= input.X[i,a]
    end
    return input
end

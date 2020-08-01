using QuCmp
using Base.Test

h = HadamardUnit(1)

input = stlzState(2)

process!(h,input)


@test input.X == [0 0;0 1;1 0;0 0]|>BitMatrix|>sparse
@test input.Z == [1 0;0 0;0 0;0 1]|>BitMatrix|>sparse
@test input.R == [0,0,0,0]|>BitVector|>sparse

cnot = CNOTUnit(1,2)

process!(cnot,input)

@test input.X == [0 0;0 1;1 1;0 0]|>BitMatrix|>sparse
@test input.Z == [1 0;0 0;0 0;1 1]|>BitMatrix|>sparse
@test input.R == [0,0,0,0]|>BitVector|>sparse

phase = PhaseUnit(2)
process!(phase,input)

@test input.X == [0 0;0 1;1 1;0 0]|>BitMatrix|>sparse
@test input.Z == [1 0;0 1;0 1;1 1]|>BitMatrix|>sparse
@test input.R == [0,0,0,0]|>BitVector|>sparse

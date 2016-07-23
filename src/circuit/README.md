# Matrix Operators


# Functional Operators

should be constructed by a function with single input as type `QuState`

# process

This part makes use of Julia's multiple dispatch. If you have a new type of gate unit. You will need to overload the process function if there are special optimized algorithms for these type of gates. eg.

for stablizer circuits, `HadamardUnit`,`PhaseUnit`,`CNOTUnit` are implemented in this package. All of them is implemented with a single process function.

```julia
function process{N}(unit::CtrlGateUnit{N},input::AbstractSparseArray)
function process(unit::HadamardUnit,input::AbstractSparseArray)
# ...
```

# QuIDD

QuIDD methods needs to be done to store the state efficiently.


# Roadmap


- [x] Basic structure of types in quantum circuit and adiabatic model
  - [x] C-NOT
  - [x] Hadamard
  - [x] Pauli-X, Pauli-Y, Pauli-Z
  - [x] TimeOp
  - [x] object: `Circuit`

- Quantum circuits and adiabatic computation
  - [ ] `addgate!`, `removegate!`
  - [ ] pHamiltonian

- Visualization
  - [ ] `plot` (circuit)

- Error correction
  - [ ] CSS code

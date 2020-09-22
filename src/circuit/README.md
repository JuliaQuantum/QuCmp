# Operators

## Matrix Operators


## Functional Operators

should be constructed by a function with single input as type `QuState`

# Gate

## Gate

As interface or wrapper to normally used gates.

## Gate Unit

gate unit is a basic data type for storing gates, the difference between `AbstractGateUnit` and `Gate` is that `Gate` is only a wrapper for quantum operators in quantum information processing. But `AbstractGateUnit` and its subtypes provide a way to store the position and way of processing for a certain gate.

# Circuits

`QuCircuit{N}` is the super-type for all circuit objects, where `N` is the number of qubits involved in this circuit.

## `Circuit{N}`

`Circuit{N}` is the default circuit type. The processing simulation of this circuit type will not be optimized to specific algorithm, which is not recommended if you need high performance.

## `stlzCircuit{N}` (**TODO**)

`stlzCircuit{N}` is for stabilizer circuits, a kind of circuit with only Hadamard, C-NOT, Phase gates, and followed by one bit measurement only. The current plan for this part is the rework of [CHP.c](http://www.scottaaronson.com/chp/) by Aanronson.

# process

This part makes use of Julia's multiple dispatch. If you have a new type of gate unit. You will need to overload the process function if there are special optimized algorithms for these type of gates. eg.

for stablizer circuits, `HadamardUnit`,`PhaseUnit`,`CNOTUnit` are implemented in this package. All of them is implemented with a single process function.

```julia
function process{N}(unit::CtrlGateUnit{N},input::AbstractSparseArray)
function process(unit::HadamardUnit,input::AbstractSparseArray)
# ...
```

# How to customize your own gate?

If you want to create your own gate and its related simulation algorithm, the following funcitons should be overloaded:

- **define your own gate unit type** :: define your own gate unit type and it should be a subtype of `AbstractGateUnit{N}`
    - the gate unit should at least contain one element named `pos` for storing the gate's position in a circuit
- `addgate!`:: provide a method to add gates to subtypes of `QuCircuit{N}`, where `N` is the number of qubits.
- `process` :: provide a method to process this gate by customized simulation algorithm.

# Roadmap


- [x] Basic structure of types in quantum circuit and adiabatic model
  - [x] C-NOT
  - [x] Hadamard
  - [x] Pauli-X, Pauli-Y, Pauli-Z
  - [x] TimeOp
  - [x] object: `Circuit`

- Quantum circuits and adiabatic computation
  - [ ] `addgate!`, `removegate!` -> working on
  - [x] pHamiltonian
  - [ ] merge GPU acceleration from AdiaComput.jl

- Visualization
  - [ ] `plot` (circuit) -> next

- Error correction
  - [ ] CSS code

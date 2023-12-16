# Embedded Systems Architecture
---

### Project 1: Neural Network Accelerator

#### Overview

This project focuses on the development of a simple accelerator for a convolutional neural network (CNN) based on a specific architecture. The CNN takes four integer inputs, X1, X2, X3, and X4, and produces a single integer output, Y. The accelerator comprises an arithmetic datapath and a finite state machine (FSM).

---

### Neuron Architecture

#### Neuron Operation

The neuron performs arithmetic operations based on weighted sums and activation functions. The Verilog description includes a multi-operand add operation followed by an activation function. Inputs, weights, and biases are 8-bit 2's complement values, and results are 16-bit fractional values. The activation function saturates the output within specified limits.

#### Neuron Verilog Description

The Verilog description of the neuron, encapsulated within the "neuron.v" module, is complete and functional. The activation function, a separate module instantiated within the neuron, aligns with the expected design.

![Neuron Schematic (VIVADO)](https://github.com/Leonard2310/Verilog_Projects/assets/71086591/97e46696-eeac-4a33-a210-216017e7cfd0)

---

### Neural Network Architecture

The neural network's implementation involves three interconnected neurons, with two distinct datapath architectures: a pipelined version and a scalable architecture.

#### Pipelined Architecture

The pipelined architecture features three neurons operating in stages, with registers updated at each clock cycle. The FSM controls data flow and communication using signals such as ready, valid, ready_out, and valid_out.

![Accellerator Pipelined Schematic (VIVADO)](https://github.com/Leonard2310/Verilog_Projects/assets/71086591/03c2de12-dbf8-4025-bd91-433410c24808)

#### Scalable Architecture

The scalable architecture utilizes two neurons, accommodating various configurations within the neural network. The FSM's scheduling ensures efficient computations, adapting to different neuron configurations.

---

### Implementation and Testing

The neural network accelerator's implementation uses Verilog files "acc_pipe.v" and "tb_accelerator.sv." The testbench, equipped with precomputed inputs and outputs in "accel_in.dat" and "accel_out.dat," verifies the correct functionality of the accelerator module.

---

### Project 2: Design of an Arithmetic Datapath

#### Overview

The second project focuses on designing a straightforward arithmetic datapath capable of performing various operations based on a 3-bit operation code (opcode). This datapath processes two signed 16-bit inputs (A, B) and generates a 16-bit output (Y) along with a single-bit carry-out signal (co).

#### Operations and OpCodes

The table below summarizes the possible operations, their corresponding opcodes, and the computed values:

| Operation          | Short Name | Opcode | Computed Y       | Computed co     |
|--------------------|------------|--------|-------------------|-----------------|
| Sum                | Sum        | 3'b000 | A + B             | Carry out       |
| Sum and Increment  | Sumi       | 3'b001 | A + B + 1         | Carry out       |
| Subtract and Decrement | Subd    | 3'b010 | A - B - 1         | Carry out       |
| Subtract           | Sub        | 3'b011 | A - B             | Carry out       |
| Passthrough Pt1    | Pt1        | 3'b100 | A                 | Zero            |
| Increment          | Inc        | 3'b101 | A + 1             | Carry out       |
| Decrement          | Dec        | 3'b110 | A - 1             | Carry out       |
| Passthrough Pt2    | Pt2        | 3'b111 | A                 | Zero            |

#### Datapath Architecture

The basic datapath uses an adder, two multiplexers and 16 not gates to implement all the 8 operations. The least significant bit of the opcode feeds the carry-in of the adder. The other two bits change the second input of the adder by either inverting or zero-ing its bits.
![Base Architecture Schematic (VIVADO)](https://github.com/Leonard2310/Verilog_Projects/assets/71086591/37958ef8-5e12-43af-8f0f-73fc3f22d125)

The datapath is implemented also with some variants:

1. Base + N + File Input:
  - A parameter is used to define the number of bits for the inputs and outputs of the datapath.
  - In the testbench, a function is implemented for reading inputs from a file containing circuit inputs.


2. Base + N + File Input + Pipeline Registers:
  - A parameter is used to define the number of bits for the inputs and outputs of the datapath.
  - In the testbench, a function is implemented for reading inputs from a file containing circuit inputs.
  - A parameter named 'pipe' is added to the design.
    - If 'pipe' is 0, the design has no pipeline registers.
    - If 'pipe' is 1, registers are added to the inputs and outputs; it requires an additional clock signal input.


3. Base + N + Random Input:
  - A parameter is used to define the number of bits for the inputs and outputs of the datapath.
  - In the testbench, a function is implemented for the random generation of circuit inputs.


4. Base + N + Random Input + Modified Pipeline Registers:
  - A parameter is used to define the number of bits for the inputs and outputs of the datapath.
  - In the testbench, a function is implemented for the random generation of circuit inputs.
  - A parameter named 'pipe' is added to the design.
    - If 'pipe' is 0, the design has no pipeline registers.
    - If 'pipe' is 1, registers are added to the inputs and outputs; it requires an additional clock signal input.
    - If 'pipe' is 2, pipeline registers should be added to inputs, outputs, and in the middle of the adder.


#### Testbench and Verification

Comprehensive Testbenches are provided to facilitate the simulation of the circuit's correct operation. The module declaration of the datapath, along with the inputs and outputs, is available. 

---

### Conclusion

The completion of both projects demonstrates a solid understanding of embedded systems architecture, encompassing the design and implementation of a neural network accelerator and an arithmetic datapath. These projects provide valuable hands-on experience in Verilog programming, finite state machine design and datapath architecture.

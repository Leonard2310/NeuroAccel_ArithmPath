# Integrated Systems Architecture
---

### Project 1: Neural Network Accelerator Implementation
---

### Project Overview

This project has successfully implemented a simple accelerator for a convolutional neural network, emphasizing the integration of an architecture featuring an arithmetic datapath and a finite state machine (FSM). The accelerator efficiently processes inputs X1, X2, X3, and X4, producing the desired output value Y. The comprehensive design covers neurons, FSM operations, and communication protocols within the accelerator.

---

### Neuron Architecture

#### Neuron Operation

The implemented neuron effectively performs arithmetic operations based on weighted sums and activation functions. The Verilog description involves a multi-operand add operation followed by the activation function. Inputs, weights, and biases are meticulously defined as 8-bit 2's complement values, while the results are accurately expressed as fractional 16-bit values. The activation function adeptly saturates the output within specified limits.

#### Neuron Verilog Description

The Verilog description of the neuron, encapsulated within the "neuron.v" module, is complete and functional. The activation function, as a separate module instantiated within the neuron, also aligns with the expected design. The provided Verilog files, "neuron.v" and "tb_neuron.v," have been successfully utilized for testing, employing precomputed inputs and outputs.

---

### Neural Network Architecture

The neural network's implementation is well-rounded, utilizing three interconnected neurons. Two distinct datapath architectures, including a pipelined version and a scalable architecture, have been successfully realized.

#### Pipelined Architecture

The pipelined architecture features three neurons operating in stages, with registers consistently updated at each clock cycle. The FSM aptly controls the data flow and communication between feeder and consumer circuits, effectively utilizing ready, valid, ready_out, and valid_out signals.

#### Scalable Architecture

The scalable architecture introduces flexibility by utilizing two neurons, accommodating various configurations within the neural network. The FSM's adept scheduling ensures efficient computations, and the design easily adapts to different neuron configurations.

---

### Implementation and Testing

The implementation of the neural network accelerator has been successfully carried out using Verilog files "acc_pipe.v" and "tb_accelerator.sv." The testbench, equipped with precomputed inputs and outputs in "accel_in.dat" and "accel_out.dat," has effectively verified the correct functionality of the accelerator module.

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

The completion of both projects demonstrates a solid understanding of integrated systems architecture, encompassing the design and implementation of a neural network accelerator and a simple arithmetic datapath. These projects provide valuable hands-on experience in Verilog programming, finite state machine design, and datapath architecture.

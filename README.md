# RISC-V Processor Simulation and Implementation

## Overview

This project focuses on the design and simulation of a RISC-V processor. The primary goal is to implement the datapath and control logic of a RISC-V processor, supporting a variety of instructions, such as Register-Register, ALU Immediate, Memory, and Branch instructions. The design is implemented in Verilog and tested using a testbench to verify the correctness of the processor's functionality.

## Features

- **Register-Register Operations:**
  - ADD, SUB, AND, OR, XOR, SLT, SLL, SRL, SRA
- **ALU Immediate Operations:**
  - ADDI, ANDI, ORI, XORI, SLTI, SLLI, SRLI, SRAI
- **Memory Operations:**
  - LW (Load Word), SW (Store Word)
- **Branch Operations:**
  - BEQ (Branch if Equal)
 
    
## How It Works

The processor operates in a five-stage pipeline, typical of most RISC processors:

1. **Fetch (IF)**: The instruction is fetched from instruction memory based on the Program Counter (PC).
2. **Decode (ID)**: The instruction is decoded, and operands are read from the register file.
3. **Execute (EX)**: The ALU performs the necessary operation (e.g., ADD, SUB) based on the decoded instruction.
4. **Memory (MEM)**: Memory operations such as loading and storing data are performed in this stage.
5. **Write Back (WB)**: The result of the ALU or memory read is written back to the register file.

### ALU Operations
The ALU performs various arithmetic and logical operations, such as:
- Addition/Subtraction
- Logical AND/OR/XOR
- Set Less Than (SLT)
- Shift operations (SLL, SRL, SRA)

### Memory Operations
- **LW** (Load Word): Loads data from memory to a register.
- **SW** (Store Word): Stores data from a register to memory.

### Branching
- **BEQ** (Branch if Equal): If two registers are equal, the program counter is updated to the branch target address.

## How to Simulate

1. **Testbench Setup**: The processor is tested through a dedicated testbench file `testbench.v`, which runs through various instructions and checks the outputs.

2. **Run Simulation**: You can run the simulation using the Verilog simulator Icarus-Verilog and check the waveforms with GTKWave.

    ```bash
    iverilog top_proc_tb.v
    ./a.out
    gtkwave dump.vcd
    ```

3. **Expected Output**: The simulation output will show the program counter updates, memory accesses, and register writes as the instructions are executed.

## Known Issues

- The design assumes a 32-bit architecture with 32 registers.
- The current implementation of the ALU doesn't handle all corner cases or optimizations.

## Future Enhancements

- Support for more RISC-V instructions.
- Optimized control signals and handling of complex instruction types.
- Improved test coverage for edge cases.

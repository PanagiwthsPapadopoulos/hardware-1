# ⚙️ RISC-V Processor Simulation and Implementation  

## 📌 Overview  

This project focuses on the **design and simulation of a RISC-V processor**. The primary goal is to implement the **datapath and control logic** of a RISC-V processor, supporting a variety of instructions, such as **Register-Register, ALU Immediate, Memory, and Branch instructions**. The design is implemented in **Verilog** and tested using a **testbench** to verify the correctness of the processor's functionality.  

## ✨ Features  

### 🏗️ **Register-Register Operations**  
- ➕ **ADD**, ➖ **SUB**, 🔗 **AND**, 🔘 **OR**, ❌ **XOR**, 🔼 **SLT**, 🔄 **SLL**, 🔀 **SRL**, 🔁 **SRA**  

### 🔢 **ALU Immediate Operations**  
- ➕ **ADDI**, 🔗 **ANDI**, 🔘 **ORI**, ❌ **XORI**, 🔼 **SLTI**, 🔄 **SLLI**, 🔀 **SRLI**, 🔁 **SRAI**  

### 💾 **Memory Operations**  
- 📥 **LW** (Load Word) – Loads data from memory to a register.  
- 📤 **SW** (Store Word) – Stores data from a register to memory.  

### 🔄 **Branch Operations**  
- 🎯 **BEQ** (Branch if Equal) – If two registers are equal, the **Program Counter (PC)** updates to the branch target address.  

---

## 🔍 How It Works  

The processor operates in a **five-stage pipeline**, similar to most **RISC** processors:  

1️⃣ **Fetch (IF)** – The instruction is fetched from memory based on the **Program Counter (PC)**.  
2️⃣ **Decode (ID)** – The instruction is decoded, and operands are read from the **register file**.  
3️⃣ **Execute (EX)** – The **ALU** performs operations like **ADD, SUB, AND, OR, XOR, etc.**  
4️⃣ **Memory (MEM)** – Memory operations like **Load (LW)** and **Store (SW)** are handled.  
5️⃣ **Write Back (WB)** – The result of **ALU/memory operations** is written back to the **register file**.  

### 🔢 ALU Operations  
- ➕ **Addition/Subtraction**  
- 🔗 **Logical AND/OR/XOR**  
- 🔼 **Set Less Than (SLT)**  
- 🔄 **Shift operations (SLL, SRL, SRA)**  

### 💾 Memory Operations  
- 📥 **LW (Load Word)** – Loads data from memory to a register.  
- 📤 **SW (Store Word)** – Stores data from a register to memory.  

### 🔀 Branching  
- 🎯 **BEQ (Branch if Equal)** – If two registers are equal, the **PC** is updated to the **branch target address**.  

---

## 🛠️ How to Simulate  

1. **Testbench Setup**: The processor is tested through a dedicated testbench file `testbench.v`, which runs through various instructions and checks the outputs.

2. **Run Simulation**: You can run the simulation using the Verilog simulator Icarus-Verilog and check the waveforms with GTKWave.

    ```bash
    iverilog top_proc_tb.v
    ./a.out
    gtkwave dump.vcd
    ```

3. **Expected Output**: The simulation output will show the program counter updates, memory accesses, and register writes as the instructions are executed.

## ⚠️ Known Issues  

- 🏗️ The design assumes a **32-bit architecture** with **32 registers**.  
- 🔄 The ALU **does not handle all corner cases or optimizations** yet.  

---

## 🔮 Future Enhancements  

- 🔧 **Support for more RISC-V instructions.**  
- ⚡ **Optimized control signals and handling of complex instruction types.**  
- 🧪 **Improved test coverage for edge cases.**

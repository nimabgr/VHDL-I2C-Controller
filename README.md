# VHDL Implementation of an I2C Master Controller

![VHDL](https://img.shields.io/badge/VHDL-IEEE%201076-blue)
![FPGA](https://img.shields.io/badge/FPGA-Ready-green)
![I2C](https://img.shields.io/badge/Protocol-I2C-purple)

## Overview

This repository contains the VHDL source code for an **I2C (Inter-Integrated Circuit) Master Controller**. This project was developed as a final assignment for the **"Programmable Digital Systems Design"** course at [University of Tabriz].

The primary goal of this project is to implement the I2C communication protocol in VHDL, creating a synthesizable module capable of acting as a master on an I2C bus. The implementation is designed to handle start/stop conditions, send slave addresses, send register addresses, and manage both write and read data transactions.

## Features

* **I2C Master Mode:** Fully implements the master logic for initiating and controlling the bus.
* **State Machine Based:** Uses a finite state machine (FSM) to manage the protocol's timing and logic flow.
* **Configurable Transactions:**
    * **Write Operations:** Sends 8-bit data to a specified 8-bit register address in an 8-bit slaved device.
    * **Read Operations:** (As described in the code) Reads 8-bit data from a specified slave.
    * **Multi-Byte Write:** Supports sequential write operations for up to 3 data bytes, controlled by the `I_Data_1` to `I_Data_3` inputs.
* **Standard I2C Protocol:** Implements key protocol steps including:
    * Start Condition
    * Slave Address + R/W bit transmission
    * Register Address transmission
    * Data Byte transmission
    * Acknowledge (ACK) generation and checking
    * Stop Condition

## Project Structure

This repository includes two essential VHDL files:

1.  **`I2C.vhd`**: The main design file containing the `I2C` entity and its `Behavioral` architecture. This file implements the core logic of the I2C master controller FSM.
2.  **`I2C_TB.vhd`**: The testbench file used to simulate and verify the functionality of the `I2C.vhd` module. It provides clock generation and stimulus signals (like slave address, register address, and data) to test the write and read cycles.

## Implementation Details

The controller is implemented as a single-process, synchronous state machine driven by a system clock (`clk`). The `State` signal (ranging from 0 to 500) meticulously steps through every required signal change on the `O_SCL` (clock) and `IO_SDA` (data) lines to conform to the I2C timing specifications.

The `Master_EN` signal acts as a global enable to initiate a transaction. The inputs `I_Slave_Add`, `I_Reg_Add`, and `I_Data_1`...`I_Data_3` are latched at the beginning of the transaction.

## Academic Context

This project serves as a practical application of digital design principles for a university-level course. It demonstrates:
* Proficiency in the VHDL hardware description language.
* The design and implementation of complex finite state machines.
* Understanding of synchronous design practices.
* Knowledge of standard communication protocols (I2C).

## How to Use

1.  **Simulation:**
    * Create a new project in a VHDL simulator (like **ModelSim**, **Vivado Simulator**, **GHDL**, or **QuestaSim**).
    * Add both `I2C.vhd` and `I2C_TB.vhd` to the project.
    * Compile the files (ensure `I2C.vhd` is compiled first or as a dependency).
    * Run the simulation on the `I2C_TB` testbench entity.
    * Observe the `O_SCL`, `IO_SDA`, `O_Data`, and `State` signals in the wave viewer to verify the protocol's correctness.

2.  **Synthesis:**
    * The `I2C.vhd` file is synthesizable.
    * It can be imported into an FPGA design tool (like **Vivado** for Xilinx or **Quartus** for Intel) as a component.
    * The ports can then be connected to top-level signals, with `IO_SDA` connected to a high-impedance (tri-state) buffer or an open-drain top-level pin.
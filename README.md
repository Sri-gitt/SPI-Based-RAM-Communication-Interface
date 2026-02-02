# SPI-Based-RAM-Communication-Interface in Verilog
## Overview
This project implements the **SPI (Serial Peripheral Interface) protocol** using Verilog HDL. The design models a **full-duplex master–slave communication system**, supporting serial data transfer between digital modules using standard SPI signals.

The system demonstrates how serial data is transmitted over SPI, parallelized and stored in memory, or read from memory, and re serialzed making it suitable for understanding real-world SPI communication used in microcontrollers and peripheral devices.
## Features
- Full-duplex serial communication
- Master–slave architecture
- Parallel-to-Serial conversion
- Serial-to-Parallel conversion
- RAM-based data storage
- Modular and synthesizable RTL design
- Structured testbench for verification
## SPI Signals
| Signal | Description |
|--------|------------|
| MOSI   | Master Out Slave In |
| MISO   | Master In Slave Out |
| SCLK   | Serial Clock |
| CS     | Chip Select (Slave Select) |
## Project Hierarchy

```text
spi_top.v
│
├── serial_to_parallel_converter.v
|
├── unpack_data.v
|
├── memory.v
│   └── ram.v
├── parallel_to_serial_converter.v
└── spi_top_tb.v

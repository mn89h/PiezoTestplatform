# PIEZO_TESTPLATFORM

This folder contains the Vivado files for generating the FPGA bitstream and some tools for reading out transferred data. The used hardware platform is the Digilent CMOD S7 featuring a Xilinx XC7S25-1 FPGA with a 12 MHz system clock.

## Generating the bitstream

Using Vivado 2022.2 open the project and
1. Run Synthesis
2. Run Implementation
3. Generate Bitstream
4. Program the device

## Usage

The Piezo_TestPlatform project provides a base for instructing and receiving data transmissions. The communication with the Piezo_DevBoard is executed by the CMOD S7 FPGA controlled over the UART interface. The tool HTerm is recommended as software for the serial communication. 

To see all available commands and their usage, please refer to the serial_defines.hv in Piezo_TestPlatform.srcs/sources_1

## Bugs

Comparator driver seems to use a fixed frequency (12 MHz?) independent of the frequency set by command and supposedly applied by the reconfigurable MMCM.
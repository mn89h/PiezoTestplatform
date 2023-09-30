# Custom ASIC Test PCB for Ultrasonic Communication

This project involves the design and development of a custom printed circuit board (PCB) for testing an Application-Specific Integrated Circuit (ASIC) used in ultrasonic communication. The goal is to enable two-way ultrasonic communication with energy harvesting capabilities. This was developed as part of a project seminar in the Integrated Electronic Systems (IES) lab at the Technical University of Darmstadt.

Features:

    Ultrasonic Transmission and Reception: Supports two-way communication using piezoelectric transducers for transmitting and receiving ultrasonic waves.
    Custom PCB Design: Designed a custom PCB including components like a piezo driver, analog-to-digital converter (ADC), comparator, and FPGA for signal processing.
    Energy Harvesting: Capable of using wireless power harvesting techniques for communication where battery power is not feasible.
    FPGA Control: The system is controlled by a Xilinx Spartan-7 FPGA, with signal processing logic implemented in Verilog.

## System Overview

The system consists of both hardware and software platforms:

    Hardware: Includes a piezo driver stage, input amplifier, ADC, comparator, and FPGA. The PCB was designed using KiCAD 6.0.
    Software: Implemented in Verilog for the Xilinx Spartan-7 FPGA, handling communication, data transfer, and signal processing.

## Project Structure

    Piezo_DevBoard: A two-layer PCB designed for high-frequency ultrasonic communication with minimal noise and optimal power management.
    Piezo_TestPlatform: The FPGA core handles the communication between the FPGA and external systems through serial interfaces and processes data from the piezo transducers. Python code for interpreting incoming data is provided in the misc folder.

## Detailed Overview

Please refer to the [report](Report/main.pdf) and [presentation](Presentation/Präsentation.pdf) for a more in-depth look.
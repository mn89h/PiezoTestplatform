//-------------------------------------------------------------------------------------------
//   ____  ____
//  /   /\/   /
// /___/  \  /
// \   \   \/    � Copyright 2019 Xilinx, Inc. All rights reserved.
//  \   \        This file contains confidential and proprietary information of Xilinx, Inc.
//  /   /        and is protected under U.S. and international copyright and other
// /___/   /\    intellectual property laws.
// \   \  /  \
//  \___\/\___\
//
//-------------------------------------------------------------------------------------------
// Device:              7_Series
// Author:              Tatsukawa, Kruger, Ribbing, Defossez
// Entity Name:         mmcme2_drp
// Purpose:             This calls the DRP register calculation functions and
//                      provides a state machine to perform MMCM reconfiguration
//                      based on the calculated values stored in a initialized
//                      ROM.
//                      7-Series MMCM is called:            MMCME2
//                          Ultrascale MMCM is called:      MMCME3
//                          UltrascalePlus MMCM is called:  MMCME4
//                      MMCME3 attributes
//                          CLKINx_PERIOD:      0.968 to 100.000 (x = 1 or 2)
//                          REF_JITTERx:        0.001 to 0.999 (x = 1 or 2)
//                          BANDWIDTH:          LOW, HIGH, OPTIMIZED and POSTCRC
//                          COMPENSATION:       AUTO, ZHOLD, EXTERNAL, INTERNAL and BUF_IN
//                          DIVCLK_DIVIDE:      1 to 106
//                          CLKFBOUT_MULT_F:    2 to 64
//                          CLKFBOUT_PHASE:     -360 to 360
//                          CLKOUTn_DIVIDE:     1 to 128 (n = 0 to 6)
//                          CLKOUTn_PHASE:      -360 to 360 (n = 0 to 6)
//                          CLKOUTn_DUTY_CYCLE: 0.01 to 0.99 (n = 0 to 6)
//
// Tools:               Vivado_2019.1 or newer
// Limitations:         None
//
// Vendor:              Xilinx Inc.
// Version:             1.40
// Filename:            mmcme3_drp.v
// Date Created:        22-Oct-2014
// Date Last Modified:  25-Jun-2019
//-------------------------------------------------------------------------------------------
// Disclaimer:
//        This disclaimer is not a license and does not grant any rights to the materials
//        distributed herewith. Except as otherwise provided in a valid license issued to you
//        by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE MATERIALS
//        ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
//        WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED
//        TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR
//        PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort, including
//        negligence, or under any other theory of liability) for any loss or damage of any
//        kind or nature related to, arising under or in connection with these materials,
//        including for any direct, or any indirect, special, incidental, or consequential
//        loss or damage (including loss of data, profits, goodwill, or any type of loss or
//        damage suffered as a result of any action brought by a third party) even if such
//        damage or loss was reasonably foreseeable or Xilinx had been advised of the
//        possibility of the same.
//
// CRITICAL APPLICATIONS
//        Xilinx products are not designed or intended to be fail-safe, or for use in any
//        application requiring fail-safe performance, such as life-support or safety devices
//        or systems, Class III medical devices, nuclear facilities, applications related to
//        the deployment of airbags, or any other applications that could lead to death,
//        personal injury, or severe property or environmental damage (individually and
//        collectively, "Critical Applications"). Customer assumes the sole risk and
//        liability of any use of Xilinx products in Critical Applications, subject only to
//        applicable laws and regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
//
// Contact:    e-mail  hotline@xilinx.com        phone   + 1 800 255 7778
//-------------------------------------------------------------------------------------------
// Revision History:
//  Rev: 13-Jan-2011 - Tatsukawa
//      Updated ROM[18,41] LOCKED bitmask to 16'HFC00
//  Rev: 30-May-2013 - Tatsukawa
//      Adding Fractional support for CLKFBOUT_MULT_F, CLKOUT0_DIVIDE_F
//  Rev: 30-Apr-2014 - Tatsukawa
//      For fractional multiply changed order to enable fractional
//      before the multiply is applied to prevent false VCO DRCs
//      (e.g. DADDR 7'h15 must be set before updating 7'h14)
//  Rev: 24-Oct-2014 - Ribbing
//      Parameters have been added to clarify Reg1/Reg2/Shared registers
//  Rev: 08-Jun-2015 - Kruger
//      WAIT_LOCK update
//  Rev: 02-May-2016 - Kruger
//      Reordering FRAC_EN bits DADDR(7'h09, 7'h15)
//      Registers before frac settings (7'h08, 7'h14)
//  Rev: 19-Sep-2018 - Defossez
//      Updated comments of BANDWIDTH.
//      Corrected some typos.
//  Rev: 25-Jun-2019 - Defossez
//      Adding registering possibility for LOCKE signal.
//-------------------------------------------------------------------------------------------
//
`timescale 1ps/1ps
//
module adc_mmcme2_drp #(
		// Register the LOCKED signal with teh MMCME3_ADV input clock.
		// The LOCKED_IN (LOCKED from the MMCME3_ADV) is fed into a register and then
		// passed the LOCKED_OUT when REGISTER_LOCKED is set to "Reg" or when set to
		// "NoReg" LOCKED_IN is just passed on to LOCKED_OUT without being registered.
		parameter REGISTER_LOCKED     = "Reg",
		// Use the registered LOCKED signal from the MMCME3 also for the DRP state machine.
		parameter USE_REG_LOCKED      = "No"
		// Possible/allowed combinations of above two parameters:
		// | REGISTER_LOCKED | USE_REG_LOCKED |                                            |
		// |-----------------|----------------|--------------------------------------------|
		// |      "NoReg"    |     "No"       | LOCKED is just passed through mmcme3_drp   |
		// |                 |                | and is used as is with the state machine   |
		// |      "NoReg"    |     "Yes"      | NOT ALLOWED                                |
		// |       "Reg"     |     "No"       | LOCKED is registered but the unregistered  |
		// |                 |                | version is used for the state machine.     |
		// |       "Reg"     |     "Yes"      | LOCKED is registered and the registered    |
		// |                 |                | version is also used by the state machine. |
) (
		// These signals are controlled by user logic interface and are covered
		// in more detail within the XAPP.
		input      [ 5:0] SADDR,
		input             SEN,
		input             SCLK,
		input             RST,
		output reg        SRDY,
		//
		// These signals are to be connected to the MMCM_ADV by port name.
		// Their use matches the MMCM port description in the Device User Guide.
		input      [15:0] DO,
		input             DRDY,
		input             LOCK_REG_CLK_IN,
		input             LOCKED_IN,
		output reg        DWE,
		output reg        DEN,
		output reg [ 6:0] DADDR,
		output reg [15:0] DI,
		output            DCLK,
		output reg        RST_MMCM,
		output            LOCKED_OUT
);
	`include "adc_mmcme2_drp_config.vh"

	//----------------------------------------------------------------------------------------
	//
	wire IntLocked;
	wire IntRstMmcm;
	//
	// 100 ps delay for behavioral simulations
	localparam TCQ = 100;

	// Make sure the memory is implemented as distributed
	(* rom_style = "distributed" *)
	//
	// ROM of:  39 bit word 400 words deep
	reg [38:0] rom           [ROM_SZ-1:0];
	reg [ 8:0] rom_addr;
	reg [38:0] rom_do;
	reg        next_srdy;
	reg [ 8:0] next_rom_addr;
	reg [ 6:0] next_daddr;
	reg        next_dwe;
	reg        next_den;
	reg        next_rst_mmcm;
	reg [15:0] next_di;
	//
	// Insert a register in LOCKED or not depending on the value given to the parameters
	// REGISTER_LOCKED. When REGISTER_LOCKED is set to "Reg" insert a register, when set
	// to "NoReg" don't insert a register but just pass the LOCKED signal from input to
	// output.
	// Use or not, under USE_REG_LOCKED parameter control, the registered version of the
	// LOCKED signal for the DRP state machine.
	// Possible/allowed combinations of the two LOCKED related parameters:
	//
	// | REGISTER_LOCKED | USE_REG_LOCKED |                                            |
	// |-----------------|----------------|--------------------------------------------|
	// |      "NoReg"    |     "No"       | LOCKED is just passed through mmcme3_drp   |
	// |                 |                | and is used as is with the state machine   |
	// |      "NoReg"    |     "Yes"      | NOT ALLOWED                                |
	// |       "Reg"     |     "No"       | LOCKED is registered but the unregistered  |
	// |                 |                | version is used for the state machine.     |
	// |       "Reg"     |     "Yes"      | LOCKED is registered and the registered    |
	// |                 |                | version is also used by the state machine. |
	//
	generate
		if (REGISTER_LOCKED == "NoReg" && USE_REG_LOCKED == "No") begin
			assign LOCKED_OUT = LOCKED_IN;
			assign IntLocked  = LOCKED_IN;
		end else if (REGISTER_LOCKED == "Reg" && USE_REG_LOCKED == "No") begin
			FDRE #(
					.INIT         (0),
					.IS_C_INVERTED(0),
					.IS_D_INVERTED(0),
					.IS_R_INVERTED(0)
			) mmcme3_drp_I_Fdrp (
					.D (LOCKED_IN),
					.CE(1'b1),
					.R (IntRstMmcm),
					.C (LOCK_REG_CLK_IN),
					.Q (LOCKED_OUT)
			);
			//
			assign IntLocked = LOCKED_IN;
		end else if (REGISTER_LOCKED == "Reg" && USE_REG_LOCKED == "Yes") begin
			FDRE #(
					.INIT         (0),
					.IS_C_INVERTED(0),
					.IS_D_INVERTED(0),
					.IS_R_INVERTED(0)
			) mmcme3_drp_I_Fdrp (
					.D (LOCKED_IN),
					.CE(1'b1),
					.R (IntRstMmcm),
					.C (LOCK_REG_CLK_IN),
					.Q (LOCKED_OUT)
			);
			//
			assign IntLocked = LOCKED_OUT;
		end
	endgenerate

	// Pass SCLK to DCLK for the MMCM
	assign DCLK = SCLK;
	assign IntRstMmcm = RST_MMCM;

//    initial begin
//        rom = rom_init;
//    end
    integer i;
	initial begin
	    for (i = 0; i < ROM_SZ; i = i + 1) begin
	        rom[i] = rom_init(i);
	    end
	end

	// Output the initialized rom value based on rom_addr each clock cycle
	always @(posedge SCLK) begin
		rom_do <= #TCQ rom[rom_addr];
	end

	//**************************************************************************
	// Everything below is associated whith the state machine that is used to
	// Read/Modify/Write to the MMCM.
	//**************************************************************************

	// State Definitions
	localparam RESTART = 4'h1;
	localparam WAIT_LOCK = 4'h2;
	localparam WAIT_SEN = 4'h3;
	localparam ADDRESS = 4'h4;
	localparam WAIT_A_DRDY = 4'h5;
	localparam BITMASK = 4'h6;
	localparam BITSET = 4'h7;
	localparam WRITE = 4'h8;
	localparam WAIT_DRDY = 4'h9;

	// State sync
	reg [3:0] current_state = RESTART;
	reg [3:0] next_state = RESTART;

	// These variables are used to keep track of the number of iterations that
	//    each state takes to reconfigure.
	reg [4:0] state_count = STATE_COUNT_CONST;
	reg [4:0] next_state_count = STATE_COUNT_CONST;

	// This block assigns the next register value from the state machine below
	always @(posedge SCLK) begin
		DADDR       <= #TCQ next_daddr;
		DWE         <= #TCQ next_dwe;
		DEN         <= #TCQ next_den;
		RST_MMCM    <= #TCQ next_rst_mmcm;
		DI          <= #TCQ next_di;

		SRDY        <= #TCQ next_srdy;

		rom_addr    <= #TCQ next_rom_addr;
		state_count <= #TCQ next_state_count;
	end

	// This block assigns the next state, reset is syncronous.
	always @(posedge SCLK) begin
		if (RST) begin
			current_state <= #TCQ RESTART;
		end else begin
			current_state <= #TCQ next_state;
		end
	end

	function [8:0] rom_addr_from_state;
		input [5:0] state;
		begin
			case (state)
				6'd0	: rom_addr_from_state =   0;
				6'd1	: rom_addr_from_state =  12;
				6'd2	: rom_addr_from_state =  24;
				6'd3	: rom_addr_from_state =  36;
				6'd4	: rom_addr_from_state =  48;
				6'd5	: rom_addr_from_state =  60;
				6'd6	: rom_addr_from_state =  72;
				6'd7	: rom_addr_from_state =  84;
				6'd8	: rom_addr_from_state =  96;
				6'd9	: rom_addr_from_state = 108;
				6'd10	: rom_addr_from_state = 120;
				6'd11	: rom_addr_from_state = 132;
				6'd12	: rom_addr_from_state = 144;
				6'd13	: rom_addr_from_state = 156;
				6'd14	: rom_addr_from_state = 168;
				6'd15	: rom_addr_from_state = 180;
				6'd16	: rom_addr_from_state = 192;
				6'd17	: rom_addr_from_state = 204;
				6'd18	: rom_addr_from_state = 216;
				6'd19	: rom_addr_from_state = 228;
				6'd20	: rom_addr_from_state = 240;
				6'd21	: rom_addr_from_state = 252;
				6'd22	: rom_addr_from_state = 264;
				6'd23	: rom_addr_from_state = 276;
				6'd24	: rom_addr_from_state = 288;
				6'd25	: rom_addr_from_state = 300;
				6'd26	: rom_addr_from_state = 312;
				6'd27	: rom_addr_from_state = 324;
				6'd28	: rom_addr_from_state = 336;
				6'd29	: rom_addr_from_state = 348;
				6'd30	: rom_addr_from_state = 360;
				6'd31	: rom_addr_from_state = 372;
				6'd32	: rom_addr_from_state = 384;
				6'd33	: rom_addr_from_state = 396;
				6'd34	: rom_addr_from_state = 408;
				6'd35	: rom_addr_from_state = 420;
				6'd36	: rom_addr_from_state = 432;
				6'd37	: rom_addr_from_state = 444;
				6'd38	: rom_addr_from_state = 456;
				6'd39	: rom_addr_from_state = 468;
				default	: rom_addr_from_state =   0;
			endcase
		end
	endfunction

	always @(*) begin
		// Setup the default values
		next_srdy        = 1'b0;
		next_daddr       = DADDR;
		next_dwe         = 1'b0;
		next_den         = 1'b0;
		next_rst_mmcm    = RST_MMCM;
		next_di          = DI;
		next_rom_addr    = rom_addr;
		next_state_count = state_count;

		case (current_state)
			// If RST is asserted reset the machine
			RESTART: begin
				next_daddr    = 7'h00;
				next_di       = 16'h0000;
				next_rom_addr = 9'h000;
				next_rst_mmcm = 1'b1;
				next_state    = WAIT_LOCK;
			end

			// Waits for the MMCM to assert IntLocked - once it does asserts SRDY
			WAIT_LOCK: begin
				// Make sure reset is de-asserted
				next_rst_mmcm = 1'b0;
				// Reset the number of registers left to write for the next
				// reconfiguration event.
				next_state_count = STATE_COUNT_CONST;

				//CHANGED next_rom_addr = SADDR ? STATE_COUNT_CONST : 8'h00;
				//TO next_rom_addr = SADDR * STATE_COUNT_CONST;
				//next_rom_addr = SADDR * STATE_COUNT_CONST;
				next_rom_addr = rom_addr_from_state(SADDR);

				if (IntLocked) begin
					// MMCM is IntLocked, go on to wait for the SEN signal
					next_state = WAIT_SEN;
					// Assert SRDY to indicate that the reconfiguration module is
					// ready
					next_srdy  = 1'b1;
				end else begin
					// Keep waiting, IntLocked has not asserted yet
					next_state = WAIT_LOCK;
				end
			end

			// Wait for the next SEN pulse and set the ROM addr appropriately
			//    based on SADDR
			WAIT_SEN: begin
				next_rom_addr = rom_addr_from_state(SADDR);
				if (SEN) begin
					// Go on to address the MMCM
					next_state = ADDRESS;
				end else begin
					// Keep waiting for SEN to be asserted
					next_state = WAIT_SEN;
				end
			end

			// Set the address on the MMCM and assert DEN to read the value
			ADDRESS: begin
				// Reset the DCM through the reconfiguration
				next_rst_mmcm = 1'b1;
				// Enable a read from the MMCM and set the MMCM address
				next_den      = 1'b1;
				next_daddr    = rom_do[38:32];

				// Wait for the data to be ready
				next_state    = WAIT_A_DRDY;
			end

			// Wait for DRDY to assert after addressing the MMCM
			WAIT_A_DRDY: begin
				if (DRDY) begin
					// Data is ready, mask out the bits to save
					next_state = BITMASK;
				end else begin
					// Keep waiting till data is ready
					next_state = WAIT_A_DRDY;
				end
			end

			// Zero out the bits that are not set in the mask stored in rom
			BITMASK: begin
				// Do the mask
				next_di    = rom_do[31:16] & DO;
				// Go on to set the bits
				next_state = BITSET;
			end

			// After the input is masked, OR the bits with calculated value in rom
			BITSET: begin
				// Set the bits that need to be assigned
				next_di       = rom_do[15:0] | DI;
				// Set the next address to read from ROM
				next_rom_addr = rom_addr + 1'b1;
				// Go on to write the data to the MMCM
				next_state    = WRITE;
			end

			// DI is setup so assert DWE, DEN, and RST_MMCM.  Subtract one from the
			//    state count and go to wait for DRDY.
			WRITE: begin
				// Set WE and EN on MMCM
				next_dwe         = 1'b1;
				next_den         = 1'b1;

				// Decrement the number of registers left to write
				next_state_count = state_count - 1'b1;
				// Wait for the write to complete
				next_state       = WAIT_DRDY;
			end

			// Wait for DRDY to assert from the MMCM.  If the state count is not 0
			//    jump to ADDRESS (continue reconfiguration).  If state count is
			//    0 wait for lock.
			WAIT_DRDY: begin
				if (DRDY) begin
					// Write is complete
					if (state_count > 0) begin
						// If there are more registers to write keep going
						next_state = ADDRESS;
					end else begin
						// There are no more registers to write so wait for the MMCM
						// to lock
						next_state = WAIT_LOCK;
					end
				end else begin
					// Keep waiting for write to complete
					next_state = WAIT_DRDY;
				end
			end

			// If in an unknown state reset the machine
			default: begin
				next_state = RESTART;
			end
		endcase
	end
endmodule

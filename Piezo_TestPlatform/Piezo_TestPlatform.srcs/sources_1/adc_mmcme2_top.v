//------------------------------------------------------------------------------------------
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
// Device:              7-Series
// Author:              Tatsukawa, Kruger, Defossez
// Entity Name:         top_mmcme2
// Purpose:             This is a basic demonstration of the MMCM_DRP
//                      connectivity to the MMCM_ADV.
// Tools:               Vivado_2019.1 or newer
// Limitations:
//
// Vendor:              Xilinx Inc.
// Version:             1.40
// Filename:            top_mmcme2.v
// Date Created:        30-Jul-2014
// Date Last Modified:  25-Jun-2019
//-------------------------------------------------------------------------------------------
// Disclaimer:
//		This disclaimer is not a license and does not grant any rights to the materials
//		distributed herewith. Except as otherwise provided in a valid license issued to you
//		by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE MATERIALS
//		ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
//		WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED
//		TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR
//		PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort, including
//		negligence, or under any other theory of liability) for any loss or damage of any
//		kind or nature related to, arising under or in connection with these materials,
//		including for any direct, or any indirect, special, incidental, or consequential
//		loss or damage (including loss of data, profits, goodwill, or any type of loss or
//		damage suffered as a result of any action brought by a third party) even if such
//		damage or loss was reasonably foreseeable or Xilinx had been advised of the
//		possibility of the same.
//
// CRITICAL APPLICATIONS
//		Xilinx products are not designed or intended to be fail-safe, or for use in any
//		application requiring fail-safe performance, such as life-support or safety devices
//		or systems, Class III medical devices, nuclear facilities, applications related to
//		the deployment of airbags, or any other applications that could lead to death,
//		personal injury, or severe property or environmental damage (individually and
//		collectively, "Critical Applications"). Customer assumes the sole risk and
//		liability of any use of Xilinx products in Critical Applications, subject only to
//		applicable laws and regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
//
// Contact:    e-mail  hotline@xilinx.com        phone   + 1 800 255 7778
//-------------------------------------------------------------------------------------------
// Revision History:
//  Rev: 30-Apr-2014 - Tatsukawa
//      Initial code release
//  Rev: 25-Jun-2019 - Defossez
//      Add possibility to register the LOCKED signal.
//-------------------------------------------------------------------------------------------
//
`timescale 1ps/1ps
//
//-------------------------------------------------------------------------------------------
// Entity pin description
//-------------------------------------------------------------------------------------------
// Inputs
//      SSTEP:      Start a reconfiguration. It should only be pulsed for one clock cycle.
//      STATE:      Determines which state the MMCM_ADV will be reconfigured to. A value
//                  of 0 correlates to state 1, and a value of 1 correlates to state 2.
//      RST:        RST will reset the entire reference design including the MMCM_ADV.
//      CLKIN:      Clock for the MMCM_ADV CLKIN as well as the clock for the MMCM_DRP module
// Outputs
//      LOCKED_OUT:         MMCM is locked after configuration or reconfiguration.
//      CLK_ADC:            These are the clock outputs from the MMCM_ADV.
//-------------------------------------------------------------------------------------------
module adc_clkgen
    (
        input           SSTEP,
        input  [5:0]    STATE,
        input           RST,
        input           CLKIN,
 		output 	        LOCKED_OUT,
        output          CLK_ADC
    );
//-------------------------------------------------------------------------------------------
// These signals are used as direct connections between the MMCM_ADV and the
// MMCM_DRP.
(* mark_debug = "true" *) wire [15:0]    di;
(* mark_debug = "true" *) wire [6:0]     daddr;
(* mark_debug = "true" *) wire [15:0]    dout;
(* mark_debug = "true" *) wire           den;
(* mark_debug = "true" *) wire           dwe;
wire            dclk;
wire            rst_mmcm;
wire            drdy;
reg				current_state;
reg [7:0]		sstep_int ;
reg				init_drp_state = 1;
// These signals are used for the BUFG's necessary for the design.
wire            clkin_bufgout;
wire            clkfb_bufgout;
wire            clkfb_bufgin;
wire            clk4_bufgin;
wire            clk4_bufgout;
wire            LOCKED;
//-------------------------------------------------------------------------------------------
assign clkin_bufgout = CLKIN;
//
BUFG BUFG_FB    (.O (clkfb_bufgout),    .I (clkfb_bufgin));
BUFG BUFG_CLK4  (.O (clk4_bufgout),     .I (clk4_bufgin));
//
// // ODDR registers used to output clocks
// ODDR ODDR_CLK4 (.Q(CLK_ADC), .C(clk4_bufgout), .CE(1'b1), .D1(1'b1), .D2(1'b0), .R(RST), .S(1'b0));
assign CLK_ADC = clk4_bufgout;
//
// MMCM_ADV that reconfiguration will take place on
//
//  BANDWIDTH:              : "HIGH", "LOW" or "OPTIMIZED"
//  DIVCLK_DIVIDE           : Value from 1 to 106
//  CLKFBOUT_MULT_F         : Value from 2 to 64
//  CLKFBOUT_PHASE          :
//  CLKFBOUT_USE_FINE_PS    : "TRUE" or "FALSE",
//  CLKIN1_PERIOD           : Value from 0.968 to 100.000. Set the period (ns) of input clocks
//  REF_JITTER1             :
//  CLKIN2_PERIOD           :
//  REF_JITTER2             :
//  CLKOUT parameters:
//  DIVIDE                  : Value from 1 to 128
//  DUTY_CYCLE              : 0.01 to 0.99 - This is dependent on the divide value.
//  PHASE                   : 0.0 to 360.0 - This is dependent on the divide value.
//  USE_FINE_PS             : TRUE or FALSE
//  Misc parameters
//  COMPENSATION
//  STARTUP_WAIT
//
MMCME2_ADV #(
   .BANDWIDTH           ("OPTIMIZED"),
   .DIVCLK_DIVIDE       (1),
   .CLKFBOUT_MULT_F     (64),
   .CLKFBOUT_PHASE      (0.0),
   .CLKFBOUT_USE_FINE_PS("FALSE"),
   .CLKIN1_PERIOD       (83.333),
   .REF_JITTER1         (0.010),
   .CLKIN2_PERIOD       (0),
   .REF_JITTER2         (0.010),
   .CLKOUT0_DIVIDE_F    (64),
   .CLKOUT0_DUTY_CYCLE  (0.5),
   .CLKOUT0_PHASE       (0.0),
   .CLKOUT0_USE_FINE_PS ("FALSE"),
   .CLKOUT1_DIVIDE      (64),
   .CLKOUT1_DUTY_CYCLE  (0.5),
   .CLKOUT1_PHASE       (0.0),
   .CLKOUT1_USE_FINE_PS ("FALSE"),
   .CLKOUT2_DIVIDE      (64),
   .CLKOUT2_DUTY_CYCLE  (0.5),
   .CLKOUT2_PHASE       (0.0),
   .CLKOUT2_USE_FINE_PS ("FALSE"),
   .CLKOUT3_DIVIDE      (64),
   .CLKOUT3_DUTY_CYCLE  (0.5),
   .CLKOUT3_PHASE       (0.0),
   .CLKOUT3_USE_FINE_PS ("FALSE"),
   .CLKOUT4_DIVIDE      (64),
   .CLKOUT4_DUTY_CYCLE  (0.5),
   .CLKOUT4_PHASE       (0.0),
   .CLKOUT4_USE_FINE_PS ("FALSE"),
   .CLKOUT4_CASCADE     ("TRUE"), //IMPORTANT: cascades dividers of clkout4 and clkout6 for dividers >128
   .CLKOUT5_DIVIDE      (64),
   .CLKOUT5_DUTY_CYCLE  (0.5),
   .CLKOUT5_PHASE       (0.0),
   .CLKOUT5_USE_FINE_PS ("FALSE"),
   .CLKOUT6_DIVIDE      (4),
   .CLKOUT6_DUTY_CYCLE  (0.5),
   .CLKOUT6_PHASE       (0.0),
   .CLKOUT6_USE_FINE_PS ("FALSE"),
   .COMPENSATION        ("ZHOLD"),
   .STARTUP_WAIT        ("FALSE")
) mmcme2_adc_inst (
   .CLKFBOUT            (clkfb_bufgin),
   .CLKFBOUTB           (),
   .CLKFBSTOPPED        (),
   .CLKINSTOPPED        (),
   .CLKOUT0             (),
   .CLKOUT0B            (),
   .CLKOUT1             (),
   .CLKOUT1B            (),
   .CLKOUT2             (),
   .CLKOUT2B            (),
   .CLKOUT3             (),
   .CLKOUT3B            (),
   .CLKOUT4             (clk4_bufgin),
   .CLKOUT5             (),
   .CLKOUT6             (),
   .DO                  (dout),
   .DRDY                (drdy),
   .DADDR               (daddr),
   .DCLK                (dclk),
   .DEN                 (den),
   .DI                  (di),
   .DWE                 (dwe),
   .LOCKED              (LOCKED),
   .CLKFBIN             (clkfb_bufgout),
   .CLKIN1              (clkin_bufgout),
   .CLKIN2              (),
   .CLKINSEL            (1'b1),
   .PSDONE              (),
   .PSCLK               (1'b0),
   .PSEN                (1'b0),
   .PSINCDEC            (1'b0),
   .PWRDWN              (1'b0),
   .RST                 (rst_mmcm)
);
// MMCM_DRP instance that will perform the reconfiguration operations
adc_mmcme2_drp #(
    // Register the LOCKED signal with teh MMCME3_ADV input clock.
    // The LOCKED_IN (LOCKED from the MMCME3_ADV) is fed into a register and then
    // passed the LOCKED_OUT when REGISTER_LOCKED is set to "Reg" or when set to
    // "NoReg" LOCKED_IN is just passed on to LOCKED_OUT without being registered.
    .REGISTER_LOCKED       ("Reg"),
    // Use the registered LOCKED signal from the MMCME3 also for the DRP state machine.
    .USE_REG_LOCKED        ("No")
    // Possible combination of above two parameters:
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
) mmcme2_drp_inst (
    .SADDR              (STATE),
    .SEN                (sstep_int[0]),
    .RST                (RST),
    .SRDY               (SRDY),
    .SCLK               (clkin_bufgout),
    .DO                 (dout),
    .DRDY               (drdy),
    .LOCK_REG_CLK_IN    (clkin_bufgout),
    .LOCKED_IN          (LOCKED),
    .DWE                (dwe),
    .DEN                (den),
    .DADDR              (daddr),
    .DI                 (di),
    .DCLK               (dclk),
    .RST_MMCM           (rst_mmcm),
    .LOCKED_OUT         (LOCKED_OUT)
);
   //***********************************************************************
   // Additional STATE and SSTEP logic for push buttons and switches
   //***********************************************************************
// The following logic is not required but is being used to allow the DRP
// circuitry work more effectively with boards that use toggle switches or
// buttons that may not adhere to the single clock requirement.
//
// Only start DRP after initial lock and when STATE has changed
always @ (posedge clkin_bufgout)
    if (SSTEP) sstep_int <=  8'h80;
    else sstep_int <= {1'b0, sstep_int[7:1]};
//
//-------------------------------------------------------------------------------------------
endmodule

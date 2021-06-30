//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Tue Jun 29 14:59:43 2021
//Host        : DESKTOP-Q71H3IC running 64-bit major release  (build 9200)
//Command     : generate_target Clock_Config_wrapper.bd
//Design      : Clock_Config_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Clock_Config_wrapper
   (CLK_100MHz,
    CLK_10MHz,
    reset,
    sys_clock);
  output CLK_100MHz;
  output CLK_10MHz;
  input reset;
  input sys_clock;

  wire CLK_100MHz;
  wire CLK_10MHz;
  wire reset;
  wire sys_clock;

  Clock_Config Clock_Config_i
       (.CLK_100MHz(CLK_100MHz),
        .CLK_10MHz(CLK_10MHz),
        .reset(reset),
        .sys_clock(sys_clock));
endmodule

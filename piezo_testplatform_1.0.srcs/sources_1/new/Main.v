`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2021 12:25:19 PM
// Design Name: 
// Module Name: Main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Main(
    input sysclk,
    input btn0,
    input btn1,
    input SW1,
    input SW2,
    output led0,
    output led1,
    output led2, 
    output led3,
    output  EXT_LED1,
    output  EXT_LED2,
    output[3:0] DAC,
    output PiezoDriverEnable,
    output PiezoDriverSignalA,
    output PiezoDriverSignalB,
    output VGA_Enable
    );
    
    wire rst_n, CLK_100MHz, CLK_10MHz, Int_Btn0, Int_Btn1, Ext_SW1, EXT_SW2;
    
    assign PiezoDriverEnable = 1;
    assign VGA_Enable = 1;
    
    Reset_Gen RST_Gen(
        .sysclk(sysclk),
        .RST(rst_n)
        );
    
   Clock_Config CLK_Gen (
        .CLK_100MHz(CLK_100MHz),
        .CLK_10MHz(CLK_10MHz),
        .reset(rst_n),
        .sys_clock(sysclk)
        );
    
   Buttons Button_Inst(
        .btn0(btn0),
        .btn1(btn1),
        .SW1(SW1),
        .SW2(SW2),
        .sysclk(CLK_10MHz),
        .Int_Btn0(Int_Btn0),
        .Int_Btn1(Int_Btn1),
        .Ext_SW1(Ext_SW1),
        .Ext_SW2(Ext_SW2)
    );
    
    AD8331_Driver AD8331_Inst(
        .sysclk(CLK_10MHz),
        .Gain_Up(Int_Btn0),
        .Gain_Down(Int_Btn1),
        .DAC_Value(DAC),
        .led0(led0),
        .led1(led1),
        .led2(led2),
        .led3(led3)
    );
   /* 
    MosFet_Driver MosFet_Driver_Inst(
        .CLK_100(CLK_100MHz),
        .Nr_Pulses(10),
        .Start(Ext_SW1),
        .Finished(EXT_LED1),
        .PiezoDriverSignalA_N(N_Driver),
        .PiezoDriverSignalB_P(P_Driver)
    );
    */
    
    Repeat_Transmit Repeat_Transmit_Inst(
        .Nr_Pulses(10),
        .Delay_us(10000),
        .Enable(Rpt_Transmit_En),
        .CLK_10MHz(CLK_10MHz),
        .CLK_100MHz(CLK_100MHz),
        .PiezoDriverSignalA_N(N_Driver),
        .PiezoDriverSignalB_P(P_Driver)
        );
    
    Comm_Protocol Comm_Inst(
        .CLK_100MHz(CLK_100MHz),
		.CLK_10MHz(CLK_10MHz),
		.Start(Ext_SW2),
		.Data(4'b1010),
		.Charge_Pulses(100),
		.Start_L_us(500),
		.Zero_L(100),
		.One_L(200),
		.Break_L_us(200),
		.Finished(EXT_LED2),
		.PiezoDriverSignalA_N(N_Comm),
		.PiezoDriverSignalB_P(P_Comm)
	

);
    
    reg Comm_Driver = 0;
    reg Rpt_Transmit_En = 0;
    assign PiezoDriverSignalA = Comm_Driver ? N_Comm : N_Driver;
    assign PiezoDriverSignalB = Comm_Driver ? P_Comm : P_Driver;
    assign EXT_LED1 = Rpt_Transmit_En;
    
    always@(posedge CLK_10MHz) begin
    
        
       // if(Ext_SW1) LED1 <= !LED1; 
        if(Ext_SW1 == 1) begin
            Rpt_Transmit_En <= !Rpt_Transmit_En;
            Comm_Driver <= 0;
        end
        else if (Ext_SW2 == 1) begin
            Comm_Driver <= 1;
            Rpt_Transmit_En <= 0;
           end
    
    end
    
endmodule

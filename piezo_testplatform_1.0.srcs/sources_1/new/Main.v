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
    
    wire rst_n, CLK_100, Int_Btn0, Int_Btn1, Ext_SW1, EXT_SW2;
    
    assign PiezoDriverEnable = 1;
    assign VGA_Enable = 1;
    
    Reset_Gen RST_Gen(
        .sysclk(sysclk),
        .RST(rst_n)
        );
    
   Clock_Config CLK_Gen (
        .CLK_100(CLK_100),
        .reset(rst_n),
        .sys_clock(sysclk)
        );
    
   Buttons Button_Inst(
        .btn0(btn0),
        .btn1(btn1),
        .SW1(SW1),
        .SW2(SW2),
        .sysclk(sysclk),
        .Int_Btn0(Int_Btn0),
        .Int_Btn1(Int_Btn1),
        .Ext_SW1(Ext_SW1),
        .Ext_SW2(Ext_SW2)
    );
    
    AD8331_Driver AD8331_Inst(
        .sysclk(sysclk),
        .Gain_Up(Int_Btn0),
        .Gain_Down(Int_Btn1),
        .DAC_Value(DAC),
        .led0(led0),
        .led1(led1),
        .led2(led2),
        .led3(led3)
    );
    
    MosFet_Driver MosFet_Driver_Inst(
        .CLK_100(CLK_100),
        .Nr_Pulses(10),
        .Start(Ext_SW1),
        .Finished(EXT_LED1),
        .PiezoDriverSignalA_N(PiezoDriverSignalA),
        .PiezoDriverSignalB_P(PiezoDriverSignalB)
    );
    
    reg LED1 = 0;
    reg LED2 = 0;
    
   // assign EXT_LED1 = LED1;
    assign EXT_LED2 = LED2;
    always@(posedge sysclk) begin
    
        
       // if(Ext_SW1) LED1 <= !LED1; 
        if(Ext_SW2) LED2 <= !LED2; 
    
    end
    
endmodule

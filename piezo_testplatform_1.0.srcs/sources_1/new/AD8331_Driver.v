`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2021 01:38:06 PM
// Design Name: 
// Module Name: AD8331_Driver
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


module AD8331_Driver(
    input sysclk,
    input Gain_Up,
    input Gain_Down,
    output reg[3:0] DAC_Value,
    output led0,
    output led1,
    output led2,
    output led3
    );
    
    //DAC. Output Voltage = DACValue/15 [V]
    assign led0=DAC_Value[0];
    assign led1=DAC_Value[1];
    assign led2=DAC_Value[2];
    assign led3=DAC_Value[3];
    
    always@(posedge sysclk) begin
        if (Gain_Up == 1) DAC_Value <= DAC_Value + 1;
        if (Gain_Down == 1) DAC_Value <= DAC_Value - 1;
    
    end
    
    
endmodule

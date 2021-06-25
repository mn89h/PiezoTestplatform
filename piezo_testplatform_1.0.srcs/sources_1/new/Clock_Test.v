`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2021 10:27:06 AM
// Design Name: 
// Module Name: Clock_Test
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


module Clock_Test(
    input sysclk,
    output Testoclocko
    );
    
    wire CLK_Test;
    wire RST;
    
    assign Testoclocko = CLK_Test;
    
     Reset_Gen Gen(
        .sysclk(sysclk),
        .RST(RST)
        );
    
   Clock_Config Bla (
   .CLK_100(CLK_Test),
   .reset(RST),
   .sys_clock(sysclk));
    
    
endmodule

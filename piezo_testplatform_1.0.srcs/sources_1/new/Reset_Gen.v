`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2021 11:41:38 AM
// Design Name: 
// Module Name: Reset_Gen
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


module Reset_Gen(
    input sysclk,
    output RST
    );
    
    reg[7:0] Counter = 0;
    reg Reset = 1;
    
    assign RST = Reset;
    
    always@(posedge sysclk) begin
    
        if (Counter < 100) Counter <= Counter + 1;
        else Reset <= 0;
    end 
            
endmodule

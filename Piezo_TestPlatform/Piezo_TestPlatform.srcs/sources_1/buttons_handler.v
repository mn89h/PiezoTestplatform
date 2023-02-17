`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2021 10:34:19 AM
// Design Name: 
// Module Name: buttons_handler
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

module buttons_handler (
    input clk,
    input btn0,
    input btn1,
    input extsw1,
    input extsw2,
    input extsw3,
    input extsw4,
    output reg btn0_down,
    output reg btn1_down,
    output reg extsw1_down,
    output reg extsw2_down,
    output reg extsw3_down,
    output reg extsw4_down
    );
    
    localparam COUNTER_COMPARE_VALUE = 524260;  //Debounce length in sysclk cycles. Equals to 0.05s at 12MHz

    
    reg[23:0] counter = 0;
    
    reg[1:0] btn0_pressed = 0;
    reg[1:0] btn1_pressed = 0;
    reg[1:0] extsw1_pressed = 0;
    reg[1:0] extsw2_pressed = 0;
    reg[1:0] extsw3_pressed = 0;
    reg[1:0] extsw4_pressed = 0;
    
    always @(posedge clk ) begin
        if ((btn0 == 1) && (btn0_pressed == 0)) begin
            btn0_down <= 1;
            btn0_pressed <= 1;
        end 
        else begin
            btn0_down <= 0;
        end
        
        if ((btn1 == 1) && (btn1_pressed == 0)) begin
            btn1_down <= 1;
            btn1_pressed <= 1;
        end 
        else begin
            btn1_down <= 0;
        end
        
        if ((extsw1 == 0) && (extsw1_pressed == 0)) begin
            extsw1_down <= 1;
            extsw1_pressed <= 1;
        end 
        else begin
            extsw1_down <= 0;
        end
        
        if ((extsw2 == 0) && (extsw2_pressed == 0)) begin
            extsw2_down <= 1;
            extsw2_pressed <= 1;
        end 
        else begin
            extsw2_down <= 0;
        end
        
        if ((extsw3 == 0) && (extsw3_pressed == 0)) begin
            extsw3_down <= 1;
            extsw3_pressed <= 1;
        end 
        else begin
            extsw3_down <= 0;
        end
        
        if ((extsw4 == 0) && (extsw4_pressed == 0)) begin
            extsw4_down <= 1;
            extsw4_pressed <= 1;
        end 
        else begin
            extsw4_down <= 0;
        end
        
        if (counter < COUNTER_COMPARE_VALUE) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
            
            if ((btn0_pressed == 1) && (btn0 == 0)) btn0_pressed <= 2;
            if ((btn0_pressed == 2) && (btn0 == 0)) btn0_pressed <= 0;
      
            if ((btn1_pressed == 1) && (btn1 == 0)) btn1_pressed <= 2;
            if ((btn1_pressed == 2) && (btn1 == 0)) btn1_pressed <= 0;
            
            if ((extsw1_pressed == 1) && (extsw1 == 1)) extsw1_pressed <= 2;
            if ((extsw1_pressed == 2) && (extsw1 == 1)) extsw1_pressed <= 0;
            
            if ((extsw2_pressed == 1) && (extsw2 == 1)) extsw2_pressed <= 2;
            if ((extsw2_pressed == 2) && (extsw2 == 1)) extsw2_pressed <= 0;

            if ((extsw3_pressed == 1) && (extsw3 == 1)) extsw3_pressed <= 2;
            if ((extsw3_pressed == 2) && (extsw3 == 1)) extsw3_pressed <= 0;

            if ((extsw4_pressed == 1) && (extsw4 == 1)) extsw4_pressed <= 2;
            if ((extsw4_pressed == 2) && (extsw4 == 1)) extsw4_pressed <= 0;
        end
    end
endmodule

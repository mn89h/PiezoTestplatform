`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2023 16:40:56
// Design Name: 
// Module Name: piezo_driver
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


module piezo_driver(
    input wire clk_100,
    input wire [11:0] numpulses,
    input wire start,
    output reg fin = 1,
    output wire piezodriver_lo,
    output wire piezodriver_hi
    );
    
    parameter DLY = 5;                      // turn-on delay from rising/falling edge to output. Time per step: 1/clk
    parameter COUNTER_COMPARE_VALUE = 50;   // results in T = 50 * 10ns or f = 2MHz 
    
    reg busy = 0;
    reg out0 = 0;
    reg out1 = 1;
    reg clk_piezo = 0;
    reg [9:0] clk_div = 0;
    reg [3:0] dly0 = DLY;
    reg [3:0] dly1 = DLY;
   
    reg[15:0] pulse_counter = 65535;
    

		
    assign piezodriver_lo = fin ? 0 : out0;
    assign piezodriver_hi = fin ? 0 : out1;
	
    
    always@(posedge(clk_100)) begin
        
        busy <= start;
	    if(busy == 0 && start == 1) begin
            pulse_counter <= 0;
            clk_div <= 0;
            fin <= 0;
	    end 
        else begin
            // Generating Piezo Clock
            if (clk_div == COUNTER_COMPARE_VALUE) begin
                clk_div <= 0;
                if(pulse_counter < ((numpulses << 1)-1)) begin
                    clk_piezo <= !clk_piezo;
                    pulse_counter <= pulse_counter + 1;
                end
                else begin
                    fin <= 1;
                    out0 <= 0;
                    out1 <= 1;
                    clk_piezo <= 0;
                    dly0 <= DLY;
                    dly1 <= DLY;
		        end
            end
            else clk_div <= clk_div + 1;
	    end
	
    
         //---------------------------Generating output FET signals 
        if (clk_piezo) begin
            dly1 <= DLY;//reset out1 timer
            out1 <= 0;//set out1 to "LOW" immediately
            if (dly0 > 0) begin 
                dly0 <= dly0 - 1;
            end else out0 <= 1;//set out0 to "HIGH" after n clk cycles, specified by DLY
        end
        
        if (!clk_piezo) begin
            dly0 <= DLY;//reset out0 timer
            out0 <= 0;//set out0 to "LOW" immediately
            if (dly1 > 0) begin    
                dly1 <= dly1 - 1;
            end else out1 <= 1;//set out1 to "HIGH" after n clk cycles, specified by DLY
        end
    end
    
endmodule
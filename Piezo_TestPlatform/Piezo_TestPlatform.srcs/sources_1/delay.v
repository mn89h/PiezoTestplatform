`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2023 16:40:56
// Design Name: 
// Module Name: delay
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


module delay (
	input clk_12,
	input [23:0] delay_us,
	input start,
	output reg fin = 1
	);

	reg busy = 0;

	reg [23:0] counter    = 0;
	reg [3:0]  counter_12 = 0;

	always@(posedge clk_12) begin
		busy <= start;
		if(busy == 0 && start == 1) begin
			fin <= 0;
		end

		if(fin == 1) begin
			counter_12 <= 0;
			counter <= 1;
		end 
        else begin
            //Divide by 10
            if(counter_12 == 11) begin
                counter_12 <= 0;

                // Create Delay
                if (fin == 0) begin
                    counter <= counter + 1;
                    if(counter == delay_us) begin
                        fin <= 1;
                    end 
                    else begin
                        fin <= 0;
                    end
                end 
                else counter <= 0;
            end 
            else begin
                counter_12 <= counter_12 + 1;
            end
        end
	end
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2021 02:16:53 PM
// Design Name: 
// Module Name: MosFet_Driver
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

module MosFet_Driver(
    input CLK_100,
    input[11:0] Nr_Pulses,
    input Start,
    output reg Finished = 1,
    output PiezoDriverSignalA_N,
    output PiezoDriverSignalB_P
    );
    
    parameter dly = 5;//turn-on delay from rising/falling edge to output. Time per step: 1/clk
    parameter Counter_Compare_Value = 50;
    
    reg Start_Merker = 0;
    reg out0 = 0;
    reg out1 = 1;
    reg[9:0] clk_div = 0;
    reg clk_Piezo = 0;
    reg[3:0] dly0=dly;
    reg[3:0] dly1=dly;
   
    reg[15:0] Pulse_Counter = 65535;
    

		
    assign PiezoDriverSignalA_N = Finished ? 0 : out0;
    assign PiezoDriverSignalB_P = Finished ? 1 : ~out1;
	
    
    always@(posedge(CLK_100)) begin
        
        Start_Merker <= Start;
	if(Start_Merker == 0 && Start == 1) begin
            Pulse_Counter <= 0;
            clk_div <= 0;
            Finished <= 0;


	end else begin
            // Generating Piezo Clock
            if (clk_div == Counter_Compare_Value) begin
                clk_div <= 0;
                if(Pulse_Counter < ((Nr_Pulses << 1)-1)) begin
                    clk_Piezo <= !clk_Piezo;
                    Pulse_Counter <= Pulse_Counter + 1;
                    
                end
                else begin
                    Finished <= 1;
                    out0 <= 0;
                    out1 <= 1;
                    clk_Piezo <= 0;
                    dly0 <= dly;
                    dly1 <= dly;
		    end
            
            
             end
             else clk_div <= clk_div + 1;
	end
	
    
         //---------------------------Generating output FET signals 
        if (clk_Piezo) begin
            dly1 <= dly;//reset out1 timer
            out1 <= 0;//set out1 to "LOW" immediately
            if (dly0 > 0) begin 
                dly0 <= dly0 - 1;
            end else out0 <= 1;//set out0 to "HIGH" after n clk cycles, specified by dly
        end
        
        if (!clk_Piezo) begin
            dly0 <= dly;//reset out0 timer
            out0 <= 0;//set out0 to "LOW" immediately
            if (dly1 > 0) begin    
                dly1 <= dly1 - 1;
            end else out1 <= 1;//set out1 to "HIGH" after n clk cycles, specified by dly
        end
    end
    
endmodule

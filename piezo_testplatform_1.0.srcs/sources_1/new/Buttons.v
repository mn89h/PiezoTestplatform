`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2021 10:34:19 AM
// Design Name: 
// Module Name: Buttons
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

module Buttons(
    input btn0,
    input btn1,
    input SW1,
    input SW2,
    input sysclk,
    output reg Int_Btn0,
    output reg Int_Btn1,
    output reg Ext_SW1,
    output reg Ext_SW2
    );
    
    parameter Counter_Compare_Value = 524260;//Debounce length in sysclk cycles. Equals to 0.05s at 12MHz

    
    reg[23:0] Counter = 0;
    
    reg[1:0] btn0_Merker = 0;
    reg[1:0] btn1_Merker = 0;
    reg[1:0] SW1_Merker = 0;
    reg[1:0] SW2_Merker = 0;
    
    always@(posedge(sysclk)) begin
        //Debounce
        if (Counter < Counter_Compare_Value) begin
            Counter <= Counter + 1;
        end else begin
        
            Counter <= 0;
            
            if ((btn0_Merker == 1) && (btn0 == 0)) btn0_Merker <= 2;
            if ((btn0_Merker == 2) && (btn0 == 0)) btn0_Merker <= 0;
      
            if ((btn1_Merker == 1) && (btn1 == 0)) btn1_Merker <= 2;
            if ((btn1_Merker == 2) && (btn1 == 0)) btn1_Merker <= 0;
            
            if ((SW1_Merker == 1) && (SW1 == 1)) SW1_Merker <= 2;
            if ((SW1_Merker == 2) && (SW1 == 1)) SW1_Merker <= 0;
            
            if ((SW2_Merker == 1) && (SW2 == 1)) SW2_Merker <= 2;
            if ((SW2_Merker == 2) && (SW2 == 1)) SW2_Merker <= 0;
            
            
        end
    
        if ((btn0 == 1) && (btn0_Merker == 0)) begin
            Int_Btn0 <= 1;
            btn0_Merker <= 1;
        end else begin
            Int_Btn0 <= 0;
        end
        
        if ((btn1 == 1) && (btn1_Merker == 0)) begin
            Int_Btn1 <= 1;
            btn1_Merker <= 1;
        end else begin
            Int_Btn1 <= 0;
        end
        
        if ((SW1 == 0) && (SW1_Merker == 0)) begin
            Ext_SW1 <= 1;
            SW1_Merker <= 1;
        end else begin
            Ext_SW1 <= 0;
        end
        
        if ((SW2 == 0) && (SW2_Merker == 0)) begin
            Ext_SW2 <= 1;
            SW2_Merker <= 1;
        end else begin
            Ext_SW2 <= 0;
        end
        
       
    end
endmodule

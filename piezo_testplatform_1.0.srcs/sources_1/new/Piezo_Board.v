`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.05.2021 16:17:39
// Design Name: 
// Module Name: Piezo_Board
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
//parameter dly = 2;//turn-on delay from rising/falling edge to output. Time per step: 1/clk
//parameter debounce = 1048576;//Debounce length in sysclk cycles. Equals to 0.1s at 12MHz

module Piezo_Board(
    input sysclk, clk700k, EXT_SW1, EXT_SW2, btn0, btn1, HDR2, HDR3, HDR4, HDR5,
    output led0, led1, led2, led3, HDR6, HDR7, EXT_LED1, EXT_LED2, PiezoDriverSignalA, PiezoDriverSignalB, RST, CLK_Digital, dac0, dac1, dac2, dac3, VGA_Enable, ChipDriverEnable, PiezoDriverEnable
    );


reg[23:0] clk_div = 0;
reg[23:0] debounceCounter = debounce;

reg out0, out1 = 0;

reg[7:0] dly0=dly;
reg[7:0] dly1=dly;
reg[3:0] DACValue = 0;

reg EXT_SW1prev = 1;
reg EXT_SW2prev = 1;
reg btn0Prev = 0;
reg btn1Prev = 0;



//set debugging clock output(clk700kout bzw. HDR7) to 12MHz/2^(3+1) = 750kHz. HDR5 Pin is used as debugging clk
assign HDR6=1;
assign HDR7=clk_div[3];

//Piezo FET output
assign PiezoDriverSignalA = out0;
assign PiezoDriverSignalB = ~out1;
//assign led0=out0;
//assign led1=out1;

//DAC. Output Voltage = DACValue/15 [V]
assign dac0=DACValue[0];
assign dac1=DACValue[1];
assign dac2=DACValue[2];
assign dac3=DACValue[3];
assign led0=DACValue[0];
assign led1=DACValue[1];
assign led2=DACValue[2];
assign led3=DACValue[3];

assign VGA_Enable=HDR2;
assign ChipDriverEnable=HDR3;
assign PiezoDriverEnable=HDR4;



always@(posedge(sysclk)) begin



    //Debounce
    if (debounceCounter<debounce) begin
        debounceCounter <= debounceCounter + 1;
    end
    
    //---------------------------used for generating 750k debugging clk
    clk_div <= clk_div + 1;
    
    //---------------------------Getting inputs
    
    if ((btn0==1)&&(btn0Prev==0)&&(debounceCounter==debounce)) begin
        DACValue <= DACValue + 1;
    end
    
    if ((btn1==1)&&(btn1Prev==0)&&(debounceCounter==debounce)) begin
        DACValue <= DACValue - 1;
    end
    
    if ((EXT_SW1==0)&&(EXT_SW1prev==1)&&(debounceCounter==debounce)) begin
        //DACValue[2] <= !DACValue[2];
    end
    
    if ((EXT_SW2==0)&&(EXT_SW2prev==1)&&(debounceCounter==debounce)) begin
        //DACValue[3] <= !DACValue[3];
    end
    
    if (btn0||btn1||!EXT_SW1||!EXT_SW2) debounceCounter <= 0;
    
    btn0Prev<=btn0;
    btn1Prev<=btn1;
    EXT_SW1prev<=EXT_SW1;
    EXT_SW2prev<=EXT_SW2;
    
    //---------------------------Generating output FET signals 
    if (clk700k) begin
        dly1 <= dly;//reset out1 timer
        out1 <= 0;//set out1 to "LOW" immediately
        if (dly0 > 0) begin 
            dly0 <= dly0 - 1;
        end else out0 <= 1;//set out0 to "HIGH" after n clk cycles, specified by dly
    end
    
    if (!clk700k) begin
        dly0 <= dly;//reset out0 timer
        out0 <= 0;//set out0 to "LOW" immediately
        if (dly1 > 0) begin    
            dly1 <= dly1 - 1;
        end else out1 <= 1;//set out1 to "HIGH" after n clk cycles, specified by dly
    end
    
    //---------------------------
       
end



endmodule

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

//Uart params
// Testbench uses a 10 MHz clock
// Want to interface to 115200 baud UART
// 10000000 / 115200 = 87 Clocks Per Bit.
//parameter c_CLOCK_PERIOD_NS = 83; unused
parameter c_CLKS_PER_BIT    = 1042;//9600baud, 10MHz
parameter uart_buffer_length = 128;//Buffer length in bits. 128bit=16 byte

module Main(
    input sysclk,
    input btn0,
    input btn1,
    input SW1,
    input SW2,
    input wire uart_rx_pin,
    output wire uart_tx_pin,
    output led0,
    output led1,
    output led2, 
    output led3,
    output reg HDR2 = 0,
    output  EXT_LED1,
    output  EXT_LED2,
    output[3:0] DAC,
    output PiezoDriverSignalA,
    output PiezoDriverSignalB,
    output wire PiezoDriverEnable,
    output wire VGA_Enable
    );
    
    reg Comm_Driver = 0;
    reg Rpt_Transmit_En = 0;
    
    wire rst_n, CLK_100MHz, CLK_10MHz, Int_Btn0, Int_Btn1, Ext_SW1, EXT_SW2;
    wire[3:0] Data_w;
	wire[11:0] Charge_Pulses_w;
	wire[15:0] Start_L_us_w;
	wire[11:0] Zero_L_w;
	wire[11:0] One_L_w;
	wire[15:0] Break_L_us_w;

    assign PiezoDriverSignalA = Comm_Driver ? N_Comm : N_Driver;
    assign PiezoDriverSignalB = Comm_Driver ? P_Comm : P_Driver;
    assign EXT_LED1 = Rpt_Transmit_En;
    
    
    SerialComm #(.CLKS_PER_BIT(c_CLKS_PER_BIT), .BUFFER_LENGTH(uart_buffer_length)) SerialCommInst
       (.sysclk(CLK_10MHz),
        //Communication pins
        .uart_rx_pin(uart_rx_pin),
        .uart_tx_pin(uart_tx_pin),
        //Periphery
        .VGA_Enable(VGA_Enable),
        .PiezoDriverEnable(PiezoDriverEnable),
        //Wires that control internal settings
        .Data(Data_w),
        .Charge_Pulses(Charge_Pulses_w),
        .Start_L_us(Start_L_us_w),
        .Zero_L(Zero_L_w),
        .One_L(One_L_w),
        .Break_L_us(Break_L_us_w)
        );

    Reset_Gen RST_Gen(
        .sysclk(sysclk),
        .RST(rst_n)
        );
    
   Clock_Config CLK_Gen (
        .CLK_100MHz(CLK_100MHz),
        .CLK_10MHz(CLK_10MHz),
        .reset(rst_n),
        .sys_clock(sysclk)
        );
    
   Buttons Button_Inst(
        .btn0(btn0),
        .btn1(btn1),
        .SW1(SW1),
        .SW2(SW2),
        .sysclk(CLK_10MHz),
        .Int_Btn0(Int_Btn0),
        .Int_Btn1(Int_Btn1),
        .Ext_SW1(Ext_SW1),
        .Ext_SW2(Ext_SW2)
    );
    
    AD8331_Driver AD8331_Inst(
        .sysclk(CLK_10MHz),
        .Gain_Up(Int_Btn0),
        .Gain_Down(Int_Btn1),
        .DAC_Value(DAC),
        .led0(led0),
        .led1(led1),
        .led2(led2),
        .led3(led3)
    );
   /* 
    MosFet_Driver MosFet_Driver_Inst(
        .CLK_100(CLK_100MHz),
        .Nr_Pulses(10),
        .Start(Ext_SW1),
        .Finished(EXT_LED1),
        .PiezoDriverSignalA_N(N_Driver),
        .PiezoDriverSignalB_P(P_Driver)
    );
    */
    
    Repeat_Transmit Repeat_Transmit_Inst(
        .Nr_Pulses(100),
        .Delay_us(200000),
        .Enable(Rpt_Transmit_En),
        .CLK_10MHz(CLK_10MHz),
        .CLK_100MHz(CLK_100MHz),
        .PiezoDriverSignalA_N(N_Driver),
        .PiezoDriverSignalB_P(P_Driver)
        );
    
    Comm_Protocol Comm_Inst(//Put these values into serial communication
        .CLK_100MHz(CLK_100MHz),
		.CLK_10MHz(CLK_10MHz),
		.Start(Ext_SW2),
		.Data(Data_w),//DAT
		.Charge_Pulses(Charge_Pulses_w),//CHP
		.Start_L_us(Start_L_us_w),//STL
		.Zero_L(Zero_L_w),//Z_L
		.One_L(One_L_w),//O_L
		.Break_L_us(Break_L_us_w),//B_L
		.Finished(EXT_LED2),
		.PiezoDriverSignalA_N(N_Comm),
		.PiezoDriverSignalB_P(P_Comm)
	    );
    
  
    always@(posedge CLK_10MHz) begin

        
       // if(Ext_SW1) LED1 <= !LED1; 
        if(Ext_SW1 == 1) begin
            Rpt_Transmit_En <= !Rpt_Transmit_En;
            Comm_Driver <= 0;
        end
        else if (Ext_SW2 == 1) begin
            Comm_Driver <= 1;
            Rpt_Transmit_En <= 0;
        end

    end
    
endmodule

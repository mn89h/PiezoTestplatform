`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2023 13:12:38
// Design Name: 
// Module Name: tb_fifo_x2byte
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

`ifdef iverilog
    `include "../sources_1/fifo_x2byte.v"
`endif


module tb_fifo_x2byte;

// fifo_x2byte Parameters
parameter PERIOD             = 10;
parameter INPUT_WIDTH_BYTES  = 6;
parameter FIFO_DEPTH_INPUT   = 2;

// fifo_x2byte Inputs
reg   clk                                  = 0 ;
reg   rst                                  = 0 ;
reg   rd_en                                = 0 ;
reg   wr_en                                = 0 ;
reg   [(INPUT_WIDTH_BYTES*8)-1:0]  data_in = 0 ;

// fifo_x2byte Outputs
wire  [7:0]  data_out                      ;
wire  full                                 ;
wire  empty                                ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end


fifo_x2byte #(
    .INPUT_WIDTH_BYTES ( INPUT_WIDTH_BYTES ),
    .FIFO_DEPTH_INPUT  ( FIFO_DEPTH_INPUT  ))
 u_fifo_x2byte (
    .clk                     ( clk                                   ),
    .rst                     ( rst                                   ),
    .rd_en                   ( rd_en                                 ),
    .wr_en                   ( wr_en                                 ),
    .data_in                 ( data_in   [(INPUT_WIDTH_BYTES*8)-1:0] ),

    .data_out                ( data_out  [7:0]                       ),
    .full                    ( full                                  ),
    .empty                   ( empty                                 )
);

initial
begin
$dumpfile("tb_fifo_x2byte.vcd");
$dumpvars(0, tb_fifo_x2byte);
    clk = 1;
    rd_en = 0;
    wr_en = 0;
    #(2*PERIOD)
    data_in = 48'h010203040506;
    wr_en = 1;
    #PERIOD
    wr_en = 1;
    data_in = 48'h020304050607;
    #PERIOD
    wr_en = 1;
    rd_en=1;
    // #PERIOD
    // rd_en = 0;
    // #PERIOD
    // rd_en=1;
    // #PERIOD
    // rd_en=0;
    #(30*PERIOD)
    $finish;
end

endmodule
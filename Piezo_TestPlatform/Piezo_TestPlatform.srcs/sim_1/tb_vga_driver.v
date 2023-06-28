`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2023 13:12:38
// Design Name: 
// Module Name: tb_vga_driver
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
    `include "../sources_1/vga_driver.v"
    `include "../sources_1/serial_tx_handler.v"
`endif

module tb_vga_driver;

`include "../sources_1/serial_defines.hv"
// vga_driver Parameters
parameter PERIOD  = 10;


// vga_driver Inputs
reg   clk                                  = 0 ;
reg   Gain_Up                              = 0 ;
reg   Gain_Down                            = 0 ;
reg   [2:0]  rx_dst                        = 0 ;
reg   [3:0]  rx_cmd                        = 0 ;
reg   [4:0]  rx_val                        = 0 ;
reg   rx_fin                               = 0 ;
wire  tx_ready                                 ;

// vga_driver Outputs
wire  tx_valid                             ;
wire  [7:0]  tx_data                       ;
wire  [3:0]  dac_value                     ;
wire  led0                                 ;
wire  led1                                 ;
wire  led2                                 ;
wire  led3                                 ;

// serial_tx_handler Outputs
wire  uart_tx_stream;

serial_tx_handler  u_serial_tx_handler (
    .clk                     ( clk               ),
    .vga_data_valid          ( tx_valid          ),
    .vga_data                ( tx_data           ),

    .uart_tx_stream          ( uart_tx_stream    ),
    .vga_data_ready          ( tx_ready          )
);


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end


vga_driver  u_vga_driver (
    .clk                     ( clk              ),
    .Gain_Up                 ( Gain_Up          ),
    .Gain_Down               ( Gain_Down        ),
    .rx_dst                  ( rx_dst     [2:0] ),
    .rx_cmd                  ( rx_cmd     [3:0] ),
    .rx_val                  ( rx_val     [4:0] ),
    .rx_fin                  ( rx_fin           ),
    .tx_ready                ( tx_ready         ),

    .tx_valid                ( tx_valid         ),
    .tx_data                 ( tx_data    [7:0] ),
    .dac_value               ( dac_value  [3:0] ),
    .led0                    ( led0             ),
    .led1                    ( led1             ),
    .led2                    ( led2             ),
    .led3                    ( led3             )
);

initial
begin
$dumpfile("tb_vga_driver.v");
$dumpvars(0, tb_vga_driver);
    clk = 0;
    #1000
    //print status
    rx_dst = DESTINATION_VGA;
    rx_cmd = COMMAND_STATUS;
    rx_val = 0;
    rx_fin = 1;
    #10
    rx_fin = 0;
    #10
    //change gain
    rx_dst = DESTINATION_VGA;
    rx_cmd = COMMAND_GAIN;
    rx_val = 8;
    rx_fin = 1;
    #10
    rx_fin = 0;
    #10
    
    #100000
    $finish;
end

endmodule
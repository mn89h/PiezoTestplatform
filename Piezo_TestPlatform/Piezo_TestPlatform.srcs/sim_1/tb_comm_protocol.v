`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2023 13:12:38
// Design Name: 
// Module Name: tb_comm_protocol
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
    `include "../sources_1/comm_protocol.v"
    `include "../sources_1/serial_tx_handler.v"
`endif

module tb_comm_protocol;

`include "../sources_1/serial_defines.hv"

// comm_protocol Parameters
parameter PERIOD        = 100    ;
parameter PERIOD100M    = 10     ;
parameter TIMESTEP      = PERIOD ;
parameter DEFAULT_DATA  = 4'b0101;
parameter DEFAULT_CHP   = 12'd100;
parameter DEFAULT_STL   = 16'd500;
parameter DEFAULT_0L    = 12'd100;
parameter DEFAULT_1L    = 12'd200;
parameter DEFAULT_BRL   = 16'd200;

// comm_protocol Inputs
reg   clk_100                              = 0 ;
reg   clk                               = 0 ;
reg   btn_start                            = 0 ;
reg   [2:0]  rx_dst                        = 0 ;
reg   [3:0]  rx_cmd                        = 0 ;
reg   [15:0]  rx_val                        = 0 ;
reg   rx_fin                               = 0 ;
wire  tx_ready                                 ;

// comm_protocol Outputs
wire  tx_valid                             ;
wire  [7:0]  tx_data                       ;
wire  comm_fin                             ;
wire  piezodriver_lo                       ;
wire  piezodriver_hi                       ;

// serial_tx_handler Outputs
wire  uart_tx_stream;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end
initial
begin
    forever #(PERIOD100M/2)  clk_100=~clk_100;
end

comm_protocol #(
    .DEFAULT_DATA ( DEFAULT_DATA ),
    .DEFAULT_CHP  ( DEFAULT_CHP  ),
    .DEFAULT_STL  ( DEFAULT_STL  ),
    .DEFAULT_0L   ( DEFAULT_0L   ),
    .DEFAULT_1L   ( DEFAULT_1L   ),
    .DEFAULT_BRL  ( DEFAULT_BRL  ))
 u_comm_protocol (
    .clk_100                 ( clk_100                ),
    .clk                     ( clk                    ),
    .btn_start               ( btn_start              ),
    .rx_dst                  ( rx_dst           [2:0] ),
    .rx_cmd                  ( rx_cmd           [3:0] ),
    .rx_val                  ( rx_val           [4:0] ),
    .rx_fin                  ( rx_fin                 ),
    .tx_ready                ( tx_ready               ),

    .tx_valid                ( tx_valid               ),
    .tx_data                 ( tx_data          [7:0] ),
    .comm_fin                ( comm_fin               ),
    .piezodriver_lo          ( piezodriver_lo         ),
    .piezodriver_hi          ( piezodriver_hi         )
);

serial_tx_handler  u_serial_tx_handler (
    .clk                     ( clk               ),
    .comm_data_valid         ( tx_valid          ),
    .comm_data               ( tx_data           ),

    .uart_tx_stream          ( uart_tx_stream    ),
    .comm_data_ready         ( tx_ready          )
);


initial
begin
$dumpfile("tb_comm_protocol.vcd");
$dumpvars(0, tb_comm_protocol);
    clk = 0;
    clk_100 = 0;
    #1000

    //change chp
    rx_dst = DESTINATION_COMM;
    rx_cmd = COMMAND_SETCHP;
    rx_val = 8;
    rx_fin = 1;
    #TIMESTEP
    rx_fin = 0;
    #TIMESTEP
    #TIMESTEP
    #TIMESTEP

    
    //print status
    rx_dst = DESTINATION_COMM;
    rx_cmd = COMMAND_STATUS;
    rx_val = 0;
    rx_fin = 1;
    #TIMESTEP
    rx_fin = 0;
    #TIMESTEP
    
    //start
    rx_dst = DESTINATION_COMM;
    rx_cmd = COMMAND_START;
    rx_val = 0;
    rx_fin = 1;
    #TIMESTEP
    rx_fin = 0;
    #TIMESTEP
    
    #6000000
    $finish;
end

endmodule
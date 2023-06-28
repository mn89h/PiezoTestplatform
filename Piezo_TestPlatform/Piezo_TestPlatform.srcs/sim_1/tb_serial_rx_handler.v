`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2023 13:12:38
// Design Name: 
// Module Name: tb_serial_rx_handler
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
    `include "../sources_1/serial_rx_handler.v"
`endif

module tb_serial_rx_handler;

// serial_rx_handler Parameters
parameter PERIOD  = 10;
parameter TIMESTEP = PERIOD*10;
parameter STOP = 1;
parameter START = 0;


// serial_rx_handler Inputs
reg   clk                                  = 0 ;
reg   uart_rx_stream                       = 0 ;

// serial_rx_handler Outputs
wire  [2:0]  rx_dst                            ;
wire  [3:0]  rx_cmd                            ;
wire  [12:0] rx_val                            ;
wire         rx_fin                            ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end


serial_rx_handler  u_serial_rx_handler (
    .clk                     ( clk                   ),
    .uart_rx_stream          ( uart_rx_stream        ),

    .rx_dst                 ( rx_dst                ),
    .rx_cmd                 ( rx_cmd                ),
    .rx_val                 ( rx_val                ),
    .rx_fin                 ( rx_fin                )
);

initial
begin
$dumpfile("tb_serial_rx_handler.vcd");
$dumpvars(0, tb_serial_rx_handler);
    uart_rx_stream = STOP; #(TIMESTEP)
    //V
    uart_rx_stream = START; #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = STOP;  #(TIMESTEP)
    //G
    uart_rx_stream = START; #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = STOP;  #(TIMESTEP)
    //A
    uart_rx_stream = START; #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = STOP;  #(TIMESTEP)
    //:
    uart_rx_stream = START; #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = STOP;  #(TIMESTEP)
    //G \u1000111
    uart_rx_stream = START; #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = STOP;  #(TIMESTEP)
    //A \u1000001
    uart_rx_stream = START; #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = STOP;  #(TIMESTEP)
    //I \u1001001
    uart_rx_stream = START; #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = STOP;  #(TIMESTEP)
    //N \u1001110
    uart_rx_stream = START; #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = STOP;  #(TIMESTEP)
    //  \u100000
    uart_rx_stream = START; #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = STOP;  #(TIMESTEP)
    //1 \u110001
    uart_rx_stream = START; #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = STOP;  #(TIMESTEP)
    //0 \u110000
    uart_rx_stream = START; #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = STOP;  #(TIMESTEP)
    //\n
    uart_rx_stream = START; #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 1;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = 0;     #(TIMESTEP)
    uart_rx_stream = STOP;  #(TIMESTEP)
    #(10*TIMESTEP)
    $finish;
end

endmodule
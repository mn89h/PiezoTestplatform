`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2023 13:12:38
// Design Name: 
// Module Name: tb_serial_tx_handler
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
    `include "../sources_1/serial_tx_handler.v"
`endif

module tb_serial_tx_handler;

// serial_tx_handler Parameters
parameter PERIOD  = 10;


// serial_tx_handler Inputs
reg   clk                                  = 0 ;
reg   vga_data_valid                       = 0 ;
reg   [7:0]  vga_data                      = 0 ;
reg   comp_data_valid                      = 0 ;
reg   [7:0]  comp_data                     = 0 ;
reg   adc_data_valid                       = 0 ;
reg   [7:0]  adc_data                      = 0 ;
reg   comm_data_valid                      = 0 ;
reg   [7:0]  comm_data                     = 0 ;

// serial_tx_handler Outputs
wire  uart_tx_stream                       ;
wire  vga_data_ready                       ;
wire  comp_data_ready                      ;
wire  adc_data_ready                       ;
wire  comm_data_ready                      ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end


serial_tx_handler  u_serial_tx_handler (
    .clk                     ( clk                    ),
    .vga_data_valid          ( vga_data_valid         ),
    .vga_data                ( vga_data         [7:0] ),
    .comp_data_valid         ( comp_data_valid        ),
    .comp_data               ( comp_data        [7:0] ),
    .adc_data_valid          ( adc_data_valid         ),
    .adc_data                ( adc_data         [7:0] ),
    .comm_data_valid         ( comm_data_valid        ),
    .comm_data               ( comm_data        [7:0] ),

    .uart_tx_stream          ( uart_tx_stream         ),
    .vga_data_ready          ( vga_data_ready         ),
    .comp_data_ready         ( comp_data_ready        ),
    .adc_data_ready          ( adc_data_ready         ),
    .comm_data_ready         ( comm_data_ready        )
);

initial
begin
$dumpfile("tb_serial_tx_handler.vcd");
$dumpvars(0, tb_serial_tx_handler);
    #1000
    vga_data_valid = 1;
    comm_data_valid = 1;
    vga_data = 8'b01101001;
    comm_data = 8'b01101100;
    #100
    vga_data_valid = 0;
    #12000
    comm_data_valid = 0;
    #100000
    $finish;
end

endmodule
`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2023 19:38:46
// Design Name: 
// Module Name: tb_adc_driver
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


module tb_adc_driver;

// adc_driver Parameters
parameter PERIOD                = 83333         ;
//parameter PERIOD2               = 4000000       ;
parameter PERIOD2               = 166666        ;
parameter DEFAULT_POWER         = 1'b0          ;
parameter DEFAULT_POWER_ASCII   = 8'h31         ;
parameter DEFAULT_TRIG          = 1'b0          ;
parameter DEFAULT_TRIG_ASCII    = 8'h30         ;
parameter DEFAULT_THOLD         = 8'd32        ;
parameter DEFAULT_THOLD_ASCII   = 24'h35        ;
parameter DEFAULT_MAXSMP        = 16'd46        ;
parameter DEFAULT_MAXSMP_ASCII  = 40'h3436      ;

// adc_driver Inputs
reg   clk                                  = 0 ;
reg   [9:0]  adc_in                        = 0 ;
reg   [2:0]  rx_dst                        = 0 ;
reg   [3:0]  rx_cmd                        = 0 ;
reg   [15:0]  rx_val                       = 0 ;
reg   rx_fin                               = 0 ;
//reg   tx_ready                             = 0 ;
wire tx_ready;

// adc_driver Outputs
wire  trigger_out                          ;
wire  tx_valid                             ;
wire  [7:0]  tx_data                       ;
wire  adc_en                               ;
wire  clk_adc;

`include "serial_defines.hv"

// serial_interface Inputs

// serial_interface Outputs
wire  uart_tx_stream;
wire  tx_busy;
wire  adc_data_ready;

serial_interface  u_serial_interface (
    .clk                     ( clk ),
    .uart_rx_stream          (     ),
    .vga_data                (     ),
    .vga_data_valid          (     ),
    .comp_data               (     ),
    .comp_data_valid         (     ),
    .adc_data                ( tx_data     ),
    .adc_data_valid          ( tx_valid    ),
    .comm_data               (     ),
    .comm_data_valid         (     ),

    .uart_tx_stream          ( uart_tx_stream    ),
    .tx_busy                 ( tx_busy           ),
    .rx_dst                  (             ),
    .rx_cmd                  (             ),
    .rx_val                  (             ),
    .rx_fin                  (             ),
    .rx_busy                 (            ),
    .vga_data_ready          (     ),
    .comp_data_ready         (    ),
    .adc_data_ready          ( tx_ready    ),
    .comm_data_ready         (    )
);

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

//reg [4:0] counter = 0;
//always @(posedge clk) begin
//    tx_ready <= #1 0;
//    if (counter == 9) begin
//        counter <= #1 0;
//        tx_ready <= #1 1;
//    end
//    if (counter == 10) begin
//        counter <= #1 0;
//    else
//        counter <= #1 counter + 1;
//end


always @(posedge clk) begin
    adc_in = adc_in + 3;
end


adc_driver #(
    .DEFAULT_POWER        ( DEFAULT_POWER        ),
    .DEFAULT_POWER_ASCII  ( DEFAULT_POWER_ASCII  ),
    .DEFAULT_TRIG         ( DEFAULT_TRIG         ),
    .DEFAULT_TRIG_ASCII   ( DEFAULT_TRIG_ASCII   ),
    .DEFAULT_THOLD        ( DEFAULT_THOLD        ),
    .DEFAULT_THOLD_ASCII  ( DEFAULT_THOLD_ASCII  ),
    .DEFAULT_MAXSMP       ( DEFAULT_MAXSMP       ),
    .DEFAULT_MAXSMP_ASCII ( DEFAULT_MAXSMP_ASCII ))
 u_adc_driver (
    .clk                          ( clk                                 ),
    .clk_adc                      ( clk_adc                             ),
    .adc_in                       ( adc_in                       [9:0]  ),
    .rx_dst                       ( rx_dst                       [2:0]  ),
    .rx_cmd                       ( rx_cmd                       [3:0]  ),
    .rx_val                       ( rx_val                       [15:0] ),
    .rx_fin                       ( rx_fin                              ),
    .tx_ready                     ( tx_ready                            ),
    .trigger_out                  ( trigger_out                         ),
    .tx_valid                     ( tx_valid                            ),
    .tx_data                      ( tx_data                      [7:0]  ),
    .adc_en                       ( adc_en                              )
);

initial
begin
    adc_in = 0;
    clk = 0;
    //tx_ready = 1;
    #(5000*PERIOD2)
    rx_dst = DESTINATION_ADC;
    rx_cmd = COMMAND_FORCE;
    rx_val = 1;
    rx_fin = 1;
    #PERIOD
    rx_fin = 0;
    #(1000000*PERIOD)
    $finish;
end

endmodule

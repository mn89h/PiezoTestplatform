`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2023 19:51:29
// Design Name: 
// Module Name: top
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


module top(
    input wire sysclk_pin,

    input wire uart_rx_pin,
    output wire uart_tx_pin,
    
    input wire btn0_pin,
    input wire btn1_pin,
    input wire extsw1_pin,
    input wire extsw2_pin,
    input wire extsw3_pin,
    input wire extsw4_pin,

    output wire led1_pin,
    output wire led2_pin,
    output wire led3_pin,
    output wire led4_pin,
    output wire extled1_pin,
    output wire extled2_pin,
    output wire extled3_pin,
    output wire extled4_pin,
    output wire extled5_pin,
    output wire extled6_pin,

    output wire piezodriverb_lo_pin,
    output wire piezodrivera_hi_pin,
    
    output wire vga_en_pin,
    output wire [3:0] vga_gain_pins,

    output wire adc_clk_pin,
    output wire adc_en_pin,
    input wire [9:0] adc_in_pins,

    output wire comp_en_pin,
    input wire comp_in_pin
);


// ----------------------------------------------PARAMETERS----------------------------------------------

// comm_protocol Parameters
parameter DEFAULT_DATA        = 4'b0101   ;     parameter DEFAULT_DATA_ASCII  = 16'h35    ;
parameter DEFAULT_CHP         = 12'd100   ;     parameter DEFAULT_CHP_ASCII   = 32'h313030;
parameter DEFAULT_STL         = 16'd500   ;     parameter DEFAULT_STL_ASCII   = 40'h353030;
parameter DEFAULT_0L          = 12'd100   ;     parameter DEFAULT_0L_ASCII    = 32'h313030;
parameter DEFAULT_1L          = 12'd200   ;     parameter DEFAULT_1L_ASCII    = 32'h323030;
parameter DEFAULT_BRL         = 16'd200   ;     parameter DEFAULT_BRL_ASCII   = 40'h323030;


// ------------------------------------------------WIRES-------------------------------------------------

wire sysclk;
wire clk_10;
wire clk_100;

// serial interface
wire [2:0] rx_dst;
wire [3:0] rx_cmd;
wire [15:0] rx_val;
wire rx_fin;
wire rx_busy;

wire tx_busy;

// vga_driver
wire vga_data_ready;
wire vga_data_valid;
wire [7:0]  vga_data;

// comparator_driver
wire comp_data_ready;

// adc_driver
wire adc_data_ready;

// comm_protocol
wire comm_data_ready;
wire comm_data_valid;
wire [7:0]  comm_data;
wire comm_fin;

// buttons_handler Outputs
wire btn0_down;
wire btn1_down;
wire extsw1_down;
wire extsw2_down;
wire extsw3_down;
wire extsw4_down;


// ----------------------------------------------ASSIGNMENTS---------------------------------------------

assign led1_pin = rx_busy;
assign led2_pin = tx_busy;
assign led3_pin = 0;
assign led4_pin = 0;
assign extled1_pin = comm_fin;
assign extled2_pin = 0;

assign vga_en_pin = 0;
assign comp_en_pin = 0;
assign adc_clk_pin = 0;
assign adc_en_pin = 1;


// -----------------------------------------MODULE INSTANTIATIONS----------------------------------------

buttons_handler u_buttons_handler (
    .clk                     ( sysclk        ),
    .btn0                    ( btn0_pin      ),
    .btn1                    ( btn1_pin      ),
    .extsw1                  ( extsw1_pin    ),
    .extsw2                  ( extsw2_pin    ),
    .extsw3                  ( extsw3_pin    ),
    .extsw4                  ( extsw4_pin    ),

    .btn0_down               ( btn0_down     ),
    .btn1_down               ( btn1_down     ),
    .extsw1_down             ( extsw1_down   ),
    .extsw2_down             ( extsw2_down   ),
    .extsw3_down             ( extsw3_down   ),
    .extsw4_down             ( extsw4_down   )
);

clk_wiz u_clk_wiz (
    .sysclk_in      ( sysclk_pin        ),
    .sysclk_out     ( sysclk            ),
    .clk_10         ( clk_10            ),
    .clk_100        ( clk_100           )
);

serial_interface  u_serial_interface (
    .clk                     ( sysclk            ),
    .uart_rx_stream          ( uart_rx_pin       ),
    
    .rx_dst                  ( rx_dst            ),
    .rx_cmd                  ( rx_cmd            ),
    .rx_val                  ( rx_val            ),
    .rx_fin                  ( rx_fin            ),
    .rx_busy                 ( rx_busy           ),
    
    .uart_tx_stream          ( uart_tx_pin       ),
    .tx_busy                 ( tx_busy           ),
    
    .vga_data                ( vga_data          ),
    .vga_data_valid          ( vga_data_valid    ),
    .vga_data_ready          ( vga_data_ready    ),
    
    .comp_data               ( comp_data         ),
    .comp_data_valid         ( comp_data_valid   ),
    .comp_data_ready         ( comp_data_ready   ),
    
    .adc_data                ( adc_data          ),
    .adc_data_valid          ( adc_data_valid    ),
    .adc_data_ready          ( adc_data_ready    ),
    
    .comm_data               ( comm_data         ),
    .comm_data_valid         ( comm_data_valid   ),
    .comm_data_ready         ( comm_data_ready   )
);


comm_protocol #(
    .DEFAULT_DATA           ( DEFAULT_DATA          ),
    .DEFAULT_DATA_ASCII     ( DEFAULT_DATA_ASCII    ),
    .DEFAULT_CHP            ( DEFAULT_CHP           ),
    .DEFAULT_CHP_ASCII      ( DEFAULT_CHP_ASCII     ),
    .DEFAULT_STL            ( DEFAULT_STL           ),
    .DEFAULT_STL_ASCII      ( DEFAULT_STL_ASCII     ),
    .DEFAULT_0L             ( DEFAULT_0L            ),
    .DEFAULT_0L_ASCII       ( DEFAULT_0L_ASCII      ),
    .DEFAULT_1L             ( DEFAULT_1L            ),
    .DEFAULT_1L_ASCII       ( DEFAULT_1L_ASCII      ),
    .DEFAULT_BRL            ( DEFAULT_BRL           ),
    .DEFAULT_BRL_ASCII      ( DEFAULT_BRL_ASCII     ))
 u_comm_protocol (
    .clk                    ( sysclk                ),
    .clk_100                ( clk_100               ),

    .btn_start              ( extsw1_down           ),

    .rx_dst                 ( rx_dst                ),
    .rx_cmd                 ( rx_cmd                ),
    .rx_val                 ( rx_val                ),
    .rx_fin                 ( rx_fin                ),

    .tx_ready               ( comm_data_ready       ),
    .tx_valid               ( comm_data_valid       ),
    .tx_data                ( comm_data             ),

    .comm_fin               ( comm_fin              ),

    .piezodriver_lo         ( piezodriverb_lo_pin   ),
    .piezodriver_hi         ( piezodrivera_hi_pin   )
);

vga_driver  u_vga_driver (
    .clk                     ( sysclk         ),

    .btn_gain_inc            ( extsw4_down    ),
    .btn_gain_dec            ( extsw3_down    ),

    .rx_dst                  ( rx_dst         ),
    .rx_cmd                  ( rx_cmd         ),
    .rx_val                  ( rx_val         ),
    .rx_fin                  ( rx_fin         ),

    .tx_ready                ( vga_data_ready ),
    .tx_valid                ( vga_data_valid ),
    .tx_data                 ( vga_data       ),

    .dac_value               ( vga_gain_pins  ),

    .led0                    ( extled3_pin    ),
    .led1                    ( extled4_pin    ),
    .led2                    ( extled5_pin    ),
    .led3                    ( extled6_pin    )
);
endmodule

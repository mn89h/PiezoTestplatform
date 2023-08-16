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
    input wire signed [9:0] adc_in_pins,

    output wire comp_en_pin,
    input wire comp_in_pin
);


// ----------------------------------------------PARAMETERS----------------------------------------------

// vga_driver Parameters
parameter VGA_DEFAULT_POWER     = 1'b0          ;   parameter VGA_DEFAULT_POWER_ASCII  = 8'h30         ;
parameter VGA_DEFAULT_GAIN      = 4'd4          ;   parameter VGA_DEFAULT_GAIN_ASCII   = 16'h34        ;


// comm_protocol Parameters
parameter COMM_DEFAULT_DATA      = 4'b0101       ;   parameter COMM_DEFAULT_DATA_ASCII  = 16'h35    ;
parameter COMM_DEFAULT_CHP       = 12'd100       ;   parameter COMM_DEFAULT_CHP_ASCII   = 32'h313030;
parameter COMM_DEFAULT_STL       = 16'd500       ;   parameter COMM_DEFAULT_STL_ASCII   = 40'h353030;
parameter COMM_DEFAULT_0L        = 12'd100       ;   parameter COMM_DEFAULT_0L_ASCII    = 32'h313030;
parameter COMM_DEFAULT_1L        = 12'd200       ;   parameter COMM_DEFAULT_1L_ASCII    = 32'h323030;
parameter COMM_DEFAULT_BRL       = 16'd200       ;   parameter COMM_DEFAULT_BRL_ASCII   = 40'h323030;
parameter COMM_DEFAULT_CLKDIV    = 9'd113        ;   parameter COMM_DEFAULT_CLKDIV_ASCII= 32'h313133;


// adc_driver Parameters
parameter ADC_DEFAULT_POWER     = 1'b1          ;   parameter ADC_DEFAULT_POWER_ASCII   = 8'h31         ;
parameter ADC_DEFAULT_TRIG      = 1'b0          ;   parameter ADC_DEFAULT_TRIG_ASCII    = 8'h30         ;
parameter ADC_DEFAULT_THOLD     = 8'd64         ;   parameter ADC_DEFAULT_THOLD_ASCII   = 24'h3634      ;
parameter ADC_DEFAULT_MAXSMP    = 16'd40000     ;   parameter ADC_DEFAULT_MAXSMP_ASCII  = 40'h3430303030;
parameter ADC_DEFAULT_WIDTH	  = 4'd5          ;   parameter ADC_DEFAULT_WIDTH_ASCII   = 16'h35        ;
parameter ADC_DEFAULT_FREQ      = 14'd5000      ;   parameter ADC_DEFAULT_FREQ_ASCII	 = 40'h35303030  ; // 250..10000 [kHz] in 250 [kHz] steps


// comp_driver Parameters
parameter COMP_DEFAULT_POWER     = 1'b1          ;   parameter COMP_DEFAULT_POWER_ASCII  = 8'h31         ;
parameter COMP_DEFAULT_TRIG      = 1'b0          ;   parameter COMP_DEFAULT_TRIG_ASCII    = 8'h30        ;
parameter COMP_DEFAULT_MAXSMP    = 16'd1000      ;   parameter COMP_DEFAULT_MAXSMP_ASCII = 40'h31303030  ;
parameter COMP_DEFAULT_WIDTH	   = 5'd20         ;   parameter COMP_DEFAULT_WIDTH_ASCII  = 16'h3230      ;
parameter COMP_DEFAULT_FREQ      = 14'd200       ;   parameter COMP_DEFAULT_FREQ_ASCII	  = 40'h323030    ; // 25, 50, 100, 200, 300, 400 [MHz]


// ------------------------------------------------WIRES-------------------------------------------------

wire sysclk;

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
wire comp_data_valid;
wire [7:0]  comp_data;

// adc_driver
wire adc_data_ready;
wire adc_data_valid;
wire [7:0]  adc_data;

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

wire  trigger_comp;

// ----------------------------------------------ASSIGNMENTS---------------------------------------------

assign led1_pin = 0;
assign led2_pin = 0;
assign led3_pin = 0;
assign led4_pin = 0;
assign extled1_pin = ~comm_fin;
assign extled2_pin = vga_en_pin;

assign sysclk = sysclk_pin;

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

serial_interface  u_serial_interface (
    .clk                     ( sysclk            ),
    
    //rx
    .uart_rx_stream          ( uart_rx_pin       ),
    
    .rx_dst                  ( rx_dst            ),
    .rx_cmd                  ( rx_cmd            ),
    .rx_val                  ( rx_val            ),
    .rx_fin                  ( rx_fin            ),
    .rx_busy                 ( rx_busy           ),
    
    //tx
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
    .DEFAULT_DATA           ( COMM_DEFAULT_DATA          ),
    .DEFAULT_DATA_ASCII     ( COMM_DEFAULT_DATA_ASCII    ),
    .DEFAULT_CHP            ( COMM_DEFAULT_CHP           ),
    .DEFAULT_CHP_ASCII      ( COMM_DEFAULT_CHP_ASCII     ),
    .DEFAULT_STL            ( COMM_DEFAULT_STL           ),
    .DEFAULT_STL_ASCII      ( COMM_DEFAULT_STL_ASCII     ),
    .DEFAULT_0L             ( COMM_DEFAULT_0L            ),
    .DEFAULT_0L_ASCII       ( COMM_DEFAULT_0L_ASCII      ),
    .DEFAULT_1L             ( COMM_DEFAULT_1L            ),
    .DEFAULT_1L_ASCII       ( COMM_DEFAULT_1L_ASCII      ),
    .DEFAULT_BRL            ( COMM_DEFAULT_BRL           ),
    .DEFAULT_BRL_ASCII      ( COMM_DEFAULT_BRL_ASCII     ),
    .DEFAULT_CLKDIV         ( COMM_DEFAULT_CLKDIV        ),
    .DEFAULT_CLKDIV_ASCII   ( COMM_DEFAULT_CLKDIV_ASCII  ))
 u_comm_protocol (
    .clk                    ( sysclk                ),

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

vga_driver #(
   .DEFAULT_POWER        ( VGA_DEFAULT_POWER           ),
   .DEFAULT_POWER_ASCII  ( VGA_DEFAULT_POWER_ASCII     ),
   .DEFAULT_GAIN         ( VGA_DEFAULT_GAIN            ),
   .DEFAULT_GAIN_ASCII   ( VGA_DEFAULT_GAIN_ASCII      ))
u_vga_driver (
   .clk                     ( sysclk         ),

   .power_signal            ( extsw2_down    ),
   .gain_inc_signal         ( extsw4_down    ),
   .gain_dec_signal         ( extsw3_down    ),

   .rx_dst                  ( rx_dst         ),
   .rx_cmd                  ( rx_cmd         ),
   .rx_val                  ( rx_val         ),
   .rx_fin                  ( rx_fin         ),

   .tx_ready                ( vga_data_ready ),
   .tx_valid                ( vga_data_valid ),
   .tx_data                 ( vga_data       ),

   .dac_value               ( vga_gain_pins  ),
   .vga_enable              ( vga_en_pin     ),

   .led0                    ( extled3_pin    ),
   .led1                    ( extled4_pin    ),
   .led2                    ( extled5_pin    ),
   .led3                    ( extled6_pin    )
);

adc_driver #(
   .DEFAULT_POWER        ( ADC_DEFAULT_POWER           ),
   .DEFAULT_POWER_ASCII  ( ADC_DEFAULT_POWER_ASCII     ),
   .DEFAULT_TRIG         ( ADC_DEFAULT_TRIG            ),
   .DEFAULT_TRIG_ASCII   ( ADC_DEFAULT_TRIG_ASCII      ),
   .DEFAULT_THOLD        ( ADC_DEFAULT_THOLD           ),
   .DEFAULT_THOLD_ASCII  ( ADC_DEFAULT_THOLD_ASCII     ),
   .DEFAULT_MAXSMP       ( ADC_DEFAULT_MAXSMP          ),
   .DEFAULT_MAXSMP_ASCII ( ADC_DEFAULT_MAXSMP_ASCII    ),
   .DEFAULT_WIDTH        ( ADC_DEFAULT_WIDTH           ),
   .DEFAULT_WIDTH_ASCII  ( ADC_DEFAULT_WIDTH_ASCII     ),
   .DEFAULT_FREQ         ( ADC_DEFAULT_FREQ            ),
   .DEFAULT_FREQ_ASCII   ( ADC_DEFAULT_FREQ_ASCII      ))
u_adc_driver (
   .clk                          ( sysclk                        ),
   .clk_adc                      ( adc_clk_pin                   ),
   .adc_in                       ( adc_in_pins                   ),
   .rx_dst                       ( rx_dst                        ),
   .rx_cmd                       ( rx_cmd                        ),
   .rx_val                       ( rx_val                        ),
   .rx_fin                       ( rx_fin                        ),
   .tx_ready                     ( adc_data_ready                ),
   .tx_valid                     ( adc_data_valid                ),
   .tx_data                      ( adc_data                      ),
   .adc_en                       ( adc_en_pin                    ),
   .trigger_out                  ( trigger_comp                  )
);

comparator_driver #(
   .DEFAULT_POWER        ( COMP_DEFAULT_POWER           ),
   .DEFAULT_POWER_ASCII  ( COMP_DEFAULT_POWER_ASCII     ),
   .DEFAULT_TRIG         ( COMP_DEFAULT_TRIG            ),
   .DEFAULT_TRIG_ASCII   ( COMP_DEFAULT_TRIG_ASCII      ),
   .DEFAULT_MAXSMP       ( COMP_DEFAULT_MAXSMP          ),
   .DEFAULT_MAXSMP_ASCII ( COMP_DEFAULT_MAXSMP_ASCII    ),
   .DEFAULT_WIDTH        ( COMP_DEFAULT_WIDTH           ),
   .DEFAULT_WIDTH_ASCII  ( COMP_DEFAULT_WIDTH_ASCII     ))
u_comp_driver (
   .clk                          ( sysclk                        ),
   .comp_in                      ( comp_in_pin                   ),
   .rx_dst                       ( rx_dst                        ),
   .rx_cmd                       ( rx_cmd                        ),
   .rx_val                       ( rx_val                        ),
   .rx_fin                       ( rx_fin                        ),
   .tx_ready                     ( comp_data_ready               ),
   .tx_valid                     ( comp_data_valid               ),
   .tx_data                      ( comp_data                     ),
   .comp_en                      ( comp_en_pin                   ),
   .trigger_in                   ( trigger_comp                  )
);


endmodule

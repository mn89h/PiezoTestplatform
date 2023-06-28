`timescale  10ps / 10ps

`ifdef iverilog
    `include "../sources_1/top.v"
`endif

module tb_top;

// top Parameters
parameter PERIOD                = 8333          ;
parameter DEFAULT_DATA          = 4'b0101       ;
parameter DEFAULT_DATA_ASCII    = 16'h35        ;
parameter DEFAULT_CHP           = 12'd100       ;
parameter DEFAULT_CHP_ASCII     = 32'h313030    ;
parameter DEFAULT_STL           = 16'd500       ;
parameter DEFAULT_STL_ASCII     = 40'h353030    ;
parameter DEFAULT_0L            = 12'd100       ;
parameter DEFAULT_0L_ASCII      = 32'h313030    ;
parameter DEFAULT_1L            = 12'd200       ;
parameter DEFAULT_1L_ASCII      = 32'h323030    ;
parameter DEFAULT_BRL           = 16'd200       ;
parameter DEFAULT_BRL_ASCII     = 40'h323030    ;
parameter DEFAULT_POWER         = 1'b0          ;
parameter DEFAULT_POWER_ASCII   = 8'h30         ;
parameter DEFAULT_TRIG          = 1'b0          ;
parameter DEFAULT_TRIG_ASCII    = 8'h30         ;
parameter DEFAULT_THOLD         = 8'd64          ;
parameter DEFAULT_THOLD_ASCII   = 24'h30        ;
parameter DEFAULT_MAXSMP        = 16'd40000     ;
parameter DEFAULT_MAXSMP_ASCII  = 40'h3430303030;

// top Inputs
reg   sysclk_pin                           = 0 ;
reg   uart_rx                          = 1 ;
reg   btn0_pin                             = 0 ;
reg   btn1_pin                             = 0 ;
reg   extsw1_pin                           = 0 ;
reg   extsw2_pin                           = 0 ;
reg   extsw3_pin                           = 0 ;
reg   extsw4_pin                           = 0 ;
reg   [9:0]  adc_in_pins                   = 0 ;
reg   comp_in_pin                          = 0 ;

// top Outputs
wire  uart_tx_pin                          ;
wire  led1_pin                             ;
wire  led2_pin                             ;
wire  led3_pin                             ;
wire  led4_pin                             ;
wire  extled1_pin                          ;
wire  extled2_pin                          ;
wire  extled3_pin                          ;
wire  extled4_pin                          ;
wire  extled5_pin                          ;
wire  extled6_pin                          ;
wire  piezodriverb_lo_pin                  ;
wire  piezodrivera_hi_pin                  ;
wire  vga_en_pin                           ;
wire  [3:0]  vga_gain_pins                 ;
wire  adc_clk_pin                          ;
wire  adc_en_pin                           ;
wire  comp_en_pin                          ;


initial
begin
    forever #(PERIOD/2)  sysclk_pin=~sysclk_pin;
end


top #(
    .DEFAULT_DATA         ( DEFAULT_DATA         ),
    .DEFAULT_DATA_ASCII   ( DEFAULT_DATA_ASCII   ),
    .DEFAULT_CHP          ( DEFAULT_CHP          ),
    .DEFAULT_CHP_ASCII    ( DEFAULT_CHP_ASCII    ),
    .DEFAULT_STL          ( DEFAULT_STL          ),
    .DEFAULT_STL_ASCII    ( DEFAULT_STL_ASCII    ),
    .DEFAULT_0L           ( DEFAULT_0L           ),
    .DEFAULT_0L_ASCII     ( DEFAULT_0L_ASCII     ),
    .DEFAULT_1L           ( DEFAULT_1L           ),
    .DEFAULT_1L_ASCII     ( DEFAULT_1L_ASCII     ),
    .DEFAULT_BRL          ( DEFAULT_BRL          ),
    .DEFAULT_BRL_ASCII    ( DEFAULT_BRL_ASCII    ),
    .DEFAULT_POWER        ( DEFAULT_POWER        ),
    .DEFAULT_POWER_ASCII  ( DEFAULT_POWER_ASCII  ),
    .DEFAULT_TRIG         ( DEFAULT_TRIG         ),
    .DEFAULT_TRIG_ASCII   ( DEFAULT_TRIG_ASCII   ),
    .DEFAULT_THOLD        ( DEFAULT_THOLD        ),
    .DEFAULT_THOLD_ASCII  ( DEFAULT_THOLD_ASCII  ),
    .DEFAULT_MAXSMP       ( DEFAULT_MAXSMP       ),
    .DEFAULT_MAXSMP_ASCII ( DEFAULT_MAXSMP_ASCII ))
 u_top (
    .sysclk_pin              ( sysclk_pin                 ),
    .uart_rx_pin             ( uart_rx                ),
    .btn0_pin                ( btn0_pin                   ),
    .btn1_pin                ( btn1_pin                   ),
    .extsw1_pin              ( extsw1_pin                 ),
    .extsw2_pin              ( extsw2_pin                 ),
    .extsw3_pin              ( extsw3_pin                 ),
    .extsw4_pin              ( extsw4_pin                 ),
    .adc_in_pins             ( adc_in_pins          [9:0] ),
    .comp_in_pin             ( comp_in_pin                ),

    .uart_tx_pin             ( uart_tx_pin                ),
    .led1_pin                ( led1_pin                   ),
    .led2_pin                ( led2_pin                   ),
    .led3_pin                ( led3_pin                   ),
    .led4_pin                ( led4_pin                   ),
    .extled1_pin             ( extled1_pin                ),
    .extled2_pin             ( extled2_pin                ),
    .extled3_pin             ( extled3_pin                ),
    .extled4_pin             ( extled4_pin                ),
    .extled5_pin             ( extled5_pin                ),
    .extled6_pin             ( extled6_pin                ),
    .piezodriverb_lo_pin     ( piezodriverb_lo_pin        ),
    .piezodrivera_hi_pin     ( piezodrivera_hi_pin        ),
    .vga_en_pin              ( vga_en_pin                 ),
    .vga_gain_pins           ( vga_gain_pins        [3:0] ),
    .adc_clk_pin             ( adc_clk_pin                ),
    .adc_en_pin              ( adc_en_pin                 ),
    .comp_en_pin             ( comp_en_pin                )
);

`include "uart_ascii_helper.v"

initial
begin
    sysclk_pin = 0;
    uart_rx = 1;
    #(5000*PERIOD);
    // ADC
    send_ascii_C();
    send_ascii_O();
    send_ascii_M();
    send_ascii_P();
    send_ascii_colon();
    send_ascii_S();
    send_ascii_I();
    send_ascii_M();
    send_ascii_space();
    send_ascii_1();
    send_ascii_lf();
    #(1000*PERIOD);
    send_ascii_C();
    send_ascii_O();
    send_ascii_M();
    send_ascii_P();
    send_ascii_colon();
    send_ascii_F();
    send_ascii_O();
    send_ascii_R();
    send_ascii_C();
    send_ascii_E();
    send_ascii_space();
    send_ascii_1();
    send_ascii_lf();
    
    $finish;
end

endmodule
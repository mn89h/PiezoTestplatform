`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2023 19:51:29
// Design Name: 
// Module Name: serial_interface
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
    `include "serial_rx_handler.v"
    `include "serial_tx_handler.v"
`endif

module serial_interface(
    // clk & uart interface (connect to uart ic)
    input wire clk,
    input wire uart_rx_stream,
    output wire uart_tx_stream,
    output wire tx_busy,

    // modules rx interface (listen to dest and valid in order to check if data is available)
    output wire [2:0] rx_dst,
    output wire [3:0] rx_cmd,
    output wire [15:0] rx_val,
    output wire rx_fin,
    output wire rx_busy,

    // modules tx interface (set data and valid until ready is returned)
    input wire [7:0] vga_data,
    input wire vga_data_valid,
    output wire vga_data_ready,

    input wire [7:0] comp_data,
    input wire comp_data_valid,
    output wire comp_data_ready,
    
    input wire [7:0] adc_data,
    input wire adc_data_valid,
    output wire adc_data_ready,
    
    input wire [7:0] comm_data,
    input wire comm_data_valid,
    output wire comm_data_ready
    );

    // instantiation of serial_rx_handler (rx demuxer)
    serial_rx_handler m_serial_rx_handler (
        .clk                    ( clk               ),
        .uart_rx_stream         ( uart_rx_stream    ),
        
        .rx_dst                 ( rx_dst            ),
        .rx_cmd                 ( rx_cmd            ),
        .rx_val                 ( rx_val            ),
        .rx_fin                 ( rx_fin            ),
        .rx_busy                ( rx_busy           )
    );

    // instantiation of serial_tx_handler (tx muxer)
    serial_tx_handler m_serial_tx_handler (
        .clk                    ( clk               ),
        .uart_tx_stream         ( uart_tx_stream    ),
        .tx_busy                ( tx_busy           ),
        
        .vga_data               ( vga_data          ),
        .vga_data_valid         ( vga_data_valid    ),
        .vga_data_ready         ( vga_data_ready    ),
        
        .comp_data              ( comp_data         ),
        .comp_data_valid        ( comp_data_valid   ),
        .comp_data_ready        ( comp_data_ready   ),
        
        .adc_data               ( adc_data          ),
        .adc_data_valid         ( adc_data_valid    ),
        .adc_data_ready         ( adc_data_ready    ),
        
        .comm_data              ( comm_data         ),
        .comm_data_valid        ( comm_data_valid   ),
        .comm_data_ready        ( comm_data_ready   )
    );
endmodule

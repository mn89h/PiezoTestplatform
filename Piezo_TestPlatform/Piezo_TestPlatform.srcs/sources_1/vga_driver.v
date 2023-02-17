`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2023 16:42:06
// Design Name: 
// Module Name: vga_driver
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


module vga_driver(
    input wire clk,
    input wire btn_gain_inc,
    input wire btn_gain_dec,

    input wire [2:0] rx_dst,
    input wire [3:0] rx_cmd,
    input wire [4:0] rx_val,
    input wire rx_fin,

    input wire tx_ready,
    output reg tx_valid,
    output reg [7:0] tx_data,

    output reg [3:0] dac_value = 4,
    output wire led0,
    output wire led1,
    output wire led2,
    output wire led3
    );

    `include "serial_defines.hv"

    localparam TX_IDLE = 3'b001;
    localparam TX_OFFR = 3'b010;
    localparam TX_WAIT = 3'b100;
    localparam SZ_BUF  = 80;

    reg [2:0]        state_tx     = TX_IDLE;
    reg [SZ_BUF-1:0] write_buffer = 0;
    reg              send         = 0;


    localparam STRING_RET_GAIN  = 48'h4741494E3A20;
    reg [47:0] ascii_text = 0;
    reg [15:0] ascii_value = 0;
    reg [7:0] ascii_lf = 0;
    
    
    always@(posedge clk) begin
    
        // rx handler
        if (btn_gain_inc == 1) begin 
            dac_value <= dac_value + 1;
        end
        else if (btn_gain_dec == 1) begin
            dac_value <= dac_value - 1;
        end
        else if (rx_fin && rx_dst == DESTINATION_VGA) begin
            case (rx_cmd)
                COMMAND_STATUS: begin
                    if (state_tx == TX_IDLE) begin
                        ascii_text = STRING_RET_GAIN;           // "GAIN: "
                        ascii_value = bin2ascii10(dac_value);   // 'value'
                        ascii_lf = 8'h0A;                       // "\n"

                        write_buffer <= {ascii_text, ascii_value, ascii_lf, {SZ_BUF-48-16-8{1'b0}}};
                        send <= 1;
                    end
                end
                COMMAND_GAIN: begin
                    dac_value <= rx_val;
                end
            endcase
        end
        else begin
            send <= 0;
        end
        
        // tx handler
        case (state_tx)
            TX_IDLE: if (send) state_tx <= TX_OFFR;
            TX_OFFR: begin
                if (write_buffer[SZ_BUF-1:SZ_BUF-8] != 8'b0) begin  // if write_buffer not empty,
                    tx_valid <= 1;                                  // offer tx_data
                    tx_data <= write_buffer[SZ_BUF-1:SZ_BUF-8];
                    state_tx <= TX_WAIT;                            // change to wait state
                end
                else begin
                    state_tx <= TX_IDLE;
                    tx_valid <= 0;
                end
            end
            TX_WAIT: begin
                if (tx_ready) begin                                 // if tx accepted the byte
                    write_buffer <= write_buffer << 8;              // left-shift write buffer to select next byte
                    state_tx <= TX_OFFR;                            // and change to offer state
                end
            end
        endcase
    end

    //DAC. Output Voltage = DACValue/15 [V]
    assign led0 = dac_value[0];
    assign led1 = dac_value[1];
    assign led2 = dac_value[2];
    assign led3 = dac_value[3];

endmodule

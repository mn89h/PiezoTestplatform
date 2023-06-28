`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2023 00:02:52
// Design Name: 
// Module Name: serial_tx_handler
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
    `include "imports/uart_tx.v"
`endif

module serial_tx_handler(
    input wire clk,
    output wire uart_tx_stream,
    output wire tx_busy,

    input wire vga_data_valid,
    input wire [7:0] vga_data,
    output wire vga_data_ready,

    input wire comp_data_valid,
    input wire [7:0] comp_data,
    output wire comp_data_ready,

    input wire adc_data_valid,
    input wire [7:0] adc_data,
    output wire adc_data_ready,

    input wire comm_data_valid,
    input wire [7:0] comm_data,
    output wire comm_data_ready
    );

    `include "serial_defines.hv"
    
    // timeout after which an inactive sender is kicked and another one may send, set to 100 cycles
    localparam TIMEOUT_CYCLES_INACTIVE = 100;
    
    // additional timeout if active transmission takes too long possible? e.g. 65535 cycles (~5ms @ 12MHz)

    localparam STATE_IDLE   = 5'b00001;
    localparam STATE_VGA    = 5'b00010;
    localparam STATE_COMP   = 5'b00100;
    localparam STATE_ADC    = 5'b01000;
    localparam STATE_COMM   = 5'b10000;

    reg [4:0] state = STATE_IDLE;
    
    wire valid;
    wire [7:0] data;
    wire done; //unused
    wire active;

    //FTDI with 3 MHz? -> at 115200 Baud ~25 cycles -> times 4 for 12 MHz
    uart_tx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) m_uart_tx (
        .i_Clock(clk),
        .i_Tx_DV(valid),
        .i_Tx_Byte(data),
        .o_Tx_Active(active),
        .o_Tx_Serial(uart_tx_stream),
        .o_Tx_Done(done)
    );

    reg [15:0] counter = 0;

    // timeout counter
    always @(posedge clk) begin
        if (!active && (state != STATE_IDLE)) begin
            if (counter == TIMEOUT_CYCLES_INACTIVE)
                counter <= 0;
            else
                counter <= counter + 1;
        end
        else begin
            counter <= 0;
        end
    end

    // priority encoder depending on passed data vailidity with timeout
    always @(posedge clk) begin
        case (state)
            STATE_IDLE: begin
                if (vga_data_valid)         state <= STATE_VGA;
                else if (comp_data_valid)   state <= STATE_COMP;
                else if (adc_data_valid)    state <= STATE_ADC;
                else if (comm_data_valid)   state <= STATE_COMM;
                else                        state <= STATE_IDLE;
            end
            default: begin
                if (counter == TIMEOUT_CYCLES_INACTIVE) begin
                    state <= STATE_IDLE;
                end
            end
        endcase
    end

    assign tx_busy = (state != STATE_IDLE) ? 1 : 0;

    // forward passed data to uart_tx according to current state
    assign data = (state == STATE_VGA)  ? vga_data  :
                  (state == STATE_COMP) ? comp_data :
                  (state == STATE_ADC)  ? adc_data  :
                  (state == STATE_COMM) ? comm_data :
                                          8'b0      ;

    // forward passed valid to uart_tc according to current state 
    assign valid = (state == STATE_VGA  && vga_data_valid)  ||
                   (state == STATE_COMP && comp_data_valid) ||
                   (state == STATE_ADC  && adc_data_valid)  ||
                   (state == STATE_COMM && comm_data_valid)  ;

    // set ready outputs if currently in respective state and uart_tx is not active (yet) 
    assign vga_data_ready   = (state == STATE_VGA)  && !active;
    assign comp_data_ready  = (state == STATE_COMP) && !active;
    assign adc_data_ready   = (state == STATE_ADC)  && !active;
    assign comm_data_ready  = (state == STATE_COMM) && !active;

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2023 00:02:52
// Design Name: 
// Module Name: serial_rx_handler
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
    `include "imports/uart_rx.v"
`endif

module serial_rx_handler(
    input wire clk,
    input wire uart_rx_stream,
    output reg [2:0] rx_dst,
    output reg [3:0] rx_cmd,
    output reg [15:0] rx_val,
    output reg rx_fin,
    output reg rx_busy
    );
    
    
    `include "serial_defines.hv"
    localparam STATE_DST    = 4'b0001;    // select destination state
    localparam STATE_CMD    = 4'b0010;    // select command state
    localparam STATE_VAL    = 4'b0100;    // calculate value state
    localparam STATE_CLR    = 4'b1000;    // clear registers state

    wire valid;
    wire [7:0] data;

    //FTDI with 3 MHz? -> at 115200 Baud ~25 cycles -> times 4 for 12 MHz
    uart_rx #(
        .CLKS_PER_BIT(10) //1.2 MBaud
    ) m_uart_rx (
        .i_Clock(clk),
        .i_Rx_Serial(uart_rx_stream),
        .o_Rx_DV(valid),
        .o_Rx_Byte(data)
    );

    localparam SZ_BUF = 48;
    reg [SZ_BUF-1:0] dst_buf = 0;       // destination string buffer
    reg [SZ_BUF-1:0] cmd_buf = 0;       // command string buffer
    reg [SZ_BUF-1:0] val_buf = 0;       // value string buffer
    reg [SZ_BUF-1:0] dst_buf_next = 0;       // destination string buffer
    reg [SZ_BUF-1:0] cmd_buf_next = 0;       // command string buffer
    reg [SZ_BUF-1:0] val_buf_next = 0;       // value string buffer
    reg [3:0] state = STATE_DST;        // state reg
    reg [3:0] nextstate = STATE_DST;

    always @(posedge clk) begin
        state <= #1 nextstate;
    end

    always @(state, valid, data, dst_buf, cmd_buf, val_buf) begin
        nextstate = state;
        dst_buf_next = dst_buf;
        cmd_buf_next = cmd_buf;
        val_buf_next = val_buf;
        case (state)
            STATE_DST: begin
                if (valid) begin
                    if (data == STRING_DELIM_DST) begin
                        nextstate = STATE_CMD;
                    end
                    else if (data == STRING_DELIM_FIN) begin
                        nextstate = STATE_CLR;
                    end
                    else begin
                        dst_buf_next = (dst_buf << 8);
                        dst_buf_next[7:0] = data;
                    end
                end
            end
            STATE_CMD: begin
                if (valid) begin
                    if (data == STRING_DELIM_CMD) begin
                        nextstate = STATE_VAL;
                    end
                    else if (data == STRING_DELIM_FIN) begin
                        nextstate = STATE_CLR;
                    end
                    else begin
                        cmd_buf_next = (cmd_buf << 8);
                        cmd_buf_next[7:0] = data;
                    end
                end
            end
            // forward data to destination by not changing the dst_buf
            STATE_VAL: begin
                if (valid) begin
                    if (data == STRING_DELIM_FIN) begin
                        nextstate = STATE_CLR;
                    end
                    else begin
                        val_buf_next = (val_buf << 8);
                        val_buf_next[7:0] = data;
                    end
                end
            end
            STATE_CLR: begin
                nextstate = STATE_DST;
                dst_buf_next = 0;
                cmd_buf_next = 0;
                val_buf_next = 0;
            end
        endcase
    end

    wire [2:0] rx_dst_wire;
    assign rx_dst_wire = (dst_buf == STRING_DST_VGA     ) ? DESTINATION_VGA     :
                         (dst_buf == STRING_DST_COMP    ) ? DESTINATION_COMP    :
                         (dst_buf == STRING_DST_ADC     ) ? DESTINATION_ADC     :
                         (dst_buf == STRING_DST_COMM    ) ? DESTINATION_COMM    :
                         (dst_buf == STRING_DST_LED     ) ? DESTINATION_LED     :
                                                        DESTINATION_NONE    ;

    wire [3:0] rx_cmd_wire;
    assign rx_cmd_wire = (cmd_buf == STRING_CMD_STATUS  ) ? COMMAND_STATUS  :
                         (cmd_buf == STRING_CMD_POWER   ) ? COMMAND_POWER   :
                         (cmd_buf == STRING_CMD_GAIN    ) ? COMMAND_GAIN    :
                         (cmd_buf == STRING_CMD_SETDTA  ) ? COMMAND_SETDTA  :
                         (cmd_buf == STRING_CMD_SETCHP  ) ? COMMAND_SETCHP  :
                         (cmd_buf == STRING_CMD_SETSTL  ) ? COMMAND_SETSTL  :
                         (cmd_buf == STRING_CMD_SET0L   ) ? COMMAND_SET0L   :
                         (cmd_buf == STRING_CMD_SET1L   ) ? COMMAND_SET1L   :
                         (cmd_buf == STRING_CMD_SETBRL  ) ? COMMAND_SETBRL  :
                         (cmd_buf == STRING_CMD_START   ) ? COMMAND_START   :
                         (cmd_buf == STRING_CMD_RESET   ) ? COMMAND_RESET   :
                         (cmd_buf == STRING_CMD_TRIG    ) ? COMMAND_TRIG    :
                         (cmd_buf == STRING_CMD_THOLD   ) ? COMMAND_THOLD   :
                         (cmd_buf == STRING_CMD_MAXSMP  ) ? COMMAND_MAXSMP  :
                         (cmd_buf == STRING_CMD_WIDTH   ) ? COMMAND_WIDTH   :
                         (cmd_buf == STRING_CMD_FREQ    ) ? COMMAND_FREQ    :
                         (cmd_buf == STRING_CMD_SIM     ) ? COMMAND_SIM     :
                         (cmd_buf == STRING_CMD_FORCE   ) ? COMMAND_FORCE   :
                                                            COMMAND_NONE    ;

    wire [15:0] rx_val_wire;
    assign rx_val_wire = val_buf[35:32] * 16'd10000 + val_buf[27:24] * 16'd1000 + val_buf[19:16] * 16'd100 + val_buf[11:8] * 16'd10 + val_buf_next[3:0];

    wire rx_fin_wire;
    assign rx_fin_wire = (state == STATE_VAL && nextstate == STATE_CLR);

    wire rx_busy_wire;
    assign rx_busy_wire = (dst_buf[7:0] != 0) ? 1 : 0;

    // register outputs
    always @(posedge clk) begin
        rx_dst <= #1 rx_dst_wire;
        rx_cmd <= #1 rx_cmd_wire;
        rx_val <= #1 rx_val_wire;
        rx_fin <= #1 rx_fin_wire;
        rx_busy <= #1 rx_busy_wire;
    end
    
    // feedback registers
    always @(posedge clk) begin
        dst_buf <= #1 dst_buf_next;
        cmd_buf <= #1 cmd_buf_next;
        val_buf <= #1 val_buf_next;
    end

endmodule

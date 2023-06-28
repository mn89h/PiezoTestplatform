`timescale  1ns / 1ps

`ifdef iverilog
    `include "../sources_1/fifo_aggregate.v"
`endif

module tb_fifo_aggregate;

// fifo_aggregate Parameters
parameter PERIOD              = 10;
parameter MAX_INPUT_WIDTH     = 10;
parameter OUTPUT_WIDTH_BYTES  = 6 ;

// fifo_aggregate Inputs
reg   clk                                  = 0 ;
reg   rst                                  = 0 ;
reg   [3:0]  input_width                   = 10 ;
reg   wr_en                                = 0 ;
reg   [MAX_INPUT_WIDTH-1:0]  data_in       = 0 ;

// fifo_aggregate Outputs
wire  [OUTPUT_WIDTH_BYTES*8-1:0]  data_out ;
wire  full                                 ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end


fifo_aggregate #(
    .MAX_INPUT_WIDTH    ( MAX_INPUT_WIDTH    ),
    .OUTPUT_WIDTH_BYTES ( OUTPUT_WIDTH_BYTES ))
 u_fifo_aggregate (
    .clk                     ( clk                                               ),
    .rst                     ( rst                                               ),
    .input_width             ( input_width            [3:0]                      ),
    .wr_en                   ( wr_en                                             ),
    .data_in                 ( data_in                [MAX_INPUT_WIDTH-1:0]      ),
    .data_out                ( data_out               [OUTPUT_WIDTH_BYTES*8-1:0] ),
    .full                    ( full                                              )
);

initial
begin
$dumpfile("tb_fifo_aggregate.vcd");
$dumpvars(0, tb_fifo_aggregate);
    clk = 1;
    input_width = 10;
    wr_en = 0;
    #(2*PERIOD)
    wr_en = 1;
    data_in = 'd200;
    #PERIOD
    wr_en = 1;
    data_in = 'd201;
    #PERIOD
    wr_en = 1;
    data_in = 'd202;
    #PERIOD
    wr_en = 1;
    data_in = 'd203;
    #PERIOD
    wr_en = 1;
    data_in = 'd204;
    #PERIOD
    wr_en = 1;
    data_in = 'd205;
    #PERIOD
    wr_en = 1;
    data_in = 'd206;
    #PERIOD
    wr_en = 1;
    data_in = 'd207;
    #PERIOD
    wr_en = 1;
    data_in = 'd208;
    #PERIOD
    wr_en = 1;
    data_in = 'd209;
    #PERIOD
    wr_en = 1;
    data_in = 'd210;
    #PERIOD
    wr_en = 1;
    data_in = 'd211;
    #PERIOD
    wr_en = 1;
    data_in = 'd212;
    #PERIOD
    wr_en = 1;
    data_in = 'd213;
    #PERIOD
    wr_en = 1;
    data_in = 'd214;
    #PERIOD
    wr_en = 1;
    data_in = 'd215;
    #PERIOD
    wr_en = 1;
    data_in = 'd216;
    #PERIOD
    wr_en = 1;
    data_in = 'd217;
    #PERIOD
    wr_en = 1;
    data_in = 'd218;
    #PERIOD
    wr_en = 1;
    data_in = 'd219;
    #PERIOD
    wr_en = 1;
    // #PERIOD
    // rd_en = 0;
    // #PERIOD
    // rd_en=1;
    // #PERIOD
    // rd_en=0;
    #(60*PERIOD)
    $finish;
end

endmodule
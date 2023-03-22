// FIFO with X Bytes wide input and 1 Byte wide output
// FWFT (First-Word-Fall-Through)

module fifo_aggregate #(
    parameter MAX_INPUT_WIDTH       = 12, 
    parameter OUTPUT_WIDTH_BYTES    = 6
) (
    input wire                              clk,
    input wire                              rst,
    input wire [3:0]                        input_width, // max 15 bit input width
    input wire                              wr_en,
    input wire  [MAX_INPUT_WIDTH-1:0]       data_in,
    output wire [OUTPUT_WIDTH_BYTES*8-1:0]  data_out,
    output reg                              full = 1'b0
);
  
    localparam OUTPUT_WIDTH = 8 * OUTPUT_WIDTH_BYTES;
    localparam MAX_STORE_BITS = OUTPUT_WIDTH + MAX_INPUT_WIDTH;   // fifo depth in bytes
    localparam STORE_MSB = OUTPUT_WIDTH - 1;
    localparam STORE_LSB = 0;
    localparam OVFLW_MSB = MAX_STORE_BITS - 1;
    localparam OVFLW_LSB = OUTPUT_WIDTH;
    localparam COUNTER_MSB = $clog2(MAX_STORE_BITS) - 1;

    reg [OVFLW_MSB:0] current_memory;
    reg [OVFLW_MSB:0] memory = {OUTPUT_WIDTH{1'b0}};
    reg [3:0] overflow = 0;
    reg [3:0] current_shift_amount = 0;
    reg [3:0] current_overflow = 0;
    reg [COUNTER_MSB:0] counter = 0;
    
    integer ii;

    assign data_out = memory[STORE_MSB:STORE_LSB]; // fwft fifo
            // if (overflow > 0)
            //     memory[STORE_MSB-overflow+:STORE_MSB] <= memory[STORE_LSB-overflow:0];
            // memory[STORE_MSB-overflow:STORE_MSB-overflow-input_width+1] <= data_in;
            // memory[STORE_MSB-overflow-input_width:0] <= memory[STORE_MSB-overflow:STORE_LSB];
    
    always @(posedge clk) begin
        current_memory = {OUTPUT_WIDTH{1'b0}};
        current_overflow = 0;
        current_shift_amount = 0;
        if (rst) begin
            memory      <= 0;
            overflow    <= 0;
            counter     <= 0;
            full        <= 0;
        end
        else if (wr_en) begin
            if (counter + input_width >= OUTPUT_WIDTH) begin
                current_shift_amount = OUTPUT_WIDTH - counter + overflow;
                current_overflow = input_width + overflow - current_shift_amount;
                full <= 1'b1;
                counter <= current_overflow;
            end
            else begin
                current_shift_amount = input_width + overflow;
                current_overflow = 0;
                full <= 1'b0;
                counter <= counter + input_width;
            end
            current_memory = memory >> (current_shift_amount); //shift by 2 or 12 for example
            // for (ii = 0; ii < MAX_INPUT_WIDTH; ii = ii + 1) begin
            //     if (overflow > ii) memory[STORE_MSB-current_shift_amount+1+ii] <= memory[OVFLW_LSB+ii];
            // end
            for (ii = 0; ii < MAX_INPUT_WIDTH; ii = ii + 1) begin
                if (input_width > ii) current_memory[STORE_MSB-input_width+1+ii+current_overflow] = data_in[ii];
                //if (input_width > ii) current_memory[STORE_MSB-input_width] = 1;
            end
            memory <= current_memory;
            overflow <= current_overflow;
        end
    end
endmodule
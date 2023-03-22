// FIFO with X Bytes wide input and 1 Byte wide output
// FWFT (First-Word-Fall-Through)

module fifo_x2byte #(
    parameter INPUT_WIDTH_BYTES   = 6, // = 48 Bit
    parameter FIFO_DEPTH_INPUT    = 2 //  = 2 * 6 Bytes
) (
    input wire                             clk,
    input wire                             rst,
    input wire                             rd_en,
    input wire                             wr_en,
    input wire [(INPUT_WIDTH_BYTES*8)-1:0] data_in,
    output wire [7:0]                      data_out,
    output reg                             full = 1'b0,
    output reg                             empty = 1'b1
);
  
    localparam MAX_NUM_BYTES = FIFO_DEPTH_INPUT * INPUT_WIDTH_BYTES;    // fifo depth in bytes
    localparam ADDR_MSB = $clog2(MAX_NUM_BYTES) - 1;                    // log2(max_num_bytes) addresses
    localparam PTR_MSB  = ADDR_MSB + 1;                                 // additional bit for full/empty signalling
  
    reg         [7:0] memory [0:MAX_NUM_BYTES-1];
    reg   [PTR_MSB:0] rd_ptr = 0;
    reg   [PTR_MSB:0] wr_ptr = 0;
    wire [ADDR_MSB:0] wr_addr;
    wire [ADDR_MSB:0] rd_addr;
    
    assign wr_addr = wr_ptr[ADDR_MSB:0];
    assign rd_addr = rd_ptr[ADDR_MSB:0]; 

    assign data_out = memory[rd_addr]; // fwft fifo
    
    integer ii = 0;
    // local variables
    reg [PTR_MSB:0] next_rd_ptr;
    reg [PTR_MSB:0] next_wr_ptr;

    // simulation directives
    integer idx;
    initial begin
        for (idx = 0; idx < MAX_NUM_BYTES; idx = idx + 1) $dumpvars(0, memory[idx]);
    end
    
    always @(posedge clk) begin
        if (rst) begin
            rd_ptr  <= 0;
            wr_ptr  <= 0;
            full    <= 0;
            empty   <= 1;
        end
        else begin
            next_wr_ptr = wr_ptr;
            next_rd_ptr = rd_ptr;
            if (wr_en && !full) begin
                if (wr_addr == MAX_NUM_BYTES - INPUT_WIDTH_BYTES)
                    next_wr_ptr = {~wr_ptr[PTR_MSB], {PTR_MSB{1'b0}}};
                else
                    next_wr_ptr = wr_ptr + INPUT_WIDTH_BYTES;

                for (ii = 0; ii < INPUT_WIDTH_BYTES; ii = ii + 1) begin
                    memory[wr_addr + ii] <= #1 data_in[ii*8 +: 8];
                end

                wr_ptr <= #1 next_wr_ptr;
            end
            if (rd_en && !empty) begin
                if (rd_addr == MAX_NUM_BYTES - 1)
                    next_rd_ptr = {~rd_ptr[PTR_MSB], {PTR_MSB{1'b0}}};
                else
                    next_rd_ptr = rd_ptr + 1;

                //data_out <= #1 memory[rd_addr]; // normal fifo

                rd_ptr <= #1 next_rd_ptr;
            end
            
            // FULL FLAG
            // full = 0 if next_rd_ptr equals a multiple of the input width in bytes as new data can be processed then
            for (ii = 0; ii < FIFO_DEPTH_INPUT; ii = ii + 1) begin
                if (next_rd_ptr[ADDR_MSB:0] == ii * INPUT_WIDTH_BYTES)
                    full <= #1 1'b0; 
            end
            // one exception from the above: if (next_rd_ptr[PTR_MSB] == ~next_wr_ptr[PTR_MSB]) full = 1
            if (next_wr_ptr[PTR_MSB] != next_rd_ptr[PTR_MSB]) begin 
                if (next_wr_ptr[ADDR_MSB:0] == next_rd_ptr[ADDR_MSB:0])
                    full <= #1 1'b1;
            end
            // full = 1 if next_wr_ptr + (1..5) equals next_rd_ptr as data would be overwritten if performing a write
            for (ii = 1; ii < INPUT_WIDTH_BYTES; ii = ii + 1) begin
                if (next_wr_ptr[ADDR_MSB:0] + ii == next_rd_ptr[ADDR_MSB:0])
                    full <= #1 1'b1;
            end
            
            // EMPTY FLAG
            // empty only if head equals tail with same PTR_MSB bit
            if ((next_wr_ptr[PTR_MSB] == next_rd_ptr[PTR_MSB]) && (next_wr_ptr[ADDR_MSB:0] == next_rd_ptr[ADDR_MSB:0]))
                empty <= #1 1'b1;
            else
                empty <= #1 1'b0;
        end
    end
endmodule
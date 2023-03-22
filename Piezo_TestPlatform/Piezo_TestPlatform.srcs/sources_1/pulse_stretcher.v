module pulse_stretcher #(
    parameter NUM_STRETCH_CYCLES = 50
) (
    input wire clk,
    input wire pulse_src,
    output wire pulse_dst
);
    reg [11:0] counter = 0;

    always @(posedge clk) begin
        if (pulse_src == 1'b1) begin
            counter <= NUM_STRETCH_CYCLES;
        end
        if (counter != 7'd0) begin
            counter <= counter - 1;
        end
    end

    assign pulse_dst = (counter != 12'd0) ? 1'b1 : 1'b0;
endmodule

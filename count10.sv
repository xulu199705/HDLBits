// https://hdlbits.01xz.net/wiki/Count10

module top_module (
    input clk,
    input reset,        // Synchronous active-high reset
    output reg [3:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
        end else begin
            q <= q == 9 ? 0 : q + 1;
        end
    end
endmodule

// https://hdlbits.01xz.net/wiki/Count15

module top_module (
    input clk,
    input reset,      // Synchronous active-high reset
    output [3:0] q);

    reg [3:0] cnt = 0;
    always @(posedge clk)
        cnt = (reset | cnt == 15) ? 0 : cnt + 1;

    assign q = cnt;

endmodule

// https://hdlbits.01xz.net/wiki/Countbcd

module top_module (
    input clk,
    input reset,        // Synchronous active-high reset
    output reg [3:1] ena,
    output reg [15:0] q);

    assign ena[1] = q[ 3: 0] == 4'd9;
    assign ena[2] = q[ 7: 0] == {4'd9, 4'd9};
    assign ena[3] = q[11: 0] == {4'd9, 4'd9, 4'd9};

    bcdcount bcdcount0 (clk,   1'b1, reset, q[ 3: 0]);
    bcdcount bcdcount1 (clk, ena[1], reset, q[ 7: 4]);
    bcdcount bcdcount2 (clk, ena[2], reset, q[11: 8]);
    bcdcount bcdcount3 (clk, ena[3], reset, q[15:12]);
endmodule


module bcdcount (
    input clk,
    input enable,
    input reset,        // Synchronous active-high reset
    output reg [3:0] q);

    always @(posedge clk)
        if (reset)
            q <= 4'd0;
        else if (enable)
            q <= q == 4'd9 ? 4'd0 : q + 4'd1;
endmodule

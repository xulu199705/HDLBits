// https://hdlbits.01xz.net/wiki/Dualedge

module top_module (
    input clk,
    input d,
    output q
);
    reg p, n;

    // when pos, clk=hi, q = p
    // when neg, clk=lo, q = n
    always @(posedge clk)
        p <= d;
    always @(negedge clk)
        n <= d;
    assign q = clk ? p : n;

    // when pos, q = p ^ n = d ^ n ^ n = d ^ 1'b0 = d
    // when neg, q = p ^ n = p ^ d ^ p = d ^ 1'b0 = d
    // always @(posedge clk)
    //     p <= d ^ n;
    // always @(negedge clk)
    //     n <= d ^ p;
    // assign q = p ^ n;

endmodule

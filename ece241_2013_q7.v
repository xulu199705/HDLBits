// https://hdlbits.01xz.net/wiki/Exams/ece241_2013_q7

module top_module (
    input clk,
    input j,
    input k,
    output Q
);

    wire d;
    assign d = ((j ^ k) & j) | (~(j ^ k) & ((j & ~Q) | (~j & Q)));

    mydff dff (clk, d, Q);
endmodule

module mydff (
    input clk,
    input d,
    output q
);

    always @(posedge clk ) begin
        q <= d;
    end
endmodule
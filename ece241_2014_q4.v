// https://hdlbits.01xz.net/wiki/Exams/ece241_2014_q4

module top_module (
    input clk,
    input x,
    output z
);
    wire d0, q0;
    wire d1, q1;
    wire d2, q2;

    assign d0 = q0 ^ x;
    assign d1 = ~q1 & x;
    assign d2 = ~q2 | x;

    mydff dff0 (clk, d0, q0);
    mydff dff1 (clk, d1, q1);
    mydff dff2 (clk, d2, q2);

    assign z = ~|{q0, q1, q2};
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
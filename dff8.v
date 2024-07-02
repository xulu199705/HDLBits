// https://hdlbits.01xz.net/wiki/Dff8

module top_module (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    mydff mydff0 (clk, d[0], q[0]);
    mydff mydff1 (clk, d[1], q[1]);
    mydff mydff2 (clk, d[2], q[2]);
    mydff mydff3 (clk, d[3], q[3]);
    mydff mydff4 (clk, d[4], q[4]);
    mydff mydff5 (clk, d[5], q[5]);
    mydff mydff6 (clk, d[6], q[6]);
    mydff mydff7 (clk, d[7], q[7]);
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

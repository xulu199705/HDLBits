// https://hdlbits.01xz.net/wiki/Dff8r

module top_module (
    input clk,
    input reset,            // Synchronous reset
    input [7:0] d,
    output [7:0] q
);

    mydff mydff0 (clk, reset, d[0], q[0]);
    mydff mydff1 (clk, reset, d[1], q[1]);
    mydff mydff2 (clk, reset, d[2], q[2]);
    mydff mydff3 (clk, reset, d[3], q[3]);
    mydff mydff4 (clk, reset, d[4], q[4]);
    mydff mydff5 (clk, reset, d[5], q[5]);
    mydff mydff6 (clk, reset, d[6], q[6]);
    mydff mydff7 (clk, reset, d[7], q[7]);
endmodule

module mydff (
    input clk,
    input reset,            // Synchronous reset
    input d,
    output q
);

    always @(posedge clk ) begin
        if (reset) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end
endmodule

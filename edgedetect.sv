// https://hdlbits.01xz.net/wiki/Edgedetect

module top_module (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    wire [7:0] q;

    always @(posedge clk ) begin
        pedge <= in & ~q;
        q <= in;
    end

endmodule

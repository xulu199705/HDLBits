// https://hdlbits.01xz.net/wiki/Edgedetect2

module top_module (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    wire [7:0] q;

    always @(posedge clk ) begin
        anyedge <= in ^ q;
        q <= in;
    end

endmodule

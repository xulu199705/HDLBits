// https://hdlbits.01xz.net/wiki/Edgecapture

module top_module (
    input clk,
    input reset, // synchronous
    input [31:0] in,
    output [31:0] out
);

    wire [31:0] q;

    always @(posedge clk ) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            out <= ~out & (~in & q) | out;
        end
        q <= in;
    end

endmodule

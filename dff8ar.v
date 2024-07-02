// https://hdlbits.01xz.net/wiki/Dff8ar

module top_module (
    input clk,
    input areset,   // active high asynchronous reset
    input [7:0] d,
    output [7:0] q
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= 8'h0;
        end else begin
            q <= d;
        end
    end
endmodule

// https://hdlbits.01xz.net/wiki/Dff8p

module top_module (
    input clk,
    input reset,            // Synchronous reset
    input [7:0] d,
    output [7:0] q
);

    always @(negedge clk ) begin
        if (reset) begin
            q <= 8'h34;
        end else begin
            q <= d;
        end
    end
endmodule

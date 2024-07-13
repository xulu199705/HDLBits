// https://hdlbits.01xz.net/wiki/Rule110

module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q);

    reg [511:0] l, c, r;

    always @(posedge clk) begin
        if(load) begin
            q <= data;
        end else begin
            l = q >> 1;
            c = q;
            r = q << 1;
            q <= (c ^ r) | (c & r & ~l);
        end
    end

endmodule

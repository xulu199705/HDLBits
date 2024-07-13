// https://hdlbits.01xz.net/wiki/Rule90

module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q );

    always @(posedge clk) begin
        if(load) begin
            q <= data;
        end else begin
            q <= (q << 1) ^ (q >> 1);
        end
    end

endmodule

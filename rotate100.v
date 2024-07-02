// https://hdlbits.01xz.net/wiki/Rotate100

module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q);

    parameter ROTATER = 2'b01; // rotates right by one bit
    parameter ROTATEL = 2'b10; // rotates left by one bit

    always @(posedge clk)
        if (load)
            q <= data;
        else
            case (ena)
                ROTATER: q <= {q[0], q[99:1]};
                ROTATEL: q <= {q[98:0], q[99]};
            endcase
endmodule

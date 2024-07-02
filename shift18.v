// https://hdlbits.01xz.net/wiki/Shift18

module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q);

    parameter ASL1 = 2'b00; // shift left by 1 bit.
    parameter ASL8 = 2'b01; // shift left by 8 bits.
    parameter ASR1 = 2'b10; // shift right by 1 bit.
    parameter ASR8 = 2'b11; // shift right by 8 bits.

    always @(posedge clk)
        if (load)
            q <= data;
        else if (ena)
            case (amount)
                ASL1: q <= q << 1;
                ASL8: q <= q << 8;
                ASR1: q <= q >> 1 | {q[63], {63{1'b0}}};
                ASR8: q <= q >> 8 | {{8{q[63]}}, {56{1'b0}}};
            endcase

endmodule

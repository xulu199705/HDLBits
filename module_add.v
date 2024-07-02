// https://hdlbits.01xz.net/wiki/Module_add

module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);

    wire add16_lo_cout;
    wire add16_hi_cout;
    add16 add_lo (
        .a(a[15: 0]),
        .b(b[15: 0]),
        .cin(1'b0),
        .sum(sum[15:0]),
        .cout(add16_lo_cout)
    );
    add16 add_hi (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(add16_lo_cout),
        .sum(sum[31:16]),
        .cout(add16_hi_cout)
    );

endmodule

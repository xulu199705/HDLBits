// https://hdlbits.01xz.net/wiki/Module_addsub

module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);

    wire add_lo_cout;
    wire [15:0] add_lo_sum;
    add16 add_lo (
        .a(a[15: 0]),
        .b(b[15: 0] ^ {16{sub}}),
        .cin(sub),
        .sum(add_lo_sum),
        .cout(add_lo_cout)
    );

    wire [15:0] add_hi_sum;
    add16 add_hi (
        .a(a[31:16]),
        .b(b[31:16] ^ {16{sub}}),
        .cin(add_lo_cout),
        .sum(add_hi_sum)
    );

    assign sum = {add_hi_sum, add_lo_sum};

endmodule

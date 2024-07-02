// https://hdlbits.01xz.net/wiki/Adder100i

module top_module(
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );

    fadd myfadd (a[0], b[0], cin, sum[0], cout[0]);

    generate
        genvar i;
        for (i = 1; i < $bits(a); i++) begin: blk_gen_fadd_array
            fadd myfadd (a[i], b[i], cout[i-1], sum[i], cout[i]);
        end
    endgenerate
endmodule

module fadd (
    a, b, cin, sum, cout
);
    input wire a, b, cin;
    output wire sum, cout;

    assign {cout, sum} = a + b + cin;
endmodule

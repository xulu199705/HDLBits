// https://hdlbits.01xz.net/wiki/Fadd

module top_module(
    input a, b, cin,
    output cout, sum );

    assign {cout, sum} = a + b + cin;

endmodule

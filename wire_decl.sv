// https://hdlbits.01xz.net/wiki/Wire_decl

`default_nettype none
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n   );

    wire aandb;
    wire candd;

    assign aandb = a & b;
    assign candd = c & d;

    assign out = aandb | candd;
    assign out_n = ~out;

endmodule

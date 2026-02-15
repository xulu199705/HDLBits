// https://hdlbits.01xz.net/wiki/Kmap3

module top_module(
    input a,
    input b,
    input c,
    input d,
    output out  );

    // sum of product
    // assign out = a | (~b & c);

    // product of sum
    assign out = (a | ~b) & (a | c);

endmodule

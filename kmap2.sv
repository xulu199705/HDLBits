// https://hdlbits.01xz.net/wiki/Kmap2

module top_module(
    input a,
    input b,
    input c,
    input d,
    output out  );

    // sum of product
    // assign out = (~b & ~c) | (a & c & d) | (~a & b & c) | (~a & b & ~c & ~d) | (~a & ~b & c & ~d);

    // product of sum
    assign out = (~a | ~c | d) & (~a | ~b | c) & (a | b | ~c | ~d) & (a | ~b | c | ~d);

endmodule

// https://hdlbits.01xz.net/wiki/Exams/m2014_q3

module top_module (
    input [4:1] x,
    output f );

    // sum of product
    // assign f = (~x[1] & x[3]) | (x[2] & ~x[3] & x[4]);

    // product of sum
    assign f = (x[1] | x[3]) & (~x[1] | ~x[3]) & (~x[1] | x[2]);

endmodule

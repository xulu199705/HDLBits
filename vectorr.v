// https://hdlbits.01xz.net/wiki/Vectorr

module top_module(
    input [7:0] in,
    output [7:0] out
);
    generate
        genvar i;
        for(i = 0; i < $bits(out); i = i + 1) begin : blk_gen_rev_vector
            assign out[i] = in[$bits(out) - 1 - i];
        end
    endgenerate
endmodule

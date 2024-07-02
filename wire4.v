// https://hdlbits.01xz.net/wiki/Wire4

module top_module(
    input a,b,c,
    output w,x,y,z );

    assign {w,x,y,z} = {a,b,b,c};
endmodule

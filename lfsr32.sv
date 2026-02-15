// https://hdlbits.01xz.net/wiki/lsfr32

module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 32'h1
    output [31:0] q
);
    localparam INITQ = 32'h1;

    always @(posedge clk)
        if(reset)
            q <= INITQ;
        else
            // tap =          32                22                 2     1
            //                31                21                 1     0
            q <= (q >> 1) ^ {q[0], {9{1'b0}},  q[0], {19{1'b0}}, q[0], q[0]};
endmodule

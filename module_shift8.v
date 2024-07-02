// https://hdlbits.01xz.net/wiki/Module_shift8

module top_module (
    input clk,
    input [7:0] d,
    input [1:0] sel,
    output [7:0] q
);
    wire [7:0] q1;
    wire [7:0] q2;
    wire [7:0] q3;

    my_dff8 dff1(clk,  d, q1);
    my_dff8 dff2(clk, q1, q2);
    my_dff8 dff3(clk, q2, q3);

    assign q =  (q3 & {8{ sel[1] &  sel[0]}}) |
                (q2 & {8{ sel[1] & ~sel[0]}}) |
                (q1 & {8{~sel[1] &  sel[0]}}) |
                (d  & {8{~sel[1] & ~sel[0]}});
endmodule

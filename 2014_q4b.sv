// https://hdlbits.01xz.net/wiki/Exams/2014_q4b

module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
); //

    wire [3:0] r  ;
    wire       clk;
    wire       e  ;
    wire       l  ;
    wire       w  ;

    reg [3:0] next_ledr;

    assign r = SW;
    assign {w, l, e, clk} = KEY;

    assign next_ledr = l ? r : (e ? {w,LEDR[3:1]} : LEDR);

    always @(posedge clk)
        LEDR <= next_ledr;

endmodule

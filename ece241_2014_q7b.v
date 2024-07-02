// https://hdlbits.01xz.net/wiki/Exams/ece241_2014_q7b

module top_module (
    input clk,              // 1000 Hz
    input reset,
    output OneHertz,
    output [2:0] c_enable
); //

    wire [3:0] c_q0;
    wire [3:0] c_q1;
    wire [3:0] c_q2;

    assign c_enable[0] = 1'b1;
    assign c_enable[1] = c_q0 == 4'd9;
    assign c_enable[2] = c_q0 == 4'd9 & c_q1 == 4'd9;
    assign OneHertz    = c_q0 == 4'd9 & c_q1 == 4'd9 & c_q2 == 4'd9;

    bcdcount counter0 (clk, reset, c_enable[0], c_q0);
    bcdcount counter1 (clk, reset, c_enable[1], c_q1);
    bcdcount counter2 (clk, reset, c_enable[2], c_q2);

endmodule

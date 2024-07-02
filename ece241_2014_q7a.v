// https://hdlbits.01xz.net/wiki/Exams/ece241_2014_q7a

module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
); //

    // Reset    Synchronous active-high reset that forces the counter to 1
    // Enable   Set high for the counter to run
    // Clk      Positive edge-triggered clock input
    // Q[3:0]   The output of the counter
    // c_enable
    // c_load   Control signals going to the provided 4-bit counter, so correct operation can be verified.
    // c_d[3:0]

    wire cntrst;
    assign cntrst = (Q == 4'd12 & enable) | reset;

    assign c_enable = enable;
    assign c_load = cntrst;
    assign c_d = 4'd1;
    count4 the_counter (clk, c_enable, c_load, c_d,  Q);

endmodule

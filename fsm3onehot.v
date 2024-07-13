// https://hdlbits.01xz.net/wiki/Fsm3onehot

module top_module(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out); //

    parameter A = 2'd0;
    parameter B = 2'd1;
    parameter C = 2'd2;
    parameter D = 2'd3;

    // State transition logic: Derive an equation for each state flip-flop.
    assign next_state[A] = (state[A] | state[C]) & ~in;
    assign next_state[B] = (state[A] | state[B] | state[D]) & in;
    assign next_state[C] = (state[B] | state[D]) & ~in;
    assign next_state[D] = state[C] & in;

    // Output logic:
    assign out = state[D] ? 1'b1 : 1'b0;

endmodule

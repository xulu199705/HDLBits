// https://hdlbits.01xz.net/wiki/Fsm3comb

module top_module(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out); //

    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State transition logic: next_state = f(state, in)
    always @(state, in) begin
        case ({state, in})
            {A, 1'b0}: next_state <= A;
            {A, 1'b1}: next_state <= B;
            {B, 1'b0}: next_state <= C;
            {B, 1'b1}: next_state <= B;
            {C, 1'b0}: next_state <= A;
            {C, 1'b1}: next_state <= D;
            {D, 1'b0}: next_state <= C;
            {D, 1'b1}: next_state <= B;
        endcase
    end

    // Output logic:  out = f(state) for a Moore state machine
    assign out = state == D ? 1'b1 : 1'b0;

endmodule

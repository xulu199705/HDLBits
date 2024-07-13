// https://hdlbits.01xz.net/wiki/Fsm1

module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out);//

    parameter A = 1'b0;
    parameter B = 1'b1;
    reg state, next_state;

    // generate `next state`
    always @(*) begin
        // State transition logic
        case ({state,in})
            {A, 1'b0}: next_state = B;
            {A, 1'b1}: next_state = A;
            {B, 1'b0}: next_state = A;
            {B, 1'b1}: next_state = B;
        endcase
    end

    // assign `next state` to state
    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if(areset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign out = state == A ? 1'b0 : 1'b1;

endmodule

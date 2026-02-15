// https://hdlbits.01xz.net/wiki/Fsm3

module top_module(
    input clk,
    input in,
    input areset,
    output out); //

    parameter A = 2'd0;
    parameter B = 2'd1;
    parameter C = 2'd2;
    parameter D = 2'd3;

    reg [2:0] state = A;
    reg [2:0] next_state = A;

    // State transition logic
    always @(*) begin
        case ({state, in})
            {A, 1'b0}: next_state = A;
            {A, 1'b1}: next_state = B;
            {B, 1'b0}: next_state = C;
            {B, 1'b1}: next_state = B;
            {C, 1'b0}: next_state = A;
            {C, 1'b1}: next_state = D;
            {D, 1'b0}: next_state = C;
            {D, 1'b1}: next_state = B;
            default:   next_state = A;
        endcase
    end

    // State flip-flops with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign out = state == D ? 1'b1 : 1'b0;

endmodule

// https://hdlbits.01xz.net/wiki/Lemmings2

module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah );

    //                     fall dir
    parameter W_LEFT  = 2'b0____0;
    parameter W_RIGHT = 2'b0____1;
    parameter F_LEFT  = 2'b1____0;
    parameter F_RIGHT = 2'b1____1;

    reg [1:0] state;
    reg [1:0] next_state;

    always @(*) begin
        // State transition logic
        casez ({state, ground, bump_left, bump_right})
            {2'b??,   3'b0??}: next_state = state | 2'b10;
            {2'b1?,   3'b1??}: next_state = state & 2'b01;
            {W_LEFT,  3'b11?}: next_state = W_RIGHT;
            {W_RIGHT, 3'b1?1}: next_state = W_LEFT;
            default:           next_state = state;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if(areset) begin
            state <= W_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign aaah       = state[1];
    assign walk_left  = (state == W_LEFT  ? 1'b1 : 1'b0);
    assign walk_right = (state == W_RIGHT ? 1'b1 : 1'b0);

endmodule

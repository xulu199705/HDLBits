// https://hdlbits.01xz.net/wiki/Lemmings1

module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); //

    // parameter LEFT=0, RIGHT=1, ...
    parameter LEFT  = 1'b0;
    parameter RIGHT = 1'b1;

    reg state;
    reg next_state;

    always @(*) begin
        // State transition logic
        casez ({state, bump_left, bump_right})
            {LEFT,  2'b1?}: next_state = RIGHT;
            {RIGHT, 2'b?1}: next_state = LEFT;
            default:        next_state = state;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if(areset) begin
            state <= LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign walk_left  = (state == LEFT  ? 1'b1 : 1'b0);
    assign walk_right = (state == RIGHT ? 1'b1 : 1'b0);

endmodule

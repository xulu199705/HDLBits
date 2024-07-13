// https://hdlbits.01xz.net/wiki/Lemmings3

module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging );

    //                     fall dig dir
    parameter F_LEFT  = 3'b1____0___0;
    parameter F_RIGHT = 3'b1____0___1;
    parameter D_LEFT  = 3'b0____1___0;
    parameter D_RIGHT = 3'b0____1___1;
    parameter W_LEFT  = 3'b0____0___0;
    parameter W_RIGHT = 3'b0____0___1;


    reg [2:0] state;
    reg [2:0] next_state;

    always @(*) begin
        // State transition logic
        casez ({state, ground, dig, bump_left, bump_right})
            {3'b???,  4'b0???}: next_state = {1'b1, 1'b0,    state[0]};
            {3'b1??,  4'b1???}: next_state = {1'b0, state[1],state[0]};
            {3'b00?,  4'b11??}: next_state = {1'b0, 1'b1,    state[0]};
            {W_LEFT,  4'b101?}: next_state = W_RIGHT;
            {W_RIGHT, 4'b10?1}: next_state = W_LEFT;
            default:            next_state = state;
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
    assign aaah       = state[2];
    assign digging    = state[1];
    assign walk_left  = (state == W_LEFT  ? 1'b1 : 1'b0);
    assign walk_right = (state == W_RIGHT ? 1'b1 : 1'b0);

endmodule

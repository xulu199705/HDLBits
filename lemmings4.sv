// https://hdlbits.01xz.net/wiki/Lemmings4

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

    //                     dead fall dig dir
    parameter S_DEAD  = 4'b1____0____0___0;
    parameter F_LEFT  = 4'b0____1____0___0;
    parameter F_RIGHT = 4'b0____1____0___1;
    parameter D_LEFT  = 4'b0____0____1___0;
    parameter D_RIGHT = 4'b0____0____1___1;
    parameter W_LEFT  = 4'b0____0____0___0;
    parameter W_RIGHT = 4'b0____0____0___1;

    reg [3:0] state;
    reg [3:0] next_state;

    reg [4:0] cnt_aaah = 5'd0;

    // Generate next_state
    always @(*) begin
        casez ({state, ground, dig, bump_left, bump_right})
            {S_DEAD,  4'b????}: next_state = S_DEAD;
            {4'b0???, 4'b0???}: next_state = {1'b0, 1'b1, 1'b0, state[0]};
            {4'b01??, 4'b1???}: next_state = cnt_aaah >= 20 ? S_DEAD : {1'b0, 1'b0, 1'b0, state[0]};
            {4'b000?, 4'b11??}: next_state = {1'b0, 1'b0, 1'b1, state[0]};
            {W_LEFT,  4'b101?}: next_state = W_RIGHT;
            {W_RIGHT, 4'b10?1}: next_state = W_LEFT;
            default:            next_state = state;
        endcase
    end

    // Assign next_state to state
    always @(posedge clk, posedge areset)
        if(areset)
            state <= W_LEFT;
        else
            state <= next_state;

    // Count time of aaah
    always @(posedge clk, posedge areset)
        if(areset)
            cnt_aaah <= 5'd0;
        else if(ground)
            cnt_aaah <= 5'b0;
        else if(aaah)
            cnt_aaah <= cnt_aaah > 20 ? cnt_aaah : cnt_aaah + 5'd1;

    // Output logic
    assign aaah       = state[2];
    assign digging    = state[1];
    assign walk_left  = (state == W_LEFT  ? 1'b1 : 1'b0);
    assign walk_right = (state == W_RIGHT ? 1'b1 : 1'b0);

endmodule

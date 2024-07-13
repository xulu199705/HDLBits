// https://hdlbits.01xz.net/wiki/Fsm_ps2

module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //

    parameter BYTE1 = 2'd0;
    parameter BYTE2 = 2'd1;
    parameter BYTE3 = 2'd2;
    parameter DONE  = 2'd3;

    reg [1:0] state;
    reg [1:0] next_state;

    // State transition logic (combinational)
    always @(*) begin
        casez ({state, in[3]})
            {DONE,  1'b0}: next_state = BYTE1;
            {DONE,  1'b1}: next_state = BYTE2;
            {BYTE1, 1'b0}: next_state = BYTE1;
            {BYTE1, 1'b1}: next_state = BYTE2;
            {BYTE2, 1'b?}: next_state = BYTE3;
            {BYTE3, 1'b?}: next_state = DONE;
        endcase
    end

    // State flip-flops (sequential)
    always @(posedge clk) begin
        if(reset) begin
            state <= BYTE1;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign done = state == DONE ? 1'b1 : 1'b0;

endmodule

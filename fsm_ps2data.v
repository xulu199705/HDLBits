// https://hdlbits.01xz.net/wiki/Fsm_ps2data

module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
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

    reg [7:0] out_byte1;
    reg [7:0] out_byte2;
    reg [7:0] out_byte3;

    // State flip-flops (sequential)
    always @(posedge clk) begin
        if(reset) begin
            state <= BYTE1;
        end else begin
            case (state)
                BYTE1: out_byte1 <= in;
                BYTE2: out_byte2 <= in;
                BYTE3: out_byte3 <= in;
                DONE : out_byte1 <= in;
            endcase
            state <= next_state;
        end
    end

    // Output logic
    assign done = state == DONE ? 1'b1 : 1'b0;
    assign out_bytes = done ? {out_byte1, out_byte2, out_byte3} : 23'b0;

endmodule

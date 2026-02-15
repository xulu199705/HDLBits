// https://hdlbits.01xz.net/wiki/Fsm2

module top_module(
    input clk,
    input reset,    // Synchronous reset to OFF
    input j,
    input k,
    output out); //

    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    reg state, next_state;

    always @(*) begin
        // State transition logic
        casez ({state, j, k})
            {OFF, 2'b1?}: next_state = ON;
            {OFF, 2'b0?}: next_state = OFF;
            {ON,  2'b?1}: next_state = OFF;
            {ON,  2'b?0}: next_state = ON;
        endcase
    end

    always @(posedge clk) begin
        // State flip-flops with synchronous reset
        if(reset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign out = (state == ON ? 1'b1 : 1'b0);

endmodule

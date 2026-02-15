// https://hdlbits.01xz.net/wiki/Iverilog

module top_module ();
	reg clk=0;
	always #5 clk = ~clk;  // Create clock with period=10
	initial #5 `probe_start;   // Start the timing diagram

    `probe(clk);
    `probe(in);
    `probe(reset);
    `probe(done);
    `probe(state);
    `probe(next_state);

	// A testbench
    reg in, reset, done;
    reg [3:0] state;
    reg [3:0] next_state;

	initial begin
        reset = 1;
        in = 1;
        #5;
        #10;
        reset = 0;
        in = 0;
        #90;
        in = 1;
        #10;
        in = 0;
        #30;

		#10 $finish; // Quit the simulation
	end

	mymod mymod_U0 ( clk, in, reset, done, state, next_state );

endmodule

module mymod(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done,
    output reg [3:0] state,
    output reg [3:0] next_state
);

    parameter FSTA = 4'h0;
    parameter BIT1 = 4'h1;
    parameter BIT2 = 4'h2;
    parameter BIT3 = 4'h3;
    parameter BIT4 = 4'h4;
    parameter BIT5 = 4'h5;
    parameter BIT6 = 4'h6;
    parameter BIT7 = 4'h7;
    parameter BIT8 = 4'h8;
    parameter FEND = 4'h9;
    parameter FFIN = 4'ha;

    // reg [3:0] state;
    // reg [3:0] next_state;

    always @(*) begin
        casez ({state, in})
            {FSTA, 1'b1}: next_state = FSTA;
            {FSTA, 1'b0}: next_state = BIT1;

            {BIT1, 1'b?}: next_state = BIT2;
            {BIT2, 1'b?}: next_state = BIT3;
            {BIT3, 1'b?}: next_state = BIT4;
            {BIT4, 1'b?}: next_state = BIT5;
            {BIT5, 1'b?}: next_state = BIT6;
            {BIT6, 1'b?}: next_state = BIT7;
            {BIT7, 1'b?}: next_state = BIT8;

            {BIT8, 1'b1}: next_state = FEND;
            {BIT8, 1'b0}: next_state = FSTA;

            {FEND, 1'b?}: next_state = FFIN;

            {FFIN, 1'b1}: next_state = FSTA;
            {FFIN, 1'b0}: next_state = BIT1;
            default:      next_state = FSTA;
        endcase
    end

    always @(posedge clk) begin
        if(reset) begin
            state <= FSTA;
        end else begin
            state <= next_state;
        end
    end

    assign done = (state == FFIN) ? 1'b1 : 1'b0;

endmodule

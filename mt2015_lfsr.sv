// https://hdlbits.01xz.net/wiki/Mt2015_lfsr

module top_module (
	input [2:0] SW,      // R
	input [1:0] KEY,     // L and clk
	output [2:0] LEDR    // Q
);
    wire [2:0] r;
    wire l;
    wire clk;
    reg [2:0] q;

    wire [2:0] next_q;

    assign r   = SW;
    assign l   = KEY[1];
    assign clk = KEY[0];
    assign LEDR = q;

    assign next_q = l ? r : {q[2]^q[1], q[0], q[2]};

    always @(posedge clk)
        q <= next_q;

endmodule

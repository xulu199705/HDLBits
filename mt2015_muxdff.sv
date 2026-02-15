// https://hdlbits.01xz.net/wiki/Mt2015_muxdff

module top_module (
	input clk,
	input L,
	input r_in,
	input q_in,
	output reg Q);

    wire dff0_d;
    assign dff0_d = L ? r_in : q_in;

    mydff dff0 (clk, dff0_d, Q);

endmodule

module mydff (
    input clk,
    input d,
    output q
);
    always @(posedge clk ) begin
        q <= d;
    end
endmodule
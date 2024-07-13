// https://hdlbits.01xz.net/wiki/Lfsr5

module top_module(
    // RESET & CLOCK
    input clk,
    input reset,    // Active-high synchronous reset to 5'h1
    // OUTPUT INTERFACE
    output [4:0] q
);

    wire [4:0] d;

    assign d[0] = q[1];
    assign d[1] = q[2];
    assign d[2] = q[3] ^ q[0];
    assign d[3] = q[4];
    assign d[4] = q[0];

    mydff #(1'b1) mydff_0 (clk, reset, d[0], q[0]);
    mydff #(1'b0) mydff_1 (clk, reset, d[1], q[1]);
    mydff #(1'b0) mydff_2 (clk, reset, d[2], q[2]);
    mydff #(1'b0) mydff_3 (clk, reset, d[3], q[3]);
    mydff #(1'b0) mydff_4 (clk, reset, d[4], q[4]);

endmodule // <--- top_module module end

module mydff #(
    parameter INITVALUE = 1'b0
)(
    // RESET & CLOCK
    input  clk,
    input  reset,
    // IN INTERFACE
    input  d,
    // OUTPUT INTERFACE
    output q
);

    /***************************************
        ALWAYS SEGMENT
    ***************************************/
    always @(posedge clk) begin
        if(reset)
            q <= INITVALUE;
        else
            q <= d;
    end

endmodule // <--- mydff module end

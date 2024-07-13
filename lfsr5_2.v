// https://hdlbits.01xz.net/wiki/Lfsr5

module top_module(
    // RESET & CLOCK
    input clk,
    input reset,    // Active-high synchronous reset to 5'h1
    // OUTPUT INTERFACE
    output [4:0] q
);

    localparam INITVALUE = 5'b00001;

    wire [4:0] d;

    always @(posedge clk) begin
        if(reset)
            q <= INITVALUE;
        else
            q <= {q[0], q[4], q[3] ^ q[0], q[2], q[1]};
    end

endmodule // <--- top_module module end

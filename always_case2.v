// https://hdlbits.01xz.net/wiki/Always_case2

// synthesis verilog_input_version verilog_2001
module top_module (
    input [3:0] in,
    output reg [1:0] pos  );

    always @(*) begin
        casex (in)
            4'bxxx1 : pos = 2'd0;
            4'bxx10 : pos = 2'd1;
            4'bx100 : pos = 2'd2;
            4'b1000 : pos = 2'd3;
            default: pos = 2'd0;
        endcase
    end

endmodule

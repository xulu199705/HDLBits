// https://hdlbits.01xz.net/wiki/Exams/m2014_q4c

module top_module (
    input clk,
    input d,
    input r,   // synchronous reset
    output q);

    always @(posedge clk ) begin
        if (r) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end
endmodule

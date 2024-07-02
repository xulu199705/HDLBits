// https://hdlbits.01xz.net/wiki/Popcount255

module top_module(
    input [254:0] in,
    output [7:0] out );

    always @(*) begin
        integer iter;
        integer cnt;

        cnt = 0;
        for (iter = 0; iter < $bits(in); iter++) begin
            cnt = cnt + in[iter];
        end

        out = cnt;
    end
endmodule

// https://hdlbits.01xz.net/wiki/Bcdadd100

module top_module(
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );

    wire [399:0] cout_tmp;
    generate
        genvar i;
        // bcd_fadd          (a, b, cin, cout, sum)
        bcd_fadd bcd_fadd_U0 (a[3:0], b[3:0], cin, cout_tmp[0], sum[3:0]);
        for(i = 4; i < $bits(a); i = i + 4) begin:gen_for_add
            bcd_fadd bcd_fadd_U0 (a[i+3:i], b[i+3:i], cout_tmp[i-4], cout_tmp[i], sum[i+3:i]);
        end
    endgenerate

    assign cout = cout_tmp[396];

endmodule

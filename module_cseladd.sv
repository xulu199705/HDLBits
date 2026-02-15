// https://hdlbits.01xz.net/wiki/Module_cseladd

module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);

    wire add_lo_cout;
    wire [15:0] add_lo_sum;
    add16 add_lo (
        .a(a[15: 0]),
        .b(b[15: 0]),
        .cin(1'b0),
        .sum(add_lo_sum),
        .cout(add_lo_cout)
    );

    wire [15:0] add_hi_0_sum;
    wire [15:0] add_hi_1_sum;
    add16 add_0 (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(1'b0),
        .sum(add_hi_0_sum)
    );
    add16 add_1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(1'b1),
        .sum(add_hi_1_sum)
    );

    assign sum = {add_hi_0_sum&{16{~add_lo_cout}} | add_hi_1_sum&{16{add_lo_cout}}, add_lo_sum};

    // always @(add_hi_0_sum or add_hi_1_sum or add_lo_cout or add_lo_sum) begin
    //     case (add_lo_cout)
    //         1'b0: sum = {add_hi_0_sum, add_lo_sum};
    //         1'b0: sum = {add_hi_1_sum, add_lo_sum};
    //         default: sum = 32'b0;
    //     endcase
    // end

endmodule

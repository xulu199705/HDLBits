// https://hdlbits.01xz.net/wiki/Exams/m2014_q4j

module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum);

    wire [2:0] cout;

    fadd mt_fadd_0 ( x[0], y[0], 1'b0,    cout[0], sum[0]);
    fadd mt_fadd_1 ( x[1], y[1], cout[0], cout[1], sum[1]);
    fadd mt_fadd_2 ( x[2], y[2], cout[1], cout[2], sum[2]);
    fadd mt_fadd_3 ( x[3], y[3], cout[2], sum[4],  sum[3]);

endmodule


module fadd(
    input a, b, cin,
    output cout, sum );
    assign {cout, sum} = a + b + cin;
endmodule

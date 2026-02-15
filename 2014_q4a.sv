// https://hdlbits.01xz.net/wiki/Exams/2014_q4a

module top_module (
    input clk,
    input w, R, E, L,
    output Q
);

    wire d_in;
    assign d_in = L ? R : (E ? w : Q);

    mydff dff (clk, d_in, Q);

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
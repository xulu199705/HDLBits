// https://hdlbits.01xz.net/wiki/Exams/m2014_q4a

module top_module (
    input d,
    input ena,
    output q);

    assign q = ena ? d : q;
endmodule

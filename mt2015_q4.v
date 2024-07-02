// https://hdlbits.01xz.net/wiki/Mt2015_q4

module top_module (input x, input y, output z);

    wire a1_z;
    wire a2_z;
    wire b1_z;
    wire b2_z;

    mt2015_q4a mt2015_q4a_1 (x, y, a1_z);
    mt2015_q4a mt2015_q4a_2 (x, y, a2_z);
    mt2015_q4b mt2015_q4b_1 (x, y, b1_z);
    mt2015_q4b mt2015_q4b_2 (x, y, b2_z);

    assign z = (a1_z | b1_z) ^ (a2_z & b2_z);

endmodule

module mt2015_q4a (input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

module mt2015_q4b ( input x, input y, output z );
    assign z = ~(x ^ y);
endmodule

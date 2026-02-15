// https://hdlbits.01xz.net/wiki/Count_clock

module top_module(
    input clk,
    input reset,        // Synchronous active-high reset
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss);

    wire [2:0] ena_cnt;

    assign ena_cnt[0] = ena;
    assign ena_cnt[1] =      ss  ==  8'h59   ? 1'b1 : 1'b0;
    assign ena_cnt[2] = {mm, ss} == 16'h5959 ? 1'b1 : 1'b0;

    always @(posedge clk) begin
        if (reset)
            pm = 1'b0;
        else
            pm = {hh, mm, ss} == 24'h115959 ? ~pm : pm;
    end

    //              RST    STA    END
    bcdcount2dig #(8'h00, 8'h00, 8'h59) bcdcount2digss (clk, reset, ena_cnt[0], ss);
    bcdcount2dig #(8'h00, 8'h00, 8'h59) bcdcount2digmm (clk, reset, ena_cnt[1], mm);
    bcdcount2dig #(8'h12, 8'h01, 8'h12) bcdcount2dighh (clk, reset, ena_cnt[2], hh);

endmodule

module bcdcount2dig #(
    parameter [7:0] RST_LOAD = 8'h00,
    parameter [7:0] STA_NUM  = 8'h00,
    parameter [7:0] END_NUM  = 8'h59
)(
    input clk,
    input reset,
    input enable,
    output reg [7:0] q);

    always @(posedge clk)
        if (reset)
            q <= RST_LOAD;
        else if (enable)
            casez (q)
                END_NUM: q <= STA_NUM;
                8'h?9:   q <= {q[7:4]+4'h1, 4'h0};
                default: q <= q + 8'h1;
            endcase
endmodule

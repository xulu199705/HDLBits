// https://hdlbits.01xz.net/wiki/Always_nolatches

// synthesis verilog_input_version verilog_2001
module top_module (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up  );

    parameter CODE_LEFT = 16'he06b;
    parameter CODE_DOWN = 16'he072;
    parameter CODE_RIGHT = 16'he074;
    parameter CODE_UP = 16'he075;

    always @(*) begin
        case (scancode)
            CODE_LEFT:  {left,down,right,up} = 4'b1000;
            CODE_DOWN:  {left,down,right,up} = 4'b0100;
            CODE_RIGHT: {left,down,right,up} = 4'b0010;
            CODE_UP:    {left,down,right,up} = 4'b0001;
            default:    {left,down,right,up} = 4'b0000;
        endcase
    end

endmodule

// https://hdlbits.01xz.net/wiki/Exams/ece241_2013_q4

module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
);

    // Define state
    // state for sensor
    parameter S34 = 3'b111;
    parameter S23 = 3'b011;
    parameter S12 = 3'b001;
    parameter S01 = 3'b000;
    // state for delta
    parameter DHIGH = 1'b1;
    parameter DLOW  = 1'b0;

    // Define intermediate state
    reg [2:0] state_sensor;
    reg       state_delta;
    reg [2:0] next_state_sensor;
    reg       next_state_delta;

    // Generate next_state
    always @(*) begin
        next_state_sensor = s;
        next_state_delta = state_sensor > s ? DHIGH : (state_sensor < s ? DLOW : state_delta);
    end

    // Assign next state to state
    always @(posedge clk) begin
        if(reset) begin // resets to a state equivalent to if the water level had been low for a long time (no sensors asserted, and all four outputs asserted).
            state_sensor <= S01;
            state_delta <= DHIGH;
        end else begin
            state_sensor <= next_state_sensor;
            state_delta <= next_state_delta;
        end
    end

    // Control physical devices
    assign {fr1, fr2, fr3} = ~state_sensor;
    assign dfr = state_delta;

endmodule

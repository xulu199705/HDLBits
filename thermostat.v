// https://hdlbits.01xz.net/wiki/Thermostat

module top_module (
    input too_cold, // off aircon
    input too_hot, // off heater
    input mode, // heating (mode = 1) and cooling (mode = 0)
    input fan_on, // on when heater, aircon or user-control
    output heater,
    output aircon,
    output fan
);

    assign heater =  mode & too_cold;
    assign aircon = ~mode & too_hot;
    assign fan = heater | aircon | fan_on;
endmodule

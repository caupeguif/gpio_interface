module gpio_npins (
    input wire clk,
    input wire reset,
    input wire [15:0] data_in,
    input wire [15:0] dir_in,
    input wire [15:0] gpio_pins,
    output wire [15:0] gpio_pins_out
);

    // Lógica para manejar solo pines no protegidos
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gpio_pin
            gpio_pin gpio_pin_inst (
                .clk(clk),
                .reset(reset),
                .data_in(data_in[i]),
                .dir_in(dir_in[i]),
                .gpio_pin(gpio_pins[i]),
                .gpio_pin_out(gpio_pins_out[i])
            );
        end
    endgenerate

endmodule

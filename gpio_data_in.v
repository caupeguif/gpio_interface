module gpio_data_in (
    input wire [15:0] gpio_pins,
    input wire [15:0] gpio_dir,
    output wire [15:0] gpio_data_in
);

    // Solo leemos pines configurados como entrada
    assign gpio_data_in = gpio_pins & ~gpio_dir;

endmodule

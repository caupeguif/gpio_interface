module gpio_spins (
    input wire [15:0] data_in,
    input wire [15:0] gpio_pins_in,
    input wire EN_PWM_OUTA0,
    input wire EN_PWM_OUTB0,
    input wire EN_TMR_IN0,
    input wire EN_I2C,
    input wire EN_SPI,
    input wire EN_UART,
    output reg [15:0] gpio_pins_out
);

    always @(*) begin
        // Pines 15 a 11 se mantienen sin cambios
        gpio_pins_out[15:11] = gpio_pins_in[15:11];

        // Timer Input 0 en el pin 10
        gpio_pins_out[10] = EN_TMR_IN0 ? data_in[10] : gpio_pins_in[10];

        // PWM Outputs
        gpio_pins_out[9] = EN_PWM_OUTA0 ? data_in[9] : gpio_pins_in[9];
        gpio_pins_out[8] = EN_PWM_OUTB0 ? data_in[8] : gpio_pins_in[8];

        // SPI Interface (Pines 7 a 4)
        gpio_pins_out[7] = EN_SPI ? data_in[7] : gpio_pins_in[7];
        gpio_pins_out[6] = EN_SPI ? data_in[6] : gpio_pins_in[6];
        gpio_pins_out[5] = EN_SPI ? data_in[5] : gpio_pins_in[5];
        gpio_pins_out[4] = EN_SPI ? data_in[4] : gpio_pins_in[4];

        // I2C Interface (Pines 3 y 2)
        gpio_pins_out[3] = EN_I2C ? data_in[3] : gpio_pins_in[3];
        gpio_pins_out[2] = EN_I2C ? data_in[2] : gpio_pins_in[2];

        // UART Interface (Pines 1 y 0)
        gpio_pins_out[1] = EN_UART ? data_in[1] : gpio_pins_in[1];
        gpio_pins_out[0] = EN_UART ? data_in[0] : gpio_pins_in[0];
    end

endmodule

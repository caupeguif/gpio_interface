module gpio_interface (
    input wire clk,
    input wire reset,
    input wire [15:0] data_in,
    input wire [15:0] dir_in,
    input wire [31:0] interrupt_mask,
    input wire [15:0] pinchange_msk,
    input wire write_data_enable,
    input wire write_dir_enable,
    input wire [15:0] gpio_pins,
    input wire [1:0] int0_msk,
    input wire [1:0] int1_msk,
    input wire EN_PWM_OUTA0,
    input wire EN_PWM_OUTB0,
    input wire EN_TMR_IN0,
    input wire EN_I2C,
    input wire EN_SPI,
    input wire EN_UART,
    output wire [15:0] gpio_data_in,
    output wire [15:0] gpio_data_out,
    output wire [15:0] gpio_pins_out,
    output wire irq_int0,
    output wire irq_int1,
    output wire irq_pinchange
);

    // Señales internas
    wire [15:0] gpio_dir;
    wire [15:0] gpio_data_out_internal;
    wire [15:0] gpio_pins_out_npins;
    wire [15:0] gpio_pins_out_internal;
    wire irq_int0_internal, irq_int1_internal, irq_pinchange_internal;

    // Instancia de GPIO_CTRL
	gpio_ctrl gpio_ctrl_inst (
		.clk(clk),
		.reset(reset),
		.interrupt_mask(interrupt_mask),
		.pinchange_msk(pinchange_msk),
		.gpio_pins(gpio_pins_out_npins), // Usar los pines procesados
		.irq_int0(irq_int0),
		.irq_int1(irq_int1),
		.irq_pinchange(irq_pinchange)
	);

    // Instancia de GPIO_DATA_IN para manejar entradas de pines
    gpio_data_in gpio_data_in_inst (
        .gpio_pins(gpio_pins),
        .gpio_dir(gpio_dir),
        .gpio_data_in(gpio_data_in)
    );

    // Instancia de GPIO_DIR para configurar dirección de los pines
    gpio_dir gpio_dir_inst (
        .clk(clk),
        .reset(reset),
        .dir_in(dir_in),
        .write_enable(write_dir_enable),
        .gpio_dir(gpio_dir)
    );

    // Instancia de GPIO_DATA_OUT para manejar salidas de datos
    gpio_data_out gpio_data_out_inst (
        .clk(clk),
        .reset(reset),
        .write_enable(write_data_enable),
        .data_in(data_in),
        .gpio_data_out(gpio_data_out_internal)
    );
 
   // Instancia de GPIO_NPINS
	gpio_npins gpio_npins_inst (
		.clk(clk),
		.reset(reset),
		.data_in(data_in),
		.dir_in(dir_in),
		.gpio_pins(gpio_pins),
		.gpio_pins_out(gpio_pins_out_npins)
	);

    // Instancia de GPIO_SPINS para manejar pines protegidos y funciones especiales
    gpio_spins gpio_spins_inst (
        .data_in(data_in),
        .gpio_pins_in(gpio_pins_out_npins),
        .EN_PWM_OUTA0(EN_PWM_OUTA0),
        .EN_PWM_OUTB0(EN_PWM_OUTB0),
        .EN_TMR_IN0(EN_TMR_IN0),
        .EN_I2C(EN_I2C),
        .EN_SPI(EN_SPI),
        .EN_UART(EN_UART),
        .gpio_pins_out(gpio_pins_out_internal)
    );

    // Asignación de señales de salida
    assign gpio_data_out = gpio_data_out_internal;
    assign gpio_pins_out = gpio_pins_out_internal;

endmodule

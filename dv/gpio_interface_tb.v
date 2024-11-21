`timescale 1ns/1ps

module gpio_interface_tb;

    // Parámetros
    reg clk;
    reg reset;
    reg [15:0] data_in;
    reg [15:0] dir_in;
    reg [31:0] interrupt_mask;
    reg [15:0] pinchange_msk;
    reg write_data_enable;
    reg write_dir_enable;
    reg [15:0] gpio_pins;
    reg [1:0] int0_msk;
    reg [1:0] int1_msk;
    reg EN_PWM_OUTA0;
    reg EN_PWM_OUTB0;
    reg EN_TMR_IN0;
    reg EN_I2C;
    reg EN_SPI;
    reg EN_UART;

    wire [15:0] gpio_data_in;
    wire [15:0] gpio_data_out;
    wire [15:0] gpio_pins_out;
    wire irq_int0;
    wire irq_int1;
    wire irq_pinchange;

    // Instancia del módulo bajo prueba (DUT)
    gpio_interface uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .dir_in(dir_in),
        .interrupt_mask(interrupt_mask),
        .pinchange_msk(pinchange_msk),
        .write_data_enable(write_data_enable),
        .write_dir_enable(write_dir_enable),
        .gpio_pins(gpio_pins),
        .int0_msk(int0_msk),
        .int1_msk(int1_msk),
        .EN_PWM_OUTA0(EN_PWM_OUTA0),
        .EN_PWM_OUTB0(EN_PWM_OUTB0),
        .EN_TMR_IN0(EN_TMR_IN0),
        .EN_I2C(EN_I2C),
        .EN_SPI(EN_SPI),
        .EN_UART(EN_UART),
        .gpio_data_in(gpio_data_in),
        .gpio_data_out(gpio_data_out),
        .gpio_pins_out(gpio_pins_out),
        .irq_int0(irq_int0),
        .irq_int1(irq_int1),
        .irq_pinchange(irq_pinchange)
    );

    // Generación del reloj
    always #5 clk = ~clk; // Periodo de 10 ns

    // Proceso de simulación
    initial begin
        // Inicialización
        $display("Iniciando testbench de gpio_interface...");
        clk = 0;
        reset = 1;
        data_in = 16'b0;
        dir_in = 16'b0;
        interrupt_mask = 32'b0;
        pinchange_msk = 16'b0;
        write_data_enable = 0;
        write_dir_enable = 0;
        gpio_pins = 16'b0;
        int0_msk = 2'b0;
        int1_msk = 2'b0;
        EN_PWM_OUTA0 = 0;
        EN_PWM_OUTB0 = 0;
        EN_TMR_IN0 = 0;
        EN_I2C = 0;
        EN_SPI = 0;
        EN_UART = 0;

        // Liberar reset
        #10 reset = 0;

        // Caso 1: Configuración inicial, todos los pines en entrada
        #10 gpio_pins = 16'b1010101010101010;
        $display("Caso 1: gpio_pins=%b | gpio_data_in=%b | gpio_pins_out=%b", gpio_pins, gpio_data_in, gpio_pins_out);

        // Caso 2: Activar escritura de datos
        #10 write_data_enable = 1;
        data_in = 16'b1111000011110000;
        #10 $display("Caso 2: gpio_pins=%b | data_in=%b | gpio_data_out=%b", gpio_pins, data_in, gpio_data_out);

        // Caso 3: Probar interrupción por flanco de subida
        #10 interrupt_mask[0] = 1;
        pinchange_msk[14] = 1;
        gpio_pins[14] = 1; // Flanco de subida en pin 14
        #10 gpio_pins[14] = 0; // Flanco de bajada
        #10 $display("Caso 3: gpio_pins=%b | irq_int0=%b | irq_pinchange=%b", gpio_pins, irq_int0, irq_pinchange);

        // Caso 4: Probar interrupción por flanco de bajada
        pinchange_msk[15] = 1; // Activar máscara para flanco de bajada
        gpio_pins[15] = 1; // Inicializar con valor alto
        #10 gpio_pins[15] = 0; // Flanco de bajada en pin 15
        #10 $display("Caso 4: gpio_pins=%b | irq_int1=%b | irq_pinchange=%b", gpio_pins, irq_int1, irq_pinchange);

        // Caso 5: Habilitar funciones especiales (SPI)
        #10 EN_SPI = 1;
        data_in = 16'b0000000011110000;
        #10 $display("Caso 5: gpio_pins=%b | EN_SPI=%b | gpio_pins_out=%b", gpio_pins, EN_SPI, gpio_pins_out);

        // Caso 6: Habilitar más funciones especiales (I2C y UART)
        #10 EN_I2C = 1;
        EN_UART = 1;
        data_in = 16'b0000000000110011;
        #10 $display("Caso 6: gpio_pins=%b | EN_I2C=%b | EN_UART=%b | gpio_pins_out=%b", gpio_pins, EN_I2C, EN_UART, gpio_pins_out);

        // Caso 7: Reset
        #10 reset = 1;
        #10 reset = 0;
        $display("Caso 7: Reset activado. gpio_pins_out=%b | gpio_data_in=%b", gpio_pins_out, gpio_data_in);

        // Finalización
        #10 $display("Testbench finalizado correctamente.");
        $finish;
    end

    // Monitor de señales
    initial begin
        $monitor("Time: %0t | reset: %b | gpio_pins: %b | data_in: %b | dir_in: %b | gpio_pins_out: %b | irq_int0: %b | irq_int1: %b | irq_pinchange: %b",
                 $time, reset, gpio_pins, data_in, dir_in, gpio_pins_out, irq_int0, irq_int1, irq_pinchange);
    end

endmodule


`timescale 1ns/1ps

module gpio_spins_tb;

    // Entradas del módulo
    reg [15:0] data_in;
    reg [15:0] gpio_pins_in;
    reg EN_PWM_OUTA0, EN_PWM_OUTB0, EN_TMR_IN0, EN_I2C, EN_SPI, EN_UART;

    // Salida del módulo
    wire [15:0] gpio_pins_out;

    // Variable para rastrear el número del caso
    integer caso_actual;

    // Instancia del módulo bajo prueba (DUT)
    gpio_spins uut (
        .data_in(data_in),
        .gpio_pins_in(gpio_pins_in),
        .EN_PWM_OUTA0(EN_PWM_OUTA0),
        .EN_PWM_OUTB0(EN_PWM_OUTB0),
        .EN_TMR_IN0(EN_TMR_IN0),
        .EN_I2C(EN_I2C),
        .EN_SPI(EN_SPI),
        .EN_UART(EN_UART),
        .gpio_pins_out(gpio_pins_out)
    );

    // Simulación
    initial begin
        $display("Iniciando testbench de GPIO_SPINS con protección de pines...");
        $display("------------------------------------------------");

        // Inicialización
        caso_actual = 0;
        data_in = 16'b0;
        gpio_pins_in = 16'b0;
        EN_PWM_OUTA0 = 0;
        EN_PWM_OUTB0 = 0;
        EN_TMR_IN0 = 0;
        EN_I2C = 0;
        EN_SPI = 0;
        EN_UART = 0;

        // Caso 1: Sin funciones especiales habilitadas
        caso_actual = 1;
        gpio_pins_in = 16'b1010101010101010;
        #10 $display("Caso %d: Sin funciones especiales | gpio_pins_in=%b | gpio_pins_out=%b", 
                     caso_actual, gpio_pins_in, gpio_pins_out);

        // Caso 2: PWM Output A0 habilitado y protegido
        caso_actual = 2;
        gpio_pins_in = 16'b0000000000000000; // Intento de sobrescribir pin 9
        EN_PWM_OUTA0 = 1;
        data_in[9] = 1; // Valor esperado en pin 9
        #10 $display("Caso %d: PWM Output A0 habilitado | gpio_pins_in=%b | gpio_pins_out=%b (Protegido=%b)", 
                     caso_actual, gpio_pins_in, gpio_pins_out, gpio_pins_out[9] == data_in[9]);

        // Caso 3: SPI habilitado y protegido
        caso_actual = 3;
        gpio_pins_in = 16'b0000000000000000; // Intento de sobrescribir pines 4-7
        EN_PWM_OUTA0 = 0;
        EN_SPI = 1;
        data_in[7:4] = 4'b1010; // Valor esperado en pines 4-7
        #10 $display("Caso %d: SPI habilitado | gpio_pins_in=%b | gpio_pins_out=%b (Protegido=%b)", 
                     caso_actual, gpio_pins_in, gpio_pins_out, gpio_pins_out[7:4] == data_in[7:4]);

        // Caso 4: I2C habilitado y protegido
        caso_actual = 4;
        gpio_pins_in = 16'b0000000000000000; // Intento de sobrescribir pines 2-3
        EN_SPI = 0;
        EN_I2C = 1;
        data_in[3:2] = 2'b11; // Valor esperado en pines 2-3
        #10 $display("Caso %d: I2C habilitado | gpio_pins_in=%b | gpio_pins_out=%b (Protegido=%b)", 
                     caso_actual, gpio_pins_in, gpio_pins_out, gpio_pins_out[3:2] == data_in[3:2]);

        // Caso 5: UART habilitado y protegido
        caso_actual = 5;
        gpio_pins_in = 16'b0000000000000000; // Intento de sobrescribir pines 0-1
        EN_I2C = 0;
        EN_UART = 1;
        data_in[1:0] = 2'b10; // Valor esperado en pines 0-1
        #10 $display("Caso %d: UART habilitado | gpio_pins_in=%b | gpio_pins_out=%b (Protegido=%b)", 
                     caso_actual, gpio_pins_in, gpio_pins_out, gpio_pins_out[1:0] == data_in[1:0]);

        // Caso 6: Todas las funciones especiales deshabilitadas
        caso_actual = 6;
        gpio_pins_in = 16'b1010101010101010;
        EN_UART = 0;
        data_in = 16'b0;
        #10 $display("Caso %d: Todas las funciones deshabilitadas | gpio_pins_in=%b | gpio_pins_out=%b", 
                     caso_actual, gpio_pins_in, gpio_pins_out);

        $display("------------------------------------------------");
        $display("Testbench finalizado correctamente.");
        $finish;
    end

endmodule

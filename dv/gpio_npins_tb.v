`timescale 1ns/1ps

module gpio_npins_tb;

    // Parámetros
    reg clk;
    reg reset;
    reg [15:0] data_in;
    reg [15:0] dir_in;
    reg [15:0] gpio_pins;
    wire [15:0] gpio_pins_out;

    // Instancia del módulo bajo prueba (DUT)
    gpio_npins uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .dir_in(dir_in),
        .gpio_pins(gpio_pins),
        .gpio_pins_out(gpio_pins_out)
    );

    // Generación de reloj
    always #5 clk = ~clk; // Periodo de 10 ns

    // Proceso de simulación
    initial begin
        // Inicialización
        $display("Iniciando testbench de gpio_npins...");
        clk = 0;
        reset = 1;
        data_in = 16'b0;
        dir_in = 16'b0;
        gpio_pins = 16'b0;

        // Liberar reset
        #10 reset = 0;

        // Caso 1: Todos los pines en entrada (dir_in = 0)
        #10 gpio_pins = 16'b1010101010101010;
        #10 $display("Caso 1: gpio_pins=%b | gpio_pins_out=%b", gpio_pins, gpio_pins_out);

        // Caso 2: Algunos pines configurados como salida (dir_in = 1 en ciertos bits)
        #10 dir_in = 16'b1111000011110000;
        data_in = 16'b0101010101010101;
        #10 $display("Caso 2: gpio_pins=%b | dir_in=%b | data_in=%b | gpio_pins_out=%b", gpio_pins, dir_in, data_in, gpio_pins_out);

        // Caso 3: Todos los pines configurados como salida
        #10 dir_in = 16'b1111111111111111;
        data_in = 16'b1100110011001100;
        #10 $display("Caso 3: gpio_pins=%b | dir_in=%b | data_in=%b | gpio_pins_out=%b", gpio_pins, dir_in, data_in, gpio_pins_out);

        // Caso 4: Cambiar los valores de `data_in` para pines configurados como salida
        #10 data_in = 16'b1111111100000000;
        #10 $display("Caso 4: gpio_pins=%b | dir_in=%b | data_in=%b | gpio_pins_out=%b", gpio_pins, dir_in, data_in, gpio_pins_out);

        // Caso 5: Resetear el módulo
        #10 reset = 1;
        #10 reset = 0;
        #10 $display("Caso 5: Reset activado. gpio_pins=%b | gpio_pins_out=%b", gpio_pins, gpio_pins_out);

        // Finalización
        #10 $display("Testbench finalizado correctamente.");
        $finish;
    end

    // Monitor de señales
    initial begin
        $monitor("Time: %0t | reset: %b | gpio_pins: %b | dir_in: %b | data_in: %b | gpio_pins_out: %b",
                 $time, reset, gpio_pins, dir_in, data_in, gpio_pins_out);
    end

endmodule


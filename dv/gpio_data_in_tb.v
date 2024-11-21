`timescale 1ns/1ps

module gpio_data_in_tb;

    // Entradas del módulo
    reg [15:0] gpio_pins;
    reg [15:0] gpio_dir;

    // Salida del módulo
    wire [15:0] gpio_data_in;

    // Instancia del módulo bajo prueba (DUT)
    gpio_data_in uut (
        .gpio_pins(gpio_pins),
        .gpio_dir(gpio_dir),
        .gpio_data_in(gpio_data_in)
    );

    // Simulación
    initial begin
        // Inicialización
        gpio_pins = 16'b0;
        gpio_dir = 16'b0;  // Todos los pines como entrada

        // Caso 1: Todos los pines como entrada
        gpio_pins = 16'b1010_1010_1010_1010;
        #10;
        $display("Time: %0t | gpio_pins: %b | gpio_dir: %b | gpio_data_in: %b", $time, gpio_pins, gpio_dir, gpio_data_in);

        // Caso 2: Algunos pines configurados como salida
        gpio_dir = 16'b0000_1111_0000_1111;  // Los pines 0-3 y 8-11 como salida
        gpio_pins = 16'b1111_0000_1111_0000;
        #10;
        $display("Time: %0t | gpio_pins: %b | gpio_dir: %b | gpio_data_in: %b", $time, gpio_pins, gpio_dir, gpio_data_in);

        // Caso 3: Todos los pines como salida
        gpio_dir = 16'b1111_1111_1111_1111;
        gpio_pins = 16'b0101_0101_0101_0101;
        #10;
        $display("Time: %0t | gpio_pins: %b | gpio_dir: %b | gpio_data_in: %b", $time, gpio_pins, gpio_dir, gpio_data_in);

        // Caso 4: Alternando entrada/salida
        gpio_dir = 16'b1010_1010_1010_1010;
        gpio_pins = 16'b1100_1100_1100_1100;
        #10;
        $display("Time: %0t | gpio_pins: %b | gpio_dir: %b | gpio_data_in: %b", $time, gpio_pins, gpio_dir, gpio_data_in);

        // Fin de la simulación
        #10 $finish;
    end

endmodule

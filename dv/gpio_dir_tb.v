`timescale 1ns/1ps

module gpio_dir_tb;

    // Entradas del módulo
    reg clk;
    reg reset;
    reg write_enable;
    reg [15:0] dir_in;

    // Salida del módulo
    wire [15:0] gpio_dir;

    // Instancia del módulo bajo prueba (DUT)
    gpio_dir uut (
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .dir_in(dir_in),
        .gpio_dir(gpio_dir)
    );

    // Generación de reloj
    always #5 clk = ~clk; // Periodo de 10 ns

    // Simulación
    initial begin
        // Inicialización
        clk = 0;
        reset = 1;
        write_enable = 0;
        dir_in = 16'b0;

        // Liberar reset
        #20 reset = 0;

        // Caso 1: Escritura deshabilitada
        #10 dir_in = 16'b1010_1010_1010_1010;
        #10 $display("Time: %0t | dir_in: %b | write_enable: %b | gpio_dir: %b", $time, dir_in, write_enable, gpio_dir);

        // Caso 2: Escritura habilitada
        #10 write_enable = 1;
        dir_in = 16'b1111_0000_1111_0000;
        #10 $display("Time: %0t | dir_in: %b | write_enable: %b | gpio_dir: %b", $time, dir_in, write_enable, gpio_dir);

        // Caso 3: Cambiar dirección con escritura habilitada
        dir_in = 16'b0000_1111_0000_1111;
        #10 $display("Time: %0t | dir_in: %b | write_enable: %b | gpio_dir: %b", $time, dir_in, write_enable, gpio_dir);

        // Caso 4: Escritura deshabilitada nuevamente
        write_enable = 0;
        dir_in = 16'b0101_0101_0101_0101;
        #10 $display("Time: %0t | dir_in: %b | write_enable: %b | gpio_dir: %b", $time, dir_in, write_enable, gpio_dir);

        // Fin de la simulación
        #20 $finish;
    end

endmodule

`timescale 1ns/1ps

module gpio_data_out_tb;

    // Entradas del módulo
    reg clk;
    reg reset;
    reg write_enable;
    reg [15:0] data_in;

    // Salida del módulo
    wire [15:0] gpio_data_out;

    // Instancia del módulo bajo prueba (DUT)
    gpio_data_out uut (
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .data_in(data_in),
        .gpio_data_out(gpio_data_out)
    );

    // Generación de reloj
    always #5 clk = ~clk; // Periodo de 10 ns

    // Simulación
    initial begin
        // Inicialización
        clk = 0;
        reset = 1;
        write_enable = 0;
        data_in = 16'b0;

        // Liberar reset
        #20 reset = 0;

        // Caso 1: No se habilita escritura
        #10 data_in = 16'b1010_1010_1010_1010;
        #10 $display("Time: %0t | data_in: %b | write_enable: %b | gpio_data_out: %b", $time, data_in, write_enable, gpio_data_out);

        // Caso 2: Habilitar escritura
        #10 write_enable = 1;
        #10 data_in = 16'b1111_0000_1111_0000;
        #10 $display("Time: %0t | data_in: %b | write_enable: %b | gpio_data_out: %b", $time, data_in, write_enable, gpio_data_out);

        // Caso 3: Cambiar datos con escritura habilitada
        #10 data_in = 16'b0000_1111_0000_1111;
        #10 $display("Time: %0t | data_in: %b | write_enable: %b | gpio_data_out: %b", $time, data_in, write_enable, gpio_data_out);

        // Caso 4: Deshabilitar escritura nuevamente
        #10 write_enable = 0;
        data_in = 16'b0101_0101_0101_0101;
        #10 $display("Time: %0t | data_in: %b | write_enable: %b | gpio_data_out: %b", $time, data_in, write_enable, gpio_data_out);

        // Fin de la simulación
        #20 $finish;
    end

endmodule

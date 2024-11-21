`timescale 1ns/1ps

module gpio_ctrl_tb;

    // Parámetros
    reg clk;
    reg reset;
    reg [31:0] interrupt_mask;
    reg [15:0] pinchange_msk;
    reg [15:0] gpio_pins;
    wire irq_int0;
    wire irq_int1;
    wire irq_pinchange;

    // Instancia del módulo bajo prueba (DUT)
    gpio_ctrl uut (
        .clk(clk),
        .reset(reset),
        .interrupt_mask(interrupt_mask),
        .pinchange_msk(pinchange_msk),
        .gpio_pins(gpio_pins),
        .irq_int0(irq_int0),
        .irq_int1(irq_int1),
        .irq_pinchange(irq_pinchange)
    );

    // Generación del reloj
    always #5 clk = ~clk; // Periodo de 10ns

    // Proceso de simulación
    initial begin
        // Inicialización
        clk = 0;
        reset = 1;
        interrupt_mask = 32'b0;
        pinchange_msk = 16'b0;
        gpio_pins = 16'b0;

        // Liberar reset
        #20 reset = 0;

        // Caso 1: Sin máscara de interrupción, sin cambios en los pines
        #20 gpio_pins = 16'b0; // No debería haber interrupciones

        // Caso 2: Activar máscara para pin 14 (INT0) y simular flanco de subida
        interrupt_mask[0] = 1;  // Activar máscara para INT0
        pinchange_msk[14] = 1;  // Activar detección de cambios para pin 14
        #10 gpio_pins[14] = 1;  // Flanco de subida en pin 14
        #10 gpio_pins[14] = 0;  // Flanco de bajada en pin 14

        // Caso 3: Activar máscara para pin 15 (INT1) y simular flanco de bajada
        interrupt_mask[1] = 1;  // Activar máscara para INT1
        pinchange_msk[15] = 1;  // Activar detección de cambios para pin 15
        #10 gpio_pins[15] = 1;  // Flanco de subida en pin 15
        #10 gpio_pins[15] = 0;  // Flanco de bajada en pin 15

        // Caso 4: Cambios múltiples en otros pines
        pinchange_msk = 16'b1111_1111_1111_1111; // Detectar cambios en todos los pines
        #10 gpio_pins = 16'b1010_1010_1010_1010; // Cambios en varios pines
        #10 gpio_pins = 16'b0101_0101_0101_0101; // Cambios inversos

        // Fin de la simulación
        #50 $finish;
    end

    // Monitor de señales
    initial begin
        $monitor("Time: %0t | reset: %b | gpio_pins: %b | irq_int0: %b | irq_int1: %b | irq_pinchange: %b",
                 $time, reset, gpio_pins, irq_int0, irq_int1, irq_pinchange);
    end
endmodule

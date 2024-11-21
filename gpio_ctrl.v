module gpio_ctrl (
    input wire clk,
    input wire reset,
    input wire [31:0] interrupt_mask,
    input wire [15:0] pinchange_msk,
    input wire [15:0] gpio_pins,        // Entradas asíncronas
    output reg irq_int0,
    output reg irq_int1,
    output reg irq_pinchange
);

    // Registros internos para sincronización
    reg [15:0] gpio_pins_sync1;
    reg [15:0] gpio_pins_sync2;
    reg [15:0] previous_gpio_pins;

    // Pipeline para cálculo de cambios
    reg [15:0] rising_edge_stage1, rising_edge_stage2;
    reg [15:0] falling_edge_stage1, falling_edge_stage2;

    // Sincronización de entradas
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gpio_pins_sync1 <= 16'b0;
            gpio_pins_sync2 <= 16'b0;
            previous_gpio_pins <= 16'b0;
        end else begin
            gpio_pins_sync1 <= gpio_pins;
            gpio_pins_sync2 <= gpio_pins_sync1;
            previous_gpio_pins <= gpio_pins_sync2;
        end
    end

    // Pipeline para rising y falling edge
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rising_edge_stage1 <= 16'b0;
            rising_edge_stage2 <= 16'b0;
            falling_edge_stage1 <= 16'b0;
            falling_edge_stage2 <= 16'b0;
        end else begin
            rising_edge_stage1 <= (gpio_pins_sync2 & ~previous_gpio_pins) & pinchange_msk;
            rising_edge_stage2 <= rising_edge_stage1;

            falling_edge_stage1 <= (~gpio_pins_sync2 & previous_gpio_pins) & pinchange_msk;
            falling_edge_stage2 <= falling_edge_stage1;
        end
    end

    // Actualización de irq_pinchange
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            irq_pinchange <= 0;
        end else begin
            irq_pinchange <= |(rising_edge_stage2 | falling_edge_stage2);
        end
    end

    // Manejo de INT0 e INT1
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            irq_int0 <= 0;
            irq_int1 <= 0;
        end else begin
            // INT0: Flanco de subida en pin 14
            irq_int0 <= interrupt_mask[0] && gpio_pins_sync2[14] && !previous_gpio_pins[14];
            // INT1: Flanco de subida en pin 15
            irq_int1 <= interrupt_mask[1] && gpio_pins_sync2[15] && !previous_gpio_pins[15];
        end
    end

endmodule

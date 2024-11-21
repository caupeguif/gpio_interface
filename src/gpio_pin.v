module gpio_pin (
    input wire clk,
    input wire reset,
    input wire data_in,
    input wire dir_in,
    input wire gpio_pin,
    output reg gpio_pin_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gpio_pin_out <= 1'b0;
        end else begin
            if (dir_in) begin
                // Pin configurado como salida
                gpio_pin_out <= data_in;
            end else begin
                // Pin configurado como entrada
                gpio_pin_out <= gpio_pin;
            end
        end
    end

endmodule

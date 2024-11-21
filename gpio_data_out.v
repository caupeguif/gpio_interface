module gpio_data_out (
    input wire clk,
    input wire reset,
    input wire write_enable,
    input wire [15:0] data_in,
    output reg [15:0] gpio_data_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gpio_data_out <= 16'b0;
        end else if (write_enable) begin
            gpio_data_out <= data_in;
        end
    end

endmodule

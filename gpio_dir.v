module gpio_dir (
    input wire clk,
    input wire reset,
    input wire [15:0] dir_in,
    input wire write_enable,
    output reg [15:0] gpio_dir
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gpio_dir <= 16'b0;
        end else if (write_enable) begin
            gpio_dir <= dir_in;
        end
    end

endmodule

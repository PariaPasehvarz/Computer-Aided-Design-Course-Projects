`timescale 1ps/1ps
module output_ram(
    input clk,
    input write_en,
    input write_file,
    input [2:0] write_address,
    input [31:0] input_data
);

    // 8 rows of 32-bit data
    reg [31:0] memory [7:0];

    // Write data to memory
    always @(posedge clk) begin
        if (write_en) begin
            memory[write_address] <= input_data;
        end
    end

    integer i; // for file write
    integer file;
    always @(posedge clk) begin
        if (write_file) begin
            file = $fopen("./file/output.txt", "w");

            for (i = 0; i < 8; i = i + 1) begin
                $fwrite(file, "%H\n", memory[i]);
            end
            $fclose(file);
        end
    end

endmodule
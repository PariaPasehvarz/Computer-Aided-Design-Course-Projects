module buffer #(
    parameter ROW_SIZE = 8,        
    parameter COLUMNS = 32,        
    parameter PAR_WRITE = 4,      
    parameter PAR_READ = 4        
)(
    input wire clk,              
    input wire rst,              
    input wire wen,               
    input wire [(PAR_WRITE*$clog2(COLUMNS))-1:0] waddr,
    input wire [(ROW_SIZE*PAR_WRITE)-1:0] din,
    input wire [(PAR_READ*$clog2(COLUMNS))-1:0] raddr,
    output wire [(ROW_SIZE*PAR_READ)-1:0] dout
);


    reg [ROW_SIZE - 1:0] buffer_mem [COLUMNS-1:0];

    integer i;
    integer file_index = 0;
    integer file;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < COLUMNS; i = i + 1) begin
                buffer_mem[i] <= {ROW_SIZE{1'b0}};
            end
        end else if (wen) begin
            file = $fopen("./file/buffer.txt", file_index == 0 ? "w" : "a"); //for debugging
            $fwrite(file, "write step : %d\n", file_index);

            for (i = 0; i < PAR_WRITE; i = i + 1) begin
                buffer_mem[waddr[i*$clog2(COLUMNS) +: $clog2(COLUMNS)]] = //NOTE & TODO: should be <=, = is used for fwrite
                    din[i*ROW_SIZE +: ROW_SIZE];
                $fwrite(file, "buffer_mem index to be written to: %b, all waddr: %b\n", waddr[i*$clog2(COLUMNS) +: $clog2(COLUMNS)], waddr);
                $fwrite(file, "din value to be written: %b, all din: %b\n", din[i*ROW_SIZE +: ROW_SIZE], din);
            end
            $fwrite(file, "\n");           
            for (i = 0; i < COLUMNS; i = i + 1) begin
                $fwrite(file, "%b \n", buffer_mem[i]);
            end
            $fwrite(file, "\n");
            $fclose(file);
            file_index = file_index + 1;
        end
    end

    genvar j;
    generate
        for (j = 0; j < PAR_READ; j = j + 1) begin
            assign dout[j*ROW_SIZE +: ROW_SIZE] = 
                buffer_mem[raddr[j*$clog2(COLUMNS) +: $clog2(COLUMNS)]];
        end
    endgenerate

endmodule

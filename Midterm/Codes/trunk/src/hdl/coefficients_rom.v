`timescale 1ps/1ps

module coefficients_rom (    
    output reg [127:0] memory 
);
    initial begin
        memory = {
            16'b0000_0000_0000_0000,    // 1
            16'b0100_0000_0000_0000,    // 1/2
            16'b0010_1010_1011_1011,    // 1/3
            16'b0010_0000_0000_0000,    // 1/4  
            16'b0001_1001_1001_1010,    // 1/5
            16'b0001_0101_0100_0101,    // 1/6
            16'b0001_0010_0100_1001,    // 1/7
            16'b0001_0000_0000_0000     // 1/8
        };
    end

endmodule


`define HALF_CLK 5
`define CLK (2*`HALF_CLK)

module circular_buffer_tb();

    parameter ROW_SIZE = 8;
    parameter COLUMNS = 16;
    parameter PAR_WRITE = 2;
    parameter PAR_READ = 4;

    reg clk;
    reg rst;
    reg read_enable;
    reg write_enable;
    reg [(ROW_SIZE*PAR_WRITE)-1:0] din;
    wire [(ROW_SIZE*PAR_READ)-1:0] dout;
    wire valid;
    wire ready;
    wire full;
    wire empty;

    integer file;

    initial begin
        clk = 0;
        forever #`CLK clk = ~clk;
    end
    task automatic read_data;
        begin
            read_enable = 1;
            #(`CLK * 2);
            #`HALF_CLK;

            if(valid) begin
                $fwrite(file, "\nwhile read: empty=%b full=%b dout=%b\n", empty, full, dout);
                #(`CLK * 3); //reading for a few cycles
            end else begin
                $fwrite(file, "\nunable to read, valid is not issued empty=%b full=%b dout=%b\n", empty, full, dout);
            end
            #`CLK;
            read_enable = 0;

            #(`CLK * 5);
        end
    endtask


    task automatic write_data(input [(ROW_SIZE*PAR_WRITE)-1:0] data);
        begin
            din = data;
            write_enable = 1;
            #(`CLK * 2);
            #`HALF_CLK;

            if(ready) begin
                $fwrite(file, "\nAfter write: empty=%b full=%b dout=%b\n", empty, full, dout);
            end else begin
                $fwrite(file, "\nunable to write, ready is not issued empty=%b full=%b dout=%b\n", empty, full, dout, valid);
            end
            #`CLK;
            write_enable = 0;

            #(`CLK * 5);
        end
    endtask

    circular_buffer #(
        .ROW_SIZE(ROW_SIZE),
        .COLUMNS(COLUMNS),
        .PAR_WRITE(PAR_WRITE),
        .PAR_READ(PAR_READ)
    ) CircularBuffer (
        .clk(clk),
        .rst(rst),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .din(din),
        .dout(dout),
        .valid(valid),
        .ready(ready),
        .full(full),
        .empty(empty)
    );
    integer i;

    initial begin
        file = $fopen("./file/simulation_results.txt", "w");

        rst = 1;
        read_enable = 0;
        din = 0;
        write_enable = 0;
        #`CLK;
        #`CLK rst = 0;

        $fwrite(file,"parameters: ROW_SIZE=%d COLUMNS=%d PAR_WRITE=%d PAR_READ=%d\n", ROW_SIZE, COLUMNS, PAR_WRITE, PAR_READ);
        $fwrite(file,"\n0: read data when buffer is empty\n");
        read_data();
        
        $fwrite(file, "1: write data once\n");
        write_data({8'd12, 8'd13});

        $fwrite(file, "\n2: read data once\n");
        read_data();

        $fwrite(file, "\n3: write data once again\n");
        write_data({8'd14, 8'd15});

        $fwrite(file, "\n4: read data once\n");
        read_data();
        
        //here WP == RP, trying to write 9 times (9th should fail)
        $fwrite(file, "\n5: write data 9 times\n");

        for (i = 0; i < 9; i = i + 1) begin
            write_data({8'd16 + i, 8'd17 + i});
        end

        #100;
        $fwrite(file, "\nSimulation completed\n");
        $fclose(file);
        $stop;
    end


endmodule 
module controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire overflow,
    input wire error,
    input wire [2:0] N_input,
    output wire load_N,
    output wire load_X,
    output wire load_registers,
    output wire ready,
    output reg valid
);

    localparam [1:0] 
        IDLE = 2'b00,
        INIT = 2'b01,
        LOAD = 2'b10,
        CALC = 2'b11;

    reg [1:0] current_state, next_state;
    reg [3:0] calc_counter;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE: begin
                if (start)
                    next_state = INIT;
                else
                    next_state = IDLE;
            end
            INIT: begin
                if (start)
                    next_state = INIT;
                else
                    next_state = LOAD;
            end
            LOAD: begin
                next_state = CALC;
            end
            CALC: begin
                if (overflow || error)
                    next_state = IDLE;
                else
                    next_state = CALC;
            end
            
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            calc_counter <= 4'd0;
            valid <= 1'b0;
        end
        else if (current_state != CALC) begin
            calc_counter <= 4'd0;
            valid <= 1'b0;
        end
        else begin
            calc_counter <= calc_counter + 4'd1;
            
            if (N_input <= 4'd4) begin
                // For N <= 4, set valid after 4 cycles and keep it high
                if (calc_counter >= 4'd4)
                    valid <= 1'b1;
            end
            else if (N_input == 4'd5) begin
                // For N = 5:
                // First enable: counter 5->7
                // Then enable: counter 12->14
                if ((calc_counter >= 4'd5 && calc_counter <= 4'd7) ||
                    (calc_counter >= 4'd12 && calc_counter <= 4'd14)) begin
                    valid <= 1'b1;
                end
                else begin
                    valid <= 1'b0;
                end
            end
            else if (N_input == 4'd6) begin
                // For N = 6:
                // First enable: counter 6->8 (becomes 0 at 9)
                // Then enable: counter 13->15 (becomes 0 at 16)
                if ((calc_counter >= 4'd6 && calc_counter < 4'd9) ||
                    (calc_counter >= 4'd13 && calc_counter < 4'd0)) begin
                    valid <= 1'b1;
                end
                else begin
                    valid <= 1'b0;
                end
            end
            else if (N_input == 4'd7) begin
                // For N = 7:
                // First enable: counter 7->9 (becomes 0 at 10)
                // Then enable: counter 14->16 (becomes 0 at 17/1)
                if ((calc_counter >= 4'd7 && calc_counter < 4'd10) ||
                    (calc_counter >= 4'd14 && calc_counter < 4'd1)) begin
                    valid <= 1'b1;
                end
                else begin
                    valid <= 1'b0;
                end
            end
            else begin
                // For N > 7, keep original behavior
                if (calc_counter >= 4'd8) begin
                    valid <= !calc_counter[2];
                end
                else begin
                    valid <= 1'b0;
                end
            end
        end
    end

    assign load_N = (current_state == LOAD);
    assign load_X = (current_state == CALC && !overflow && !error);
    assign load_registers = (current_state == CALC && !overflow && !error);
    assign ready = (current_state == IDLE) || (current_state == INIT) || (current_state == LOAD) ||
                  (current_state == CALC && (
                    (N_input <= 4'd4) ||  // Always ready for N <= 4
                    (calc_counter[2] == 1'b0)  // For N > 4: ready when counter[2] = 0 (first 4 cycles of every 8)
                  ));

endmodule

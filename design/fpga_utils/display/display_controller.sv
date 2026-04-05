module multi_digit_display (
    input wire clk,
    input wire [15:0] number,  
    output reg [3:0] anode,
    output wire [6:0] segments
);

    reg [19:0] refresh_counter = 0;
    
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end
    
    wire [1:0] active_digit = refresh_counter[19:18]; 
    reg [3:0] current_hex_val;
    
    always @(*) begin
        case(active_digit)
            2'b00: current_hex_val = number[3:0];
            2'b01: current_hex_val = number[7:4];
            2'b10: current_hex_val = number[11:8];
            2'b11: current_hex_val = number[15:12];
        endcase
    end

    always @(*) begin
        case(active_digit)
            2'b00: anode = 4'b1110;
            2'b01: anode = 4'b1101;
            2'b10: anode = 4'b1011;
            2'b11: anode = 4'b0111;
        endcase
    end

    hex_to_7seg decoder (
        .hex_in(current_hex_val),
        .seg_out(segments)
    );

endmodule






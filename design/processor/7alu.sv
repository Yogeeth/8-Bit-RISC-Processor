module alu (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [1:0] alu_op,
    output reg [7:0] result,
    output wire g,
    output wire l,
    output wire z
);

    always @(*) begin
        case (alu_op)
            2'b00: result = a + b; 
            2'b01: result = a - b; 
            2'b10: result = a;   
            default: result = 8'b0101_0101;
        endcase
    end

    // Flags
    assign z = (a == b) ? 1'b1 : 1'b0; 
    assign g = (a > b)  ? 1'b1 : 1'b0; 
    assign l = (a < b)  ? 1'b1 : 1'b0; 

endmodule
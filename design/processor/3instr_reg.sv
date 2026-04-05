module instr_reg (
    input wire clk,
    input wire rst,
    input wire ir_write,
    input wire [15:0] ir_in,
    output reg [15:0] ir_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ir_out <= 16'b0000_0000_0000_0000;
        end else if (ir_write) begin
            ir_out <= ir_in;
        end
    end

endmodule
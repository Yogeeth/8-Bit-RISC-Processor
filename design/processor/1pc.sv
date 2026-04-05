module pc (
    input wire clk,
    input wire rst,
    input wire pc_write,
    output reg [7:0] pc_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out <= 8'b0000_0000;
        end else if (pc_write) begin
            pc_out <= pc_out + 1'b1;
        end
    end
endmodule
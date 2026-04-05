module reg_file (
    input wire clk,
    input wire rst,
    input wire reg_write,
    input wire [2:0] rd_addr1,
    input wire [2:0] rd_addr2,
    input wire [2:0] rd_addr3,
    input wire [2:0] wr_addr,
    input wire [7:0] wr_data,
    output wire [7:0] rd_data1,
    output wire [7:0] rd_data2,
    output wire [7:0] rd_data3
);

    
    reg [7:0] registers [0:7];
    integer i;

    // asynchronous read 
    assign rd_data1 = registers[rd_addr1];
    assign rd_data2 = registers[rd_addr2];
    assign rd_data3 = registers[rd_addr3];

    // synchronous write
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            
            for (i = 0; i < 8; i = i + 1) begin
                registers[i] <= 8'b0000_0000;
            end
        end else if (reg_write) begin
            registers[wr_addr] <= wr_data;
        end
    end

endmodule
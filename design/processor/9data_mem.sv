module data_mem (
    input wire clk,
    input wire rst,
    input wire mem_read,
    input wire mem_write,
    input wire [8:0] addr,
    input wire [7:0] write_data,
    output reg [7:0] read_data
);

    
    reg [7:0] memory [0:511];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            
            // can be added in initial block
            for (i = 0; i < 512; i = i + 1) begin
                if (i == 10) begin          
                    memory[i] <= 8'h5;    // addr = 10
                end else if (i == 11) begin 
                    memory[i] <= 8'h3;    // addr = 3
                end else begin
                    memory[i] <= 8'h00;    
                end
            end
            read_data <= 8'b0000_0000;
        end else begin
            if (mem_write) begin
                memory[addr] <= write_data; // store
            end
            if (mem_read) begin
                read_data <= memory[addr];  // load
            end
        end
    end
    
    
    

endmodule
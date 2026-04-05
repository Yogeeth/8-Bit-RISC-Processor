module datapath (
    input wire clk,
    input wire rst,
    input wire ack_btn, // external button input (for out instructions) add for cmp instructions also
    
    output wire halt,
    output reg flag_g,
    output reg flag_l,
    output reg flag_z,
    output reg [7:0] out_port 
);

    // internal wires
    wire [1:0] alu_op;
    wire flag_write, imem_read, ir_write, mem_read;
    wire mem_write, mul_en, pc_write, reg_write, out_write;
    wire [1:0] wb_sel;
    
    wire [7:0] pc_out;
    wire [15:0] instr_wire;
    wire [15:0] ir_out;
    
    wire [3:0] opcode;
    wire [2:0] rd, rs1, rs2, reg_m;
    wire [8:0] mem_addr;
    
    wire [7:0] rd_data1, rd_data2, rd_data3;
    reg  [7:0] wb_data; 
    
    wire [7:0] alu_result, mul_result;
    wire alu_g, alu_l, alu_z;
    wire [7:0] mem_read_data;

    // module Instantiations
    pc u_pc (.clk(clk), .rst(rst), .pc_write(pc_write), .pc_out(pc_out));
    instr_mem u_instr_mem (.clk(clk), .imem_read(imem_read), .addr(pc_out), .instr(instr_wire));
    instr_reg u_instr_reg (.clk(clk), .rst(rst), .ir_write(ir_write), .ir_in(instr_wire), .ir_out(ir_out));
    instr_decoder u_instr_decoder (.instr(ir_out), .opcode(opcode), .rd(rd), .rs1(rs1), .rs2(rs2), .reg_m(reg_m), .mem_addr(mem_addr));
    
    control_unit u_control_unit (
        .clk(clk), .rst(rst), .opcode(opcode), .flag_g(flag_g), .flag_l(flag_l), .flag_z(flag_z),
        .ack_btn(ack_btn),
        .alu_op(alu_op), .flag_write(flag_write), .halt(halt), .imem_read(imem_read),
        .ir_write(ir_write), .mem_read(mem_read), .mem_write(mem_write), .mul_en(mul_en),
        .pc_write(pc_write), .reg_write(reg_write), .out_write(out_write), .wb_sel(wb_sel)
    );

    reg_file u_reg_file (
        .clk(clk), .rst(rst), .reg_write(reg_write), .rd_addr1(rs1), .rd_addr2(rs2),
        .rd_addr3(reg_m), .wr_addr(rd), .wr_data(wb_data), .rd_data1(rd_data1),
        .rd_data2(rd_data2), .rd_data3(rd_data3)
    );

    alu u_alu (.a(rd_data1), .b(rd_data2), .alu_op(alu_op), .result(alu_result), .g(alu_g), .l(alu_l), .z(alu_z));
    multiplier u_multiplier (.a(rd_data1), .b(rd_data2), .result(mul_result));
    data_mem u_data_mem (.clk(clk), .rst(rst), .mem_read(mem_read), .mem_write(mem_write), .addr(mem_addr), .write_data(rd_data3), .read_data(mem_read_data));

    // write-back multiplexer
    always @(*) begin
        case (wb_sel)
            2'b00: wb_data = alu_result;
            2'b01: wb_data = mul_result;
            2'b10: wb_data = mem_read_data;
            default: wb_data = 8'b0000_0000;
        endcase
    end

    // flag register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            flag_g <= 1'b0;
            flag_l <= 1'b0;
            flag_z <= 1'b0;
        end else if (flag_write) begin
            flag_g <= alu_g;
            flag_l <= alu_l;
            flag_z <= alu_z;
        end
    end

    // external output port logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_port <= 8'b0000_0000;
        end else if (out_write) begin
            out_port <= wb_data; 
        end
    end

endmodule
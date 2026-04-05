module fpga_top (
    input wire clk, 
    input wire btn_rst,    
    input wire btn_ack,    
    output wire [3:0] anode,
    output wire [6:0] segments,
    output wire halt_sig,
    output flag_g, flag_l, flag_z
);

    wire pulse_rst;
    wire pulse_ack;
   
    wire [7:0] processor_output; 

    // pulse generators
    button_pulse rst_pulse_gen (
        .clk(clk_100mhz),
        .btn_in(btn_rst),
        .btn_pulse(pulse_rst)
    );

    button_pulse ack_pulse_gen (
        .clk(clk_100mhz),
        .btn_in(btn_ack),
        .btn_pulse(pulse_ack)
    );

    // processor
    datapath my_processor (
        .clk(clk_100mhz),
        .rst(pulse_rst),       
        .ack_btn(pulse_ack),   
        .halt(halt_sig),
        .flag_g(flag_g),
        .flag_l(flag_l),
        .flag_z(flag_z),
        .out_port(processor_output) // catch the output internally,
        
    );

    // the 7-segment display 
    multi_digit_display display_controller ( 
        .clk(clk_100mhz),
        // pad the 8-bit processor output with 8 zeros to make 16 bits
        .number({8'h00, processor_output}), 
        .anode(anode),
        .segments(segments)
    );

endmodule
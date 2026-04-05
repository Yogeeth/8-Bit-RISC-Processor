module button_pulse (
    input wire clk,
    input wire btn_in,
    output wire btn_pulse
);
    reg sync_1 = 0;
    reg sync_2 = 0;
    reg delay  = 0;

    always @(posedge clk) begin
        sync_1 <= btn_in; // catch the raw button
        sync_2 <= sync_1; // stabilize it to the clock domain
        delay  <= sync_2; // keep track of what the button was 1 cycle ago
    end

    assign btn_pulse = sync_2 & ~delay; 

endmodule
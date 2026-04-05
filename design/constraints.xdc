// For boolean board
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {clk}]

set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {btn_rst}]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {btn_ack}]


set_property -dict {PACKAGE_PIN H3 IOSTANDARD LVCMOS33} [get_ports {anode[0]}]
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports {anode[1]}]
set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS33} [get_ports {anode[2]}]
set_property -dict {PACKAGE_PIN E4 IOSTANDARD LVCMOS33} [get_ports {anode[3]}]


set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS33} [get_ports {segments[0]}] ; # a
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {segments[1]}] ; # b
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports {segments[2]}] ; # c
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports {segments[3]}] ; # d
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {segments[4]}] ; # e
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {segments[5]}] ; # f
set_property -dict {PACKAGE_PIN D1 IOSTANDARD LVCMOS33} [get_ports {segments[6]}] ; # g


set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {flag_g}] ; # LED 0: Greater
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {flag_l}] ; # LED 1: Lesser
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {flag_z}] ; # LED 2: Zero

# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

hdi::project new -name test_dualport -dir "C:/Users/kjones/Desktop/DUAL_PORT_VGA_V3/dualporttst/XSA/3S1000/test_dualport/planAhead_run_1"
hdi::project setArch -name test_dualport -arch spartan3
hdi::design setOptions -project test_dualport -top test_dualport  
hdi::param set -name project.paUcfFile -svalue "test_dualport.ucf"
hdi::floorplan new -name floorplan_1 -part xc3s1000ft256-4 -project test_dualport
hdi::port import -project test_dualport \
    -vhdl {../../../XS_LIB/common.vhd work} \
    -vhdl {../../../XS_LIB/sdramcntl.vhd work} \
    -vhdl {../../XSA_LIB/xsasdramcntl.vhd work} \
    -vhdl {../../XSA_LIB/vga.vhd work} \
    -vhdl {../../XSA_LIB/test_dualport_core.vhd work} \
    -vhdl {test_dualport.vhd work}
hdi::port export -project test_dualport -file test_dualport_pa_ports.v -format verilog
hdi::pconst import -project test_dualport -floorplan floorplan_1 -file "test_dualport.ucf"

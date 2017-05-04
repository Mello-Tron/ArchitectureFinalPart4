
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

hdi::project new -name test_dualport -dir "C:/Users/kjones/Desktop/DUAL_PORT_VGA_V3/dualporttst/XSA/3S1000/test_dualport/planAhead_run_1"
hdi::project setArch -name test_dualport -arch spartan3
hdi::design setOptions -project test_dualport -top netlist_1_EMPTY
hdi::param set -name project.paUcfFile -svalue "test_dualport.ucf"
hdi::floorplan new -name floorplan_1 -part xc3s1000ft256-4 -project test_dualport
hdi::port import -project test_dualport -verilog {test_dualport_pa_ports.v work}
hdi::pconst import -project test_dualport -floorplan floorplan_1 -file "test_dualport.ucf"

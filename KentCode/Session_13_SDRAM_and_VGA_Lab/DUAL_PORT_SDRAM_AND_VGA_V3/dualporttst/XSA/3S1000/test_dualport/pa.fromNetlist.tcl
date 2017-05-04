
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

hdi::project new -name test_dualport -dir "C:/Users/kjones/Desktop/dualporttst-1_1/dualporttst/XSA/3S1000/test_dualport/planAhead_run_1" -netlist "C:/Users/kjones/Desktop/dualporttst-1_1/dualporttst/XSA/3S1000/test_dualport/test_dualport.ngc" -search_path { {C:/Users/kjones/Desktop/dualporttst-1_1/dualporttst/XSA/3S1000/test_dualport} }
hdi::project setArch -name test_dualport -arch spartan3
hdi::param set -name project.paUcfFile -svalue "test_dualport.ucf"
hdi::floorplan new -name floorplan_1 -part xc3s1000ft256-4 -project test_dualport
hdi::pconst import -project test_dualport -floorplan floorplan_1 -file "test_dualport.ucf"

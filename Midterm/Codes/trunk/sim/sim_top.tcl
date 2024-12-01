alias clc ".main clear"

clc
exec vlib work
vmap work work

# Define paths for your testbench (TB) and HDL files
set TB                   "testbench"
#set hdl_path             "E:/cad/CA1-trunk/src/hdl"
#set inc_path             "E:/cad/CA1-trunk/src/inc"
set hdl_path             "../src/hdl"
set inc_path             "../src/inc"

# Set simulation run time
set run_time             "100 us"
# set run_time           "-all"

#============================ Add verilog files  ===============================
# Please add other module here	
vlog    +acc -incr -source  +define+SIM     $hdl_path/coefficients_rom.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/controller.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/datapath.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/error_detector.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/maclauren.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/multiplier.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/overflow_detector.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/register.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/stage.v

#vlog    +acc -incr -source  +incdir+$inc_path +define+SIM    E:/cad/CA1-trunk/sim/tb/$TB.v
vlog    +acc -incr -source  +incdir+$inc_path +define+SIM    ./tb/$TB.v
onerror {break}

#================================ Simulation ====================================
vsim    -voptargs=+acc -debugDB $TB

#======================= Adding signals to the wave window =====================
add wave -hex -group        {TB}               sim:/$TB/*
add wave -hex -group        {top}              sim:/$TB/uut/*    
add wave -hex -group -r     {all}              sim:/$TB/*

#=========================== Configure wave signals =============================
configure wave -signalnamewidth 2

#================================= Run Simulation ===============================
run $run_time

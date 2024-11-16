alias clc ".main clear"

clc
exec vlib work
vmap work work

# Define paths for your testbench (TB) and HDL files
set TB                   "tb"
#set hdl_path             "E:/cad/CA1-trunk/src/hdl"
#set inc_path             "E:/cad/CA1-trunk/src/inc"
set hdl_path             "../src/hdl"
set inc_path             "../src/inc"

# Set simulation run time
set run_time             "100 us"
# set run_time           "-all"

#============================ Add verilog files  ===============================
# Please add other module here	
vlog    +acc -incr -source  +define+SIM     $hdl_path/adder.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/appr_multiplier.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/controller.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/counter.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/datapath.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/input_ram.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/LZD.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/multiplier.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/output_ram.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/register.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/shifter.v

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

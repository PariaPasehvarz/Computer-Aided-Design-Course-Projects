alias clc ".main clear"

clc
exec vlib work
vmap work work

# Define paths for your testbench (TB) and HDL files
set TB                   "circular_buffer_tb"
#set TB                   "testbench"
set hdl_path             "../src/hdl"
set inc_path             "../src/inc"

# Set simulation run time
set run_time             "100 us"
# set run_time           "-all"

#============================ Add verilog files  ===============================
# Please add other module here	
vlog    +acc -incr -source  +define+SIM     $hdl_path/buffer.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/circular_buffer.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/controller.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/datapath.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/empty_check.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/full_check.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/read_addr_gen.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/read_ptr_update.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/write_addr_gen.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/write_ptr_update.v

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

alias clc ".main clear"

clc
exec vlib work
vmap work work

# Define paths for your testbench (TB) and HDL files
set TB                   "tb"
set hdl_path             "../src/hdl"
set inc_path             "../src/inc"

# Set simulation run time
set run_time             "100 us"
# set run_time           "-all"

#============================ Add verilog files  ===============================
# Please add other module here	
vlog    +acc -incr -source  +define+SIM     $hdl_path/controller.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/modules.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/Adder/adder.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/BasicGates/And.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/BasicGates/Nand.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/BasicGates/Not.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/BasicGates/Or.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/BasicGates/Xor.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/Counter/five_bit_counter.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/Counter/four_bit_counter.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/IsLessThan/five_bit_is_less_than.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/IsLessThan/four_bit_is_less_than.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/LDZ/LZD.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/Register/sixteen_bit_register.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/Register/three_bit_register.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/Shifter/left_shifter.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/Modules/Shifter/right_shifter.v

vlog    +acc -incr -source  +define+SIM     $hdl_path/FiveOr.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/FourAnd.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/ThreeAnd.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/FourOr.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/datapath.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/top_module.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/mux.v
vlog    +acc -incr -source  +define+SIM     $hdl_path/multiplier.v


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

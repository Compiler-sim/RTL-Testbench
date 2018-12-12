#! /bin/sh -f
#--------------------------------------------------------------------------------
############## Script to be run from "Work" or "Run" folder
# All Directories to be specified in relative paths to this working folder
#
############## Project Specific Directory Structure############################
#--------------------------------------------------------------------------------
# do run_test.do

# vlib work

quit -sim

vlog  asyn_fifo.v   tb_asyn_fifo.sv -l comp.log

#vsim -l sim.log -t ns -novopt -debugDB -wlf sale_machine.wlf tb_sale_machine -do "log -r *; run -all;"

vsim -l sim.log -novopt work.tb_asyn_fifo

add wave -position insertpoint sim:/tb_asyn_fifo/*

run -all

#run 2us
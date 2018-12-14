#! /bin/sh -f
#--------------------------------------------------------------------------------
############## Script to be run from "Work" or "Run" folder
# All Directories to be specified in relative paths to this working folder
#
############## Project Specific Directory Structure############################
#
# do run_test.do
# Sample Below in Comments for a Project. Uncomment below and change the
# variables values for your project

# vlib work
#vmap work work
quit -sim

vlog -f rtl.list   Interface_tb.sv -l comp.log

#vsim -l sim.log -t ns -novopt -debugDB -wlf tb_top.wlf  Interface_tb -do "log -r *; run -all;"

vsim -l sim.log -novopt work.Interface_tb
add wave -position insertpoint sim:/Interface_tb/*
run -all
#Makefile for UVM Testbench
RTL = ../rtl/*
INC = +incdir+../master_agt +incdir+../slave_agt +incdir+../test +incdir+../tb +incdir+../src 
SVTB =  ../tb/axi_top.sv
SVTB1 = ../test/axi_test_pkg.sv
work = work
VSIMOPT= -novopt -sva -sv_seed random -l s.log work.top
VSIMBATCH1 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll mem_cov1;run -all;exit"
VSIMBATCH2 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll mem_cov2;run -all;exit"
VSIMBATCH3 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll mem_cov3;run -all;exit"
VSIMBATCH4 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll mem_cov4;run -all;exit"

html:
	firefox covhtmlreport/pages/__frametop.htm

lib:
	vlib $(work)
	vmap work $(work)

sv_cmp: lib comp0
         
run_sim:
	vsim $(VSIMOPT) $(VSIMBATCH1)    
	vcover report -html mem_cov1

gui:
	vsim $(VSIMOPT) -coverage +UVM_OBJECTION_TRACE +UVM_TESTNAME=axi_test_multi +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
	vcover report -html mem_cov1
	
gui1:
	vsim $(VSIMOPT) -coverage +UVM_OBJECTION_TRACE +UVM_TESTNAME=axi_aligned_test +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
	vcover report -html mem_cov2

gui2:
	vsim $(VSIMOPT) -coverage +UVM_OBJECTION_TRACE +UVM_TESTNAME=axi_test_unaligned +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
	vcover report -html mem_cov3

gui3:
	vsim $(VSIMOPT) -coverage +UVM_OBJECTION_TRACE +UVM_TESTNAME=axi_test_narrow +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
	vcover report -html mem_cov4

comp0:
	vlog -work $(work) $(RTL) $(INC) $(SVTB1) $(SVTB)

run_gui: clean lib comp0 gui

run_gui1: clean lib comp0 gui1

run_gui2: clean lib comp0 gui2

run_gui3: clean lib comp0 gui3

run_test: lib comp0
	vsim  $(VSIMBATCH1) -coverage -novopt -sva -sv_seed random -l test1_sim.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME=axi_test_multi +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
	vcover report -html mem_cov1

run_test1:
	vsim  $(VSIMBATCH2) -coverage -novopt -sva -sv_seed random -l test2_sim.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME=axi_aligned_test +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
	vcover report -html mem_cov2

run_test2:
	vsim  $(VSIMBATCH3) -coverage -novopt -sva -sv_seed random -l test3_sim.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME=axi_test_unaligned +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
	vcover report -html mem_cov3

run_test3:
	vsim  $(VSIMBATCH4) -coverage -novopt -sva -sv_seed random -l test4_sim.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME=axi_test_narrow +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
	vcover report -html mem_cov4

clean:
	rm -rf modelsim.* transcript* *log* work wlf* vsim.wlf fcover* covhtml* mem_cov*
	clear
report:
	vcover merge mem_cover mem_cov1 mem_cov2 mem_cov3 mem_cov4
	vcover report -html mem_cover

regress: clean run_test run_test1 run_test2 run_test3 report html

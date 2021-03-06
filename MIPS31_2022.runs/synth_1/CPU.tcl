# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.cache/wt [current_project]
set_property parent.project_path D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/addu.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/sub.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/subu.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/and.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/or.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/xor.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/nor.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/slt.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/sltu.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/sll.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/srl.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/sra.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/sllv.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/srlv.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/srav.coe
add_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/testcases/_dropEggs.coe
add_files -quiet d:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0.dcp
set_property used_in_implementation false [get_files d:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0.dcp]
add_files -quiet d:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/sources_1/ip/ila_0/ila_0.dcp
set_property used_in_implementation false [get_files d:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/sources_1/ip/ila_0/ila_0.dcp]
read_verilog -library xil_defaultlib {
  D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/sources_1/new/ALU.v
  D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/sources_1/new/RegFile.v
  D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/sources_1/new/DMEM.v
  D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/sources_1/new/IMEM.v
  D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/sources_1/new/Controller.v
  D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/sources_1/new/CPU.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/constrs_1/new/tb.xdc
set_property used_in_implementation false [get_files D:/Projects/Vivado/MIPS31_2022/MIPS31_2022.srcs/constrs_1/new/tb.xdc]


synth_design -top CPU -part xc7a100tcsg324-1


write_checkpoint -force -noxdef CPU.dcp

catch { report_utilization -file CPU_utilization_synth.rpt -pb CPU_utilization_synth.pb }

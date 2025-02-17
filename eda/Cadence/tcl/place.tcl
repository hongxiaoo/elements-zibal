set TOOL "place"

source common/board.tcl
source common/pathes.tcl
source pdks/${PDK}.tcl
source tcl/flow/sourcer.tcl
source flows/${SOC}.tcl

setMultiCpuUsage -localCpu 2 -remoteHost 1 -cpuPerRemoteHost 8

set defHierChar {/}
set init_design_settop 1
set init_top_cell ${TOP}

set init_mmmc_file pdks/${PDK}.mmmc.tcl
set init_verilog ${PATH_BUILD_ROOT}/synthesize/${TOP}.v

set init_io_file ${PATH_RTL}/${TOP}.io

set init_lef_file [get_lef_files]

set init_pwr_net [get_power_nets]
set init_gnd_net [get_ground_nets]

foreach {suppress_message} [get_suppress_messages] {
	suppressMessage "$suppress_message"
}

elements_load_design

setMaxRouteLayer [get_max_route_layer]

set stages {floorplan place cts route signoff verify save}
if {$::env(STAGE) != "init"} {
	foreach stage $stages {
		puts "Call $stage"
		$stage
		if {$stage == $::env(STAGE)} {
			puts "Leave because $::env(STAGE) is set as last stage"
			break
		}
	}
}

uiSet main -title "Innovus - ${TOP}"
win

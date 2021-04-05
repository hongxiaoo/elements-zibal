## library_sets
set timing_max ${PATH_PDK}/stdcell/lib/ixc013_stdcell_slow_1p08V_125C.lib
lappend timing_max ${PATH_PDK}/iocell/lib/ixc013_iocell_slow_1p08V_3p0V_125C.lib
create_library_set -name libset_max \
	-timing $timing_max
set timing_min ${PATH_PDK}/stdcell/lib/ixc013_stdcell_fast_1p32V_m40C.lib
lappend timing_min ${PATH_PDK}/iocell/lib/ixc013_iocell_fast_1p32V_3p6V_m40C.lib
create_library_set -name libset_min \
	-timing $timing_min

## rc_corner
create_rc_corner -name rc_corner_max \
	-T 125.0 \
	-cap_table ${PATH_PDK}/stdcell/lef/captable/SG13.captable \
	-qx_tech_file ${PATH_PDK}/tech/Assura_SG13/qrc/qrcTechFile \
	-preRoute_res 1.0 \
	-preRoute_cap 1.0 \
	-postRoute_res {1.0 1.0 1.0} \
	-postRoute_cap {1.0 1.0 1.0} \
	-postRoute_xcap {1.0 1.0 1.0} \
	-postRoute_clkres {1.0 1.0 1.0} \
	-postRoute_clkcap {1.0 1.0 1.0}
create_rc_corner -name rc_corner_min \
	-T -40.0 \
	-cap_table ${PATH_PDK}/stdcell/lef/captable/SG13.captable \
	-qx_tech_file ${PATH_PDK}/tech/Assura_SG13/qrc/qrcTechFile \
	-preRoute_res 1.0 \
	-preRoute_cap 1.0 \
	-postRoute_res {1.0 1.0 1.0} \
	-postRoute_cap {1.0 1.0 1.0} \
	-postRoute_xcap {1.0 1.0 1.0} \
	-postRoute_clkres {1.0 1.0 1.0} \
	-postRoute_clkcap {1.0 1.0 1.0}

## delay_corner
create_delay_corner -name delay_corner_std_max \
	-library_set libset_max \
	-opcond_library {ixc013_stdcell_slow_1p08V_125C} \
	-opcond {slow_1_08V_125C} \
	-rc_corner rc_corner_max
create_delay_corner -name delay_corner_io_max \
	-library_set libset_max \
	-opcond_library {ixc013_iocell_slow_1p08V_3p0V_125C} \
	-opcond {ixc013_iocell_slow_1p08V_3p0V_125C} \
	-rc_corner rc_corner_max
create_delay_corner -name delay_corner_std_min \
	-library_set libset_min \
	-opcond_library {ixc013_stdcell_fast_1p32V_m40C} \
	-opcond {fast_1_32V_m40C} \
	-rc_corner rc_corner_min
create_delay_corner -name delay_corner_io_min \
	-library_set libset_min \
	-opcond_library {ixc013_iocell_fast_1p32V_3p6V_m40C} \
	-opcond {ixc013_iocell_fast_1p32V_3p6V_m40C} \
	-rc_corner rc_corner_min

## constraint_mode
set sdc_files ${PATH}/zibal/eda/Cadence/SDC/${top_module}.sdc
create_constraint_mode -name constraint_mode \
	-sdc_files $sdc_files

## analysis_view
create_analysis_view -name view_std_max \
	-constraint_mode constraint_mode \
	-delay_corner delay_corner_std_max
create_analysis_view -name view_io_max \
	-constraint_mode constraint_mode \
	-delay_corner delay_corner_io_max
create_analysis_view -name view_std_min \
	-constraint_mode constraint_mode \
	-delay_corner delay_corner_std_min
create_analysis_view -name view_io_min \
	-constraint_mode constraint_mode \
	-delay_corner delay_corner_io_min

## set_analysis_view
set_analysis_view -setup { view_std_max view_io_max } \
	-hold { view_std_min view_io_min }

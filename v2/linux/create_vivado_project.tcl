# Setting
set PRJ_DIR     _vivado
set PRJ_NAME    ultra96v2
set BD_NAME     ${PRJ_NAME}
set SRC_DIR     src
set NUM_JOBS    4


# Create project
create_project ${PRJ_NAME} ${PRJ_DIR} -part xczu3eg-sbva484-1-e
set_property board_part em.avnet.com:ultra96v2:part0:1.0 [current_project]

# Set IP repository paths
set IP_REPOS [ format "${SRC_DIR}/ip" ]
set_property  ip_repo_paths  ${IP_REPOS}  [current_project]
update_ip_catalog

# Add constraint
add_files -fileset constrs_1 -norecurse ${SRC_DIR}/ultra96v2_oob.xdc

# Create block design
source ${SRC_DIR}/bd.tcl

# Set top-level source
make_wrapper -files [get_files ${PRJ_DIR}/${PRJ_NAME}.srcs/sources_1/bd/${BD_NAME}/${BD_NAME}.bd] -top
add_files -norecurse ${PRJ_DIR}/${PRJ_NAME}.srcs/sources_1/bd/${BD_NAME}/hdl/${BD_NAME}_wrapper.v
set_property top ${BD_NAME}_wrapper [current_fileset]
update_compile_order -fileset sources_1

regenerate_bd_layout
validate_bd_design
save_bd_design

# Generate bitstream
update_compile_order -fileset sources_1

reset_run synth_1
launch_runs synth_1 -jobs ${NUM_JOBS}
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs ${NUM_JOBS}
wait_on_run impl_1

# Report utilization & clock after implementation
open_run impl_1
report_utilization
report_clocks

# Export HW with bitstream
file copy -force ${PRJ_DIR}/${PRJ_NAME}.runs/impl_1/${PRJ_NAME}_wrapper.sysdef ${PRJ_NAME}_wrapper.hdf

# Finish - close project
close_project

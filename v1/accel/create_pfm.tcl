#
# Create acceleration platform
#

set OUT_DIR     _pfm

# Remove existing directory
file delete -force ${OUT_DIR}

platform create -name {u96_accel} -hw {ultra96.xsa} -no-boot-bsp -out ${OUT_DIR}
platform write
platform active {u96_accel}

# Add sysroot??
domain create -name xrt -os linux -proc psu_cortexa53
domain active xrt
domain config -bif {src/linux.bif}
domain config -boot {petalinux/images/linux}
domain config -image {_image}
domain config -qemu-data {petalinux/images/linux}
domain config -qemu-args {src/qemu_args.txt}
domain config -pmuqemu-args {src/pmu_args.txt}
platform write

platform generate


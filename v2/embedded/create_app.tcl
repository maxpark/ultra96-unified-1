# 
# Create "Hello World" application
# 

platform create -name ultra96 -hw ultra96v2.xsa -out _application -proc psu_cortexa53_0 -os standalone
platform write

# Change stdin & stdout setting
# standalone_domian
domain active standalone_domain
bsp config stdin psu_uart_1
bsp config stdout psu_uart_1
bsp regenerate

domain active zynqmp_fsbl
bsp config stdin psu_uart_1
bsp config stdout psu_uart_1
bsp regenerate

domain active zynqmp_pmufw
bsp config stdin psu_uart_1
bsp config stdout psu_uart_1
bsp regenerate

platform generate

# Creat e Hello World application (.elf)
setws _application
app create -name hello_world -hw ultra96v2.xsa -os standalone -proc psu_cortexa53_0 -template {Hello World}
# app create -name test -sysproj ultra96v2 -domain standalone_domain -template {Hello World}
# app create -name hello_world -platform ultra96 -domain standalone_domain -template {Hello World}
# Build .elf in release mode
app config -name hello_world -set build-config release
app build -name hello_world

# Creat .bif file
builtin_bifgen -xpfm _application/ultra96v2/export/ultra96v2/ultra96v2.xpfm -domains standalone_domain -bifpath _application/system.bif

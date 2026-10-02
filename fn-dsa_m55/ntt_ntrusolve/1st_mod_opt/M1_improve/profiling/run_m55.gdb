set pagination off
set confirm off
set remotetimeout 20
target extended-remote localhost:3335
monitor reset halt
load
set $sp = &_estack
set $pc = &Reset_Handler
set $xpsr = 0x01000000
set $primask = 0
set $basepri = 0
set $faultmask = 0
set $control = 0
continue
source capture.gdb
detach
quit

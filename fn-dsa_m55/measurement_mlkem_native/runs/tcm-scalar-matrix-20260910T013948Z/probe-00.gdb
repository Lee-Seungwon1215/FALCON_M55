set pagination off
set confirm off
target remote localhost:3349
load
set $control=0
set $basepri=0
set $faultmask=0
set $msplim_s=0
set $psplim_s=0
set $msp=0x340bf000
set $psp=0x340be000
x/2wx 0x56028020
x/wx 0x56028048
x/wx 0xe000ed14
set {unsigned int}0x56028a54=0x1000
x/8wx 0x52023500
hbreak *0x340800ce
hbreak *0x340800f4
hbreak *0x340800e8
hbreak *0x340800ee
jump *0x34080041
if $pc != 0x340800ce
echo [[PROBE-INIT-FAIL]]\n
info registers
x/8wx $msp
x/6wx 0xe000ed28
x/6wx 0xe001e000
monitor reset_config none
monitor reset run
quit 2
end
load /Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/build/zephyr/zephyr.elf
dump binary memory /Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/runs/tcm-scalar-matrix-20260910T013948Z/memcpy.bin 0x1001302c 0x100131a4
restore /Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/runs/tcm-scalar-matrix-20260910T013948Z/memcpy.bin binary 0x34081000
set {unsigned int}0xe000ed88=0x00500000
set $fpscr=0x40000
set $r0=0x30000000
set $r2=140
set $r4=0x34081001
set $r1=0x100243b8
set $r7=0x10024bc1
set $r5=10000
jump *0x340800e7
printf "CASE id=0 code=0x34081000 data=0x100243b8 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
x/36wx 0x30000000
x/36wx 0x100243b8
dump binary memory /Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/runs/tcm-scalar-matrix-20260910T013948Z/copied-0.bin 0x30000000 0x3000008c
monitor reset_config none
monitor reset run
detach
quit 0

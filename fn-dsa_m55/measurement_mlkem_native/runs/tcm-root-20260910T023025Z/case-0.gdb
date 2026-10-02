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
set {unsigned int}0x56028a78=1
set {unsigned int}0x56028a54=0x1000
echo SYSCFG_TCMCR_RESETCR:\n
x/wx 0x56008008
x/wx 0x56008018
echo RAMCFG_FLEX:\n
x/8wx 0x52023500
echo CLOCK_CACHE_BOOT:\n
x/2wx 0x56028020
x/wx 0x56028048
x/wx 0xe000ed14
echo TEBR_PRE:\n
x/4wx 0xe001e120
set {unsigned int}0xe001e120=0
set {unsigned int}0xe001e128=0
hbreak *0x340800ce
hbreak *0x34080190
hbreak *0x340800f4
hbreak *0x340800e8
jump *0x34080041
if $pc != 0x340800ce
echo INIT_FAILED\n
monitor reset_config none
monitor reset run
quit 2
end
set $r4=0x34081000
set $r6=0x340801a0
set $r7=16
set $r8=0x10024000
jump *0x34080169
if $pc != 0x34080190
echo PREP_FAILED\n
monitor reset_config none
monitor reset run
quit 3
end
dump binary memory /Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/runs/tcm-root-20260910T023025Z/code-0.bin 0x34081000 0x34081010
dump binary memory /Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/runs/tcm-root-20260910T023025Z/input-0.bin 0x10024000 0x10024080
echo PRE_RUN_ECC:\n
x/6wx 0xe001e000
x/4wx 0xe001e120
set $r0=0x34082000
set $r1=0x10024000
set $r2=128
set $r4=0x34081001
jump *0x34080197
printf "CASE id=0 pc=0x%x r0=0x%x cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
info registers
x/8wx $msp
x/4wx 0xe001e120
dump binary memory /Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/runs/tcm-root-20260910T023025Z/output-0.bin 0x34082000 0x34082080
monitor reset_config none
monitor reset run
detach
quit 0

set pagination off
set confirm off
target remote localhost:3349
load
set $xpsr=0x01000000
set $primask=1
set $control=0
set $basepri=0
set $faultmask=0
set $msplim_s=0
set $psplim_s=0
set $msp=0x340bf000
set $psp=0x340be000
set {unsigned int}0x56028a78=1
set {unsigned int}0x56028a54=0x1000
set $saved_tcmcr=*(unsigned int*)0x56008008
if (*(unsigned int*)0x56028020 != 0) || (*(unsigned int*)0x56028048 != 0x8c800000)
echo NOT_BOOT_HSI64\n
quit 4
end
set {unsigned int}0x56008008=($saved_tcmcr & ~0x1800000) | 0x800000
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
hbreak *0x3408018c
hbreak *0x340800f4
hbreak *0x340800e8
jump *0x34080041
if $pc != 0x340800ce
echo INIT_FAILED\n
set {unsigned int}0x56008008=$saved_tcmcr
echo RESTORED_TCMCR:\n
x/wx 0x56008008
monitor reset_config none
monitor reset run
quit 2
end
set $r4=0x1001302c
set $r6=0x340801c4
set $r7=14
set $r8=0x10024000
jump *0x34080165
if $pc != 0x3408018c
echo PREP_FAILED\n
set {unsigned int}0x56008008=$saved_tcmcr
echo RESTORED_TCMCR:\n
x/wx 0x56008008
monitor reset_config none
monitor reset run
quit 3
end
dump binary memory /Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/runs/tcm-root-20260910T023253Z/code-9.bin 0x1001302c 0x1001303a
dump binary memory /Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/runs/tcm-root-20260910T023253Z/input-9.bin 0x10024000 0x10024080
echo PRE_RUN_ECC:\n
x/6wx 0xe001e000
x/4wx 0xe001e120
set $r0=0x34082000
set $r1=0x10024000
set $r2=128
set $r4=0x1001302d
jump *0x34080193
printf "CASE id=9 pc=0x%x r0=0x%x cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
info registers
x/8wx $msp
x/4wx 0xe001e120
dump binary memory /Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/runs/tcm-root-20260910T023253Z/output-9.bin 0x34082000 0x34082080
set {unsigned int}0x56008008=$saved_tcmcr
echo RESTORED_TCMCR:\n
x/wx 0x56008008
monitor reset_config none
monitor reset run
detach
quit 0

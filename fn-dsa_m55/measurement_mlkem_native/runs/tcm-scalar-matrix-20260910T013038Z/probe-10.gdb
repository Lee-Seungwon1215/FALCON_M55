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
set {unsigned int}0x56028a54=0x1000
x/8wx 0x52023500
hbreak *0x340800ce
hbreak *0x340800ee
hbreak *0x340800e2
hbreak *0x340800e8
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
set $r4=0x10001001
set $r1=0x10020800
set $r7=0x10021009
set $r5=10000
jump *0x340800d5
printf "CASE id=10 code=0x10001000 data=0x10020800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
monitor reset_config none
monitor reset run
detach
quit 0

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
hbreak *0x340800bc
hbreak *0x340800dc
hbreak *0x340800d0
hbreak *0x340800d6
jump *0x34080041
if $pc != 0x340800bc
echo [[PROBE-INIT-FAIL]]\n
quit 2
end
set $r4=0x340800e9
set $r1=0x34080800
set $r5=10000
jump *0x340800c3
printf "CASE id=0 code=0x340800e8 data=0x34080800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
monitor reset_config none
monitor reset run
detach
quit 0

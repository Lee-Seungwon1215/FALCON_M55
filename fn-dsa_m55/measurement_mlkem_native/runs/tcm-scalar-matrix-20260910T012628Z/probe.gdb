set pagination off
set confirm off
target remote localhost:3349
delete breakpoints
monitor reset_config none
monitor reset halt
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
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r1=0x10000800
set $r5=10000
jump *0x340800c3
printf "CASE id=1 code=0x340800e8 data=0x10000800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r1=0x10010800
set $r5=10000
jump *0x340800c3
printf "CASE id=2 code=0x340800e8 data=0x10010800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r1=0x10020800
set $r5=10000
jump *0x340800c3
printf "CASE id=3 code=0x340800e8 data=0x10020800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r1=0x10030800
set $r5=10000
jump *0x340800c3
printf "CASE id=4 code=0x340800e8 data=0x10030800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r1=0x30000800
set $r5=10000
jump *0x340800c3
printf "CASE id=5 code=0x340800e8 data=0x30000800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r1=0x30020800
set $r5=10000
jump *0x340800c3
printf "CASE id=6 code=0x340800e8 data=0x30020800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10001001
set $r1=0x34080800
set $r5=10000
jump *0x340800c3
printf "CASE id=7 code=0x10001000 data=0x34080800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10001001
set $r1=0x10000800
set $r5=10000
jump *0x340800c3
printf "CASE id=8 code=0x10001000 data=0x10000800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10001001
set $r1=0x10010800
set $r5=10000
jump *0x340800c3
printf "CASE id=9 code=0x10001000 data=0x10010800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10001001
set $r1=0x10020800
set $r5=10000
jump *0x340800c3
printf "CASE id=10 code=0x10001000 data=0x10020800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10001001
set $r1=0x10030800
set $r5=10000
jump *0x340800c3
printf "CASE id=11 code=0x10001000 data=0x10030800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10001001
set $r1=0x30000800
set $r5=10000
jump *0x340800c3
printf "CASE id=12 code=0x10001000 data=0x30000800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10001001
set $r1=0x30020800
set $r5=10000
jump *0x340800c3
printf "CASE id=13 code=0x10001000 data=0x30020800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10011001
set $r1=0x34080800
set $r5=10000
jump *0x340800c3
printf "CASE id=14 code=0x10011000 data=0x34080800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10011001
set $r1=0x10000800
set $r5=10000
jump *0x340800c3
printf "CASE id=15 code=0x10011000 data=0x10000800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10011001
set $r1=0x10010800
set $r5=10000
jump *0x340800c3
printf "CASE id=16 code=0x10011000 data=0x10010800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10011001
set $r1=0x10020800
set $r5=10000
jump *0x340800c3
printf "CASE id=17 code=0x10011000 data=0x10020800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10011001
set $r1=0x10030800
set $r5=10000
jump *0x340800c3
printf "CASE id=18 code=0x10011000 data=0x10030800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10011001
set $r1=0x30000800
set $r5=10000
jump *0x340800c3
printf "CASE id=19 code=0x10011000 data=0x30000800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10011001
set $r1=0x30020800
set $r5=10000
jump *0x340800c3
printf "CASE id=20 code=0x10011000 data=0x30020800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10021001
set $r1=0x34080800
set $r5=10000
jump *0x340800c3
printf "CASE id=21 code=0x10021000 data=0x34080800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10021001
set $r1=0x10000800
set $r5=10000
jump *0x340800c3
printf "CASE id=22 code=0x10021000 data=0x10000800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10021001
set $r1=0x10010800
set $r5=10000
jump *0x340800c3
printf "CASE id=23 code=0x10021000 data=0x10010800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10021001
set $r1=0x10020800
set $r5=10000
jump *0x340800c3
printf "CASE id=24 code=0x10021000 data=0x10020800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10021001
set $r1=0x10030800
set $r5=10000
jump *0x340800c3
printf "CASE id=25 code=0x10021000 data=0x10030800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10021001
set $r1=0x30000800
set $r5=10000
jump *0x340800c3
printf "CASE id=26 code=0x10021000 data=0x30000800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10021001
set $r1=0x30020800
set $r5=10000
jump *0x340800c3
printf "CASE id=27 code=0x10021000 data=0x30020800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10031001
set $r1=0x34080800
set $r5=10000
jump *0x340800c3
printf "CASE id=28 code=0x10031000 data=0x34080800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10031001
set $r1=0x10000800
set $r5=10000
jump *0x340800c3
printf "CASE id=29 code=0x10031000 data=0x10000800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10031001
set $r1=0x10010800
set $r5=10000
jump *0x340800c3
printf "CASE id=30 code=0x10031000 data=0x10010800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10031001
set $r1=0x10020800
set $r5=10000
jump *0x340800c3
printf "CASE id=31 code=0x10031000 data=0x10020800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10031001
set $r1=0x10030800
set $r5=10000
jump *0x340800c3
printf "CASE id=32 code=0x10031000 data=0x10030800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10031001
set $r1=0x30000800
set $r5=10000
jump *0x340800c3
printf "CASE id=33 code=0x10031000 data=0x30000800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
delete breakpoints
monitor reset_config none
monitor reset halt
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
set $r4=0x10031001
set $r1=0x30020800
set $r5=10000
jump *0x340800c3
printf "CASE id=34 code=0x10031000 data=0x30020800 pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38
x/8wx $msp
x/8wx 0xe001e120
x/6wx 0xe001e000
monitor reset_config none
monitor reset run
detach
quit 0

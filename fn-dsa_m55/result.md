# FN-DSA: M4 어셈블리 유지 / Cortex-M55 실측

> **최신 갱신(2026-09-10): TCM 시작 오류 수정 및 새 B 단계 600회 계측 완료.**
> [800 MHz·코드 ITCM·상수/데이터 DTCM·캐시 OFF 결과](measurement_mlkem_native/result.md).
> 아래 600 MHz AXISRAM 수치는 이전 실험 기록이며 최신 결과와 구분한다.

> 추가 실험: [SRAM·캐시 OFF·CPU/HCLK 24 MHz 공통 조건 측정](measurement_controlled/result.md), [M4↔M55 비교](../comparison_m4_m55/result.md). 아래 기존 600 MHz·캐시 ON 결과는 그대로 보존한다.

상태: **100회 측정·정확성 검증 완료**. 갱신: `2026-09-09T00:30:25.371464+00:00`.

이 실험은 `fn-dsa_m55/ref`의 M4 정수/DSP 어셈블리를 M55에 이식한 기준 구현이다. 하드웨어 FP64 또는 MVE로 재작성한 최적화 버전이 아니다.

## 측정 조건

| 항목 | 설정 |
|---|---|
| 원본 | `pornin/c-fn-dsa`, `a5f15894bf1a68017074650d5298cecf9bb29a79` |
| 실제 사용 경로 | `fn-dsa_m55/ref`; 복사되어 있던 `ref/profiling`의 과거 결과·생성본은 사용하지 않음 |
| 소스 변경 | `ref/inner.h`의 명시적 M55 어셈블리 호환 선택·검사만 추가. 원본 C 연산과 5개 `.s` 내용은 동일 |
| 어셈블리 | `FNDSA_ASM_CORTEXM4=1`, `FNDSA_ASM_CORTEXM55=1`; codec/mq/sha3/sign_fpr/sign_sampler의 `.s` 및 인라인 ASM 유지 |
| 컴파일러 | Arm GNU 13.2.Rel1 / GCC 13.2.1 |
| 빌드 | `-O3 -mthumb -mcpu=cortex-m55+nomve -mfpu=auto -mfloat-abi=hard -mcmse`; LTO/fast-math 없음 |
| MVE | 이번 기준 측정에서는 명령 생성을 비활성화. C fallback으로 바꾸는 것이 아님 |
| 수 표현 | 키 생성 32.32 고정소수점, 서명 binary64 비트열의 정수 에뮬레이션. FP 레지스터는 기존 ASM의 임시 저장에 사용 |
| 보드 | NUCLEO-N657X0-Q / STM32N657, CPUID 0x411fd221, ST-LINK `003C00223335510735383531` |
| 클럭 | CPU 공칭 600 MHz, HCLK 200 MHz, HSI→PLL1. 기존 M55 프로파일링과 같은 클럭 설정 |
| 코드·상수 | AXI SRAM2 `0x34180400`부터. 외부 Flash 기록·삭제 없음 |
| 데이터·스택 | AXI SRAM2 `0x341C0000`부터; 스택 최상단 `0x341FF000`, 스택 최소 여유 96 KiB |
| 캐시·진행 상태 | I/D cache ON; 결과 mailbox `0x341FF000..0x341FFFFF`만 MPU로 Normal non-cacheable 설정 |
| 반복 | FN-DSA-512/1024 각각 키 생성·서명·검증 100회. 크기별 워밍업 각 1회 제외 |
| 입력 | M4 측정과 같은 결정적 키 시드 32 B, 서명 시드 40 B. 매회 새 키→서명→검증. 메시지 `blah` 4 B, RAW, 빈 context |
| 계측 | DWT CYCCNT로 seeded/temp API 전체. 내부 재시도 포함, 외부 RNG·시드 준비·체크섬·로그 제외 |
| 인터럽트 | 본 계측 중 PRIMASK=1, SysTick OFF |
| 모니터링 | 약 60초마다 non-cacheable mailbox 헤더 160 B 읽기. 본 측정 중 halt/reset 없음 |

M4 측정은 24 MHz·Flash 1 WS·캐시 OFF·다른 SRAM 배치였으므로, 사이클 또는 시간 차이를 CPU 코어 하나의 효과로 해석하면 안 된다.

DWT 차분은 32비트다. API 한 번이 2^32 cycles(600 MHz에서 약 7.16초) 미만이라는 전제가 있고, 다중 wrap 검출 인터럽트는 넣지 않았다. ms는 공칭 클럭 환산이다.

디버그 버스 상태 읽기의 성능 영향이 정확히 0임을 검증한 실험은 아니다. 본 결과는 기능·성능 검증이며 별도의 constant-time/부채널 안전성 감사 결과가 아니다.

## 정확성 및 진행

- 크기 1024, 0-based index 99, 단계 verify.
- 완료 [키 생성, 서명, 검증]: 512 `[100, 100, 100]`, 1024 `[100, 100, 100]`.
- 상태 `0x600d0000`, 오류 `0x00000000`.
- CPU/HCLK=600000000/200000000, CCR=`0x00030201`, MPU_CTRL=`0x00000005`.
- 실제 FPU feature: MVFR0=`0x10110221`, MVFR1=`0x12100211`, MVFR2=`0x00000040`.
- 워밍업 호스트 대조: True. 정상 서명 검증과 변조 서명 거부를 포함한다.
- 기준값은 동일 입력 100회씩을 실행한 portable C 호스트 결과다. M4와 동일한 입력·FNV-1a 진단 체크섬을 사용한다.
- 체크섬 일치는 진단용이며 암호학적 동등성 증명은 아니다. 결정적 시드는 실서비스 키 생성용이 아니다.

## 최종 결과

100회 전체를 집계했다. 표준편차는 표본 표준편차이며 이상치를 제외하지 않았다.

| 크기 | 단계 | 횟수 | 평균 cycles | 중앙값 | 표준편차 | 최소 | 최대 | 평균 ms |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| 512 | keygen | 100 | 55,799,204.94 | 47,971,816.5 | 18,248,370.23 | 42,070,431 | 115,322,279 | 92.999 |
| 512 | sign | 100 | 16,715,859.16 | 16,721,820.5 | 65,307.10 | 16,561,084 | 16,860,674 | 27.860 |
| 512 | verify | 100 | 348,766.22 | 353,920.5 | 6,647.82 | 340,059 | 354,744 | 0.581 |
| 1024 | keygen | 100 | 225,415,080.36 | 192,167,957.5 | 98,341,559.05 | 139,517,989 | 574,961,203 | 375.692 |
| 1024 | sign | 100 | 36,045,589.43 | 36,038,805.5 | 84,721.95 | 35,895,401 | 36,254,089 | 60.076 |
| 1024 | verify | 100 | 691,393.99 | 695,647.5 | 6,483.78 | 681,716 | 697,809 | 1.152 |

### 회차별 원시 사이클

```csv
degree,index,keygen_cycles,sign_cycles,verify_cycles
512,1,47105865,16572026,354389
512,2,66214564,16724190,354740
512,3,67698042,16700402,354090
512,4,44980518,16739082,340376
512,5,45628774,16732687,340746
512,6,43394755,16736584,340267
512,7,66529126,16653435,353748
512,8,43761949,16757049,340708
512,9,48804096,16732304,354232
512,10,45969646,16702394,353956
512,11,42073771,16779973,340383
512,12,43759417,16794289,354342
512,13,48804852,16763704,340994
512,14,44482678,16714078,340424
512,15,48800730,16724055,354418
512,16,42074854,16770646,353948
512,17,101826754,16679095,353727
512,18,46392858,16643808,340825
512,19,55013047,16659252,354631
512,20,43944915,16665247,340558
512,21,42070431,16682248,340864
512,22,46763363,16660623,354129
512,23,46754648,16695201,341032
512,24,42074232,16635719,354002
512,25,62141323,16770053,354111
512,26,49530735,16796647,354121
512,27,52736507,16763601,340712
512,28,107591241,16734433,340659
512,29,46755170,16667172,340868
512,30,85698414,16767208,340809
512,31,44120360,16575759,354744
512,32,115322279,16737856,340726
512,33,42438321,16823410,353668
512,34,73584570,16736231,340647
512,35,107784313,16775517,354438
512,36,75512380,16702483,354111
512,37,78163417,16610062,354180
512,38,63279715,16712823,340281
512,39,91573873,16678911,353751
512,40,42438026,16665037,340059
512,41,48950253,16816455,354072
512,42,44710674,16645065,340413
512,43,63212935,16707628,353989
512,44,42075423,16815548,354207
512,45,42442152,16687000,340476
512,46,42073640,16767343,340362
512,47,43392256,16751374,354235
512,48,54828497,16734523,354263
512,49,45074603,16621389,340628
512,50,42442785,16668227,340713
512,51,48802260,16619358,341261
512,52,46764131,16720345,353738
512,53,54949276,16628361,354450
512,54,45442926,16745027,353700
512,55,43948153,16750309,354002
512,56,61690476,16735608,340539
512,57,57429454,16670740,340574
512,58,52996761,16712716,340765
512,59,57704247,16760470,353850
512,60,42445531,16825548,340644
512,61,46758819,16721280,354078
512,62,108772894,16709911,354259
512,63,82573192,16604600,354208
512,64,43162122,16697520,354000
512,65,66195265,16731597,340912
512,66,77253388,16722361,354137
512,67,49308975,16633104,353893
512,68,47846056,16802283,353799
512,69,42440463,16752915,354159
512,70,48286072,16620001,340940
512,71,53499563,16774716,354380
512,72,51588019,16780374,354079
512,73,45073636,16778663,340598
512,74,43893739,16615633,341046
512,75,48078041,16771866,354673
512,76,43394197,16626651,354048
512,77,55362193,16654091,354109
512,78,42800069,16800418,354323
512,79,74123199,16707964,354076
512,80,47865592,16723897,354453
512,81,43165770,16860674,341145
512,82,49527175,16840789,354657
512,83,51456315,16612196,353878
512,84,42074824,16705981,354213
512,85,42074462,16692934,340888
512,86,42441353,16747516,353993
512,87,42075460,16635664,354164
512,88,83384249,16798080,354094
512,89,44714311,16779542,354374
512,90,47482793,16713325,340826
512,91,48646268,16561084,354660
512,92,67252600,16823507,354075
512,93,73828156,16760269,340437
512,94,103403874,16674315,354599
512,95,42079678,16669089,340407
512,96,51449302,16725699,354095
512,97,62668392,16788343,340649
512,98,104076621,16648844,354242
512,99,42435994,16684959,340698
512,100,42436441,16814933,354063
1024,1,332451687,36070927,682369
1024,2,195775229,36040780,696203
1024,3,244196170,36165493,681777
1024,4,168779652,35972263,695514
1024,5,182764078,35989278,697566
1024,6,407176289,35895401,696176
1024,7,399990592,35986378,682275
1024,8,192214418,35919478,695858
1024,9,232014484,36068473,695652
1024,10,159405397,36059097,696025
1024,11,139520530,36035482,682332
1024,12,272020600,36168875,696080
1024,13,140215355,35967988,695525
1024,14,140920573,35902025,695523
1024,15,144776971,35907905,682594
1024,16,178661637,36050279,696786
1024,17,348318071,36012286,695634
1024,18,146331588,36016772,695903
1024,19,150430893,36018645,695362
1024,20,169234494,36047498,695920
1024,21,219620029,36167465,695869
1024,22,158091930,35970715,682524
1024,23,295780693,36063918,696040
1024,24,328613521,36028825,682358
1024,25,152288227,35957991,695706
1024,26,574961203,36089809,696028
1024,27,147095181,36082917,695860
1024,28,211007602,36134990,696156
1024,29,152526196,35975115,696400
1024,30,139527652,36162653,695276
1024,31,210591785,36218802,681935
1024,32,140219245,36148957,682530
1024,33,225708391,36054680,682256
1024,34,192121497,36028964,682665
1024,35,230137410,35993868,695673
1024,36,213879243,35990346,695832
1024,37,146797680,36187203,696847
1024,38,175415732,35899588,695862
1024,39,427294377,36010084,682110
1024,40,232490896,35932722,682635
1024,41,217818134,35957827,682055
1024,42,204764509,36108817,695434
1024,43,507646119,35946801,696285
1024,44,250505635,36016403,696602
1024,45,152136898,36089952,695738
1024,46,300280981,36136530,695809
1024,47,143310828,36091886,695997
1024,48,154456438,36124433,681716
1024,49,146333884,36043666,695709
1024,50,177884894,36050951,681985
1024,51,142933045,35972050,682461
1024,52,241241190,36254089,696135
1024,53,288545920,36062110,695450
1024,54,139536076,36096326,682528
1024,55,151825326,35990914,696090
1024,56,150436138,35905965,695763
1024,57,230977819,35945396,695521
1024,58,142233917,36187398,695917
1024,59,327005575,36166024,682591
1024,60,272318907,35997775,696228
1024,61,263414172,35905141,697809
1024,62,191346207,35932558,681991
1024,63,166521261,36045869,683778
1024,64,163838288,36071725,682809
1024,65,441617757,36107942,695978
1024,66,253313435,36197798,696374
1024,67,377742615,36016906,696028
1024,68,239366387,35986610,696430
1024,69,142233919,36106311,682063
1024,70,242003197,36032371,696253
1024,71,166061808,35985095,683751
1024,72,463012507,35975644,682693
1024,73,139527329,35981767,681740
1024,74,139529590,36067927,697586
1024,75,286015198,35980763,682478
1024,76,449407597,36167124,683099
1024,77,407020242,35925179,695665
1024,78,287508730,36211285,696006
1024,79,139522672,36124574,682340
1024,80,213228237,35987199,696256
1024,81,209431411,36167240,695799
1024,82,156552613,35927122,697686
1024,83,139534590,36037283,695520
1024,84,288755517,36028881,681816
1024,85,220420244,35976375,682605
1024,86,158723293,36043396,695898
1024,87,163358958,35987180,682508
1024,88,153143377,36072173,695540
1024,89,149428344,36028998,697239
1024,90,149036109,35967729,695197
1024,91,216566667,35986833,695714
1024,92,147411105,36114973,682510
1024,93,151138078,36077562,696072
1024,94,219498139,36115085,695643
1024,95,447153912,36025219,695677
1024,96,419839461,36145143,682985
1024,97,157249363,36162092,695061
1024,98,145637751,36040328,695497
1024,99,139517989,36163990,695523
1024,100,275320536,36141305,696132
```

## 파일·재현

- [빌드 방법·변경 범위](measurement/README.md), [실제 빌드 설정](measurement/Makefile).
- [메타데이터·소스 SHA-256](measurement/session.json), [상태](measurement/status.json), [원시 결과](measurement/results.json).
- [실행 로그](measurement/logs/events.log), [빌드 로그](measurement/logs/build.log), [이식 패치](measurement/logs/port.patch).
- [산출물·통계·어셈블리 대조 검증](measurement/logs/artifact_audit.log), [검증 스크립트](measurement/verify_artifacts.py).
- ELF·bin·디스어셈블리·ELF 속성은 `measurement/build`에 보존한다.
- 종료 후 MCU는 halt 상태로 둔다. 측정 RAM은 남으며 원래 실행 중 RAM 상태를 복원한 것은 아니다. Flash는 처음부터 쓰지 않는다.

## 소스 이식 패치

```text
diff --git a/inner.h b/inner.h
index add9690..5f6bad4 100644
--- a/inner.h
+++ b/inner.h
@@ -174,11 +174,28 @@
 #define FNDSA_ASM_CORTEXM4   0
 #endif
 
-/* Failsafe check: if ARMv7M assembly code is detected, the compiler should
-   know about it too. */
+/* Explicit opt-in for reusing the M4 integer/DSP routines on Cortex-M55.
+   This does not enable native FP64 or MVE arithmetic. Keep the original
+   assembly selector enabled so C fallbacks cannot silently replace it. */
+#ifndef FNDSA_ASM_CORTEXM55
+#define FNDSA_ASM_CORTEXM55   0
+#endif
+#if FNDSA_ASM_CORTEXM55 && !FNDSA_ASM_CORTEXM4
+#error Cortex-M55 compatibility mode requires the M4 assembly implementation.
+#endif
+
+/* Failsafe check: an M55 build needs explicit opt-in, DSP and FP registers.
+   Do not fake compiler-provided architecture macros to bypass this check. */
 #if FNDSA_ASM_CORTEXM4
+#if FNDSA_ASM_CORTEXM55
+#if !(defined __ARM_ARCH_8M_MAIN__ && defined __ARM_FEATURE_DSP \
+    && defined __ARM_FP && ((__ARM_FP & 4) != 0))
+#error Cortex-M55 compatibility mode requires Armv8-M Mainline, DSP and FPU.
+#endif
+#else
 #if !(defined __ARM_ARCH_7EM__ && defined __ARM_FEATURE_DSP)
-#error ARMv7M+DSP assembly code selected but supported.
+#error ARMv7M+DSP assembly code selected but not supported.
+#endif
 #endif
 #endif
```

## 빌드 로그

```text
mkdir -p build
/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-gcc --version
arm-none-eabi-gcc (Arm GNU Toolchain 13.2.rel1 (Build arm-13.7)) 13.2.1 20231009
Copyright (C) 2023 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-gcc -Wall -Wextra -Wshadow -Wundef -Wno-unused-function -Wno-cast-function-type -std=c99 -ggdb3 -O3 -mthumb -mcpu=cortex-m55+nomve -mfpu=auto -mfloat-abi=hard -mcmse -fno-common -ffunction-sections -fdata-sections -DFNDSA_ASM_CORTEXM4=1 -DFNDSA_ASM_CORTEXM55=1 -DUSE_HAL_DRIVER -DSTM32N657xx -I. -I../ref -I/private/tmp/STM32CubeN6/Projects/NUCLEO-N657X0-Q/Templates/Template/FSBL/Inc -I/private/tmp/STM32CubeN6/Drivers/BSP/STM32N6xx_Nucleo -I/private/tmp/STM32CubeN6/Drivers/STM32N6xx_HAL_Driver/Inc -I/private/tmp/STM32CubeN6/Drivers/STM32N6xx_HAL_Driver/Inc/Legacy -I/private/tmp/STM32CubeN6/Drivers/CMSIS/Device/ST/STM32N6xx/Include -I/private/tmp/STM32CubeN6/Drivers/CMSIS/Include ../ref/codec.c ../ref/mq.c ../ref/sha3.c ../ref/sysrng.c ../ref/util.c ../ref/kgen.c ../ref/kgen_fxp.c ../ref/kgen_gauss.c ../ref/kgen_mp31.c ../ref/kgen_ntru.c ../ref/kgen_poly.c ../ref/kgen_zint31.c ../ref/sign.c ../ref/sign_core.c ../ref/sign_fpoly.c ../ref/sign_fpr.c ../ref/sign_sampler.c ../ref/vrfy.c ../ref/codec_cm4.s ../ref/mq_cm4.s ../ref/sha3_cm4.s ../ref/sign_fpr_cm4.s ../ref/sign_sampler_cm4.s benchmark.c platform.c clock.c /private/tmp/STM32CubeN6/Projects/NUCLEO-N657X0-Q/Templates/Template/FSBL/Src/system_stm32n6xx_fsbl.c /private/tmp/STM32CubeN6/Projects/NUCLEO-N657X0-Q/Templates/Template/FSBL/Src/stm32n6xx_hal_msp.c /private/tmp/STM32CubeN6/Drivers/CMSIS/Device/ST/STM32N6xx/Source/Templates/gcc/startup_stm32n657xx_fsbl.s /private/tmp/STM32CubeN6/Drivers/STM32N6xx_HAL_Driver/Src/stm32n6xx_hal_cortex.c /private/tmp/STM32CubeN6/Drivers/STM32N6xx_HAL_Driver/Src/stm32n6xx_hal_dma.c /private/tmp/STM32CubeN6/Drivers/STM32N6xx_HAL_Driver/Src/stm32n6xx_hal_dma_ex.c /private/tmp/STM32CubeN6/Drivers/STM32N6xx_HAL_Driver/Src/stm32n6xx_hal_exti.c /private/tmp/STM32CubeN6/Drivers/STM32N6xx_HAL_Driver/Src/stm32n6xx_hal_gpio.c /private/tmp/STM32CubeN6/Drivers/STM32N6xx_HAL_Driver/Src/stm32n6xx_hal_pwr.c /private/tmp/STM32CubeN6/Drivers/STM32N6xx_HAL_Driver/Src/stm32n6xx_hal_pwr_ex.c /private/tmp/STM32CubeN6/Drivers/STM32N6xx_HAL_Driver/Src/stm32n6xx_hal_rcc.c /private/tmp/STM32CubeN6/Drivers/STM32N6xx_HAL_Driver/Src/stm32n6xx_hal_rcc_ex.c /private/tmp/STM32CubeN6/Drivers/STM32N6xx_HAL_Driver/Src/stm32n6xx_hal.c --static -nostartfiles -Tstm32n657_sram.ld -ggdb3 -mthumb -mcpu=cortex-m55+nomve -mfpu=auto -mfloat-abi=hard -mcmse -Wl,--gc-sections -Wl,-Map=build/fndsa_m55.map -Wl,--print-memory-usage -Wl,--start-group -lc -lgcc -lm -lnosys -Wl,--end-group -o build/fndsa_m55.elf
Memory region         Used Size  Region Size  %age Used
             ROM:      109516 B       255 KB     41.94%
             RAM:       65936 B       252 KB     25.55%
         MAILBOX:        2560 B         4 KB     62.50%
/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-size build/fndsa_m55.elf
   text	   data	    bss	    dec	    hex	filename
 109448	     12	  68464	 177924	  2b704	build/fndsa_m55.elf
/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objcopy -O binary build/fndsa_m55.elf build/fndsa_m55.bin
/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-nm -n build/fndsa_m55.elf > build/symbols.txt
/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump -d build/fndsa_m55.elf > build/disassembly.txt
/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-readelf -l -A build/fndsa_m55.elf > build/elf_attributes.txt
```

## 실행·검증 로그

```text
2026-09-09T00:29:23.206410+00:00 OpenOCD: reset halt
2026-09-09T00:29:23.309246+00:00 OpenOCD: load_image {/Users/seungwon/FALCON/fn-dsa_m55/measurement/build/fndsa_m55.bin} 0x34180400 bin
2026-09-09T00:29:23.503161+00:00 109516 bytes written at address 0x34180400
downloaded 109516 bytes in 0.193000s (554.141 KiB/s)
2026-09-09T00:29:23.504097+00:00 OpenOCD: verify_image {/Users/seungwon/FALCON/fn-dsa_m55/measurement/build/fndsa_m55.bin} 0x34180400 bin
2026-09-09T00:29:24.295928+00:00 verified 109516 bytes in 0.791000s (135.208 KiB/s)
2026-09-09T00:29:24.296149+00:00 OpenOCD: reg sp 0x341ff000
2026-09-09T00:29:24.296473+00:00 sp (/32): 0x341ff000
2026-09-09T00:29:24.296596+00:00 OpenOCD: reg msp 0x341ff000
2026-09-09T00:29:24.296736+00:00 msp (/32): 0x341ff000
2026-09-09T00:29:24.296813+00:00 OpenOCD: reg psp 0x341ff000
2026-09-09T00:29:24.296935+00:00 psp (/32): 0x341ff000
2026-09-09T00:29:24.297002+00:00 OpenOCD: reg xpsr 0x01000000
2026-09-09T00:29:24.297100+00:00 xpsr (/32): 0x01000000
2026-09-09T00:29:24.297162+00:00 OpenOCD: reg primask 0x00000000
2026-09-09T00:29:24.297279+00:00 primask (/1): 0x00
2026-09-09T00:29:24.297375+00:00 OpenOCD: reg basepri 0x00000000
2026-09-09T00:29:24.297517+00:00 basepri (/8): 0x00
2026-09-09T00:29:24.297622+00:00 OpenOCD: reg faultmask 0x00000000
2026-09-09T00:29:24.297729+00:00 faultmask (/1): 0x00
2026-09-09T00:29:24.297789+00:00 OpenOCD: reg control 0x00000000
2026-09-09T00:29:24.297897+00:00 control (/3): 0x00
2026-09-09T00:29:24.297969+00:00 OpenOCD: resume 0x3418dd10
2026-09-09T00:29:25.318145+00:00 Both warmups, valid/tampered signature checks and host fingerprints passed.
2026-09-09T00:29:25.318654+00:00 OpenOCD: write_memory 0x341ff088 32 {0x474f3130}
2026-09-09T00:29:25.322069+00:00 progress counts=[[0, 0, 0], [0, 0, 0]], degree=512, operation=0, error=0
2026-09-09T00:30:25.336159+00:00 progress counts=[[100, 100, 100], [100, 100, 100]], degree=1024, operation=2, error=0
2026-09-09T00:30:25.341976+00:00 OpenOCD: halt
2026-09-09T00:30:25.371117+00:00 All 600 measured operations passed; both final fingerprints match host. No Flash was written. M55 left halted.
2026-09-09T00:36:19.532754+00:00 Owned M55 OpenOCD server shut down after completed measurement; ST-LINK released, board left halted.
```

## 산출물 사후 검증 로그

```text
PASS: all 600 raw mailbox cycles match JSON; mean/median/sample-SD/min/max recomputed.
PASS: current source, ELF and binary SHA-256 match the measured session.
PASS: both final fingerprints match the completed M4 measurement and scalar host oracle.
PASS: Original M4 path accepted
PASS: Explicit M55 assembly compatibility accepted
PASS: M55 without explicit compatibility rejected as intended
PASS: M55 compatibility with ASM disabled rejected as intended
PASS: codec_cm4.s assembled .text identical under M4/M55 flags (228 bytes).
PASS: mq_cm4.s assembled .text identical under M4/M55 flags (1424 bytes).
PASS: sha3_cm4.s assembled .text identical under M4/M55 flags (4184 bytes).
PASS: sign_fpr_cm4.s assembled .text identical under M4/M55 flags (4460 bytes).
PASS: sign_sampler_cm4.s assembled .text identical under M4/M55 flags (904 bytes).
PASS: summed measured duration 55.835982s <= completion observation 60.017505s.
Under the nominal CPU clock, even one uncounted 2^32-cycle wrap would exceed the observed whole-run time; a consistency check, not external clock calibration.
```

## 2026-09-09 새 B 단계: mlkem-native Nucleo 환경

`fn-dsa_m55/ref`를 직접 빌드한 새 실험은
[measurement_mlkem_native/result.md](measurement_mlkem_native/result.md)에
별도로 기록한다. 기존 위 수치는 이전 AXISRAM 환경의 결과이며 새 TCM 환경의
측정값이 아니다. 새 B는 빌드/정적 감사/호스트 출력 검사를 통과했다.

2026-09-10 재연결 후 갱신: **SWD 연결·TCM 설정·RAM 적재는 성공**했다.
그러나 FN-DSA 호출 전 Zephyr 시작 코드에서 확장 ITCM 접근의 ECC fault가
발생해 **새 B의 유효한 보드 측정값은 아직 없다**. TCM 전체 초기화/CPU 복사도
해결하지 못했다. 같은 보드의 원본 ML-KEM OPT1은 시작 단계만 통과했으며,
그 이미지는 첫 64 KiB 안에 들어가 FN-DSA의 확장 ITCM 접근과 같지 않다.
진단 로그·fault 레지스터·판단 범위는 위 링크의 2026-09-10 절에 기록했다.
ECC를 끄거나 측정 메모리를 바꾸는 우회는 채택하지 않았고, M4와 Flash는
건드리지 않았다.

추가 원인 조사는 [TCM 오류 원인 보고서](measurement_mlkem_native/diagnostics/cause.md)에
기록했다. FN-DSA 없이 동일 복사 루틴의 코드 위치만 바꾼 시험에서도 오류가
재현됐으며, MVE 없는 정수 복사에서도 같은 조합이 실패했다. 동일 입력을 DTCM에
둔 진단은 5/5 바이트 검증을 통과했다. 실제 구현의 배치 변경이나 새 성능 측정은
아직 수행하지 않았다.

## 2026-09-10 수정 후 새 B 단계 완료 — 최신 결과

11:03:28 KST에 본 측정을 마쳤다. `fn-dsa_m55/ref`의 암호 구현은 그대로 두고,
실행 코드를 ITCM에 유지하면서 전역 상수·초기값을 DTCM으로 옮겼다.
시작 초기화도 적재된 상수/초기값을 보존하도록 수정했다.
ECC 검사는 ON, CPU/SYS/HCLK 800/400/200 MHz, 캐시는 OFF다.
**mlkem-native 기반 환경이지만 상수 배치·시작 초기화에는 명시적 차이가 있다.**

각 연산 10 batches × (10 warmup + 10 measured), 크기 512/1024 총 600회 계측.
대표값은 10개 block total의 upper median ÷ 10이다.

| 크기 | 키생성 cycles | 서명 cycles | 검증 cycles |
|---|---:|---:|---:|
| 512 | 51,998,993 | 17,434,921 | 372,321 |
| 1024 | 261,461,140 | 37,347,834 | 729,270 |

호스트 출력 해시 22개 일치, 변조서명 거부 PASS, 종료 fault 레지스터 0,
측정 전후 ECC 검사 활성 상태 확인. M4/Flash 변경 없음. M55는 종료 후 reset했고
OpenOCD/GDB를 종료해 프로브를 반환했다. 이전 결과/실패 ELF는 보존했다.

- [상세 조건·평균/대표값·판단 한계](measurement_mlkem_native/result.md)
- [수정한 위치와 원리](measurement_mlkem_native/diagnostics/workaround.md)
- [본 측정 원시 로그](measurement_mlkem_native/runs/full-20260910T020147Z/raw.log)
- [60개 batch 원시 수치/세션](measurement_mlkem_native/runs/full-20260910T020147Z/run.json)
- [통계 및 사후 검증 JSON](measurement_mlkem_native/results.json)

기존 M4 A와는 메모리·컴파일러·클럭·계측 방식이 달라 이 결과의 비율을
순수한 M4→M55 코어 개선율이라고 해석하지 않는다. 이후 M55 최적화는 이 B의
배치/환경/입력/통계를 고정한 상태에서 비교한다.

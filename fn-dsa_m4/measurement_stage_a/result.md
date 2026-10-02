# Stage A: FN-DSA M4 선행 구현 재측정 / -O3 / 100회

상태: **측정·검증·Flash 복원 완료**. 갱신: `2026-09-09T12:10:54.257951+00:00`.

추가 [오프라인 감사](audit.json)도 통과했다. 원본 ref·실제 계측 파일·ELF/바이너리·백업 해시, 600개 원시 사이클의 통계 및 호스트 체크섬을 다시 대조했다. 기존 Flash 실험과 평균 차이는 연산당 0.07 cycle 이내로 사실상 같은 결과다. 이 감사는 보드에 재접속하지 않으며 Flash 복원은 아래 실제 `verify_image` 성공 로그로 확인한다.

현재 연결된 STM32L4R/L4S에서 수행하는 대체 보드 실험이다. 논문 당시 코드·F407의 완전 재현이 아니다. 기존 실험은 보존하고 별도 새 세션으로 측정한다.

Stage B의 mlkem-native 기반 M55 환경과는 클럭·컴파일러·메모리·OS·반복 통계 방식이 다르다. A→B를 순수 코어 개선 또는 TCM 단독 효과로 해석하지 않는다. B가 후속 M55 최적화의 기준점이다.

## 조건

| 항목 | 실제 측정 설정 |
|---|---|
| 소스 | `fn-dsa_m4/ref`, `a5f15894bf1a68017074650d5298cecf9bb29a79`; 원본 C/헤더/어셈블리 수정 없음 |
| 컴파일러 | Arm GNU Toolchain 13.2.Rel1 / GCC 13.2.1 |
| 컴파일 | `-O3 -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16`; LTO/fast-math 없음 |
| M4 최적화 | `FNDSA_ASM_CORTEXM4=1`, 제공된 5개 `.s` 및 인라인 어셈블리 사용 |
| 연산 경로 | 키 생성 고정소수점; 서명 정수 기반 FP64 에뮬레이션; MVE 없음 |
| 장비 | STM32L4R/L4S, CPUID `0x410fc241`, ST-LINK `066DFF363355473043205442` |
| 클럭 | 내부 MSI, 공칭 CPU/HCLK 24 MHz, APB1 12 MHz, APB2 24 MHz; Range 1 normal |
| Flash 설정 | I/D cache OFF, prefetch OFF, **1 wait state** |
| 코드·상수 | Flash `0x081C0000`부터, 최대 256 KiB의 백업·공백 확인된 영역 |
| 데이터·스택 | SRAM3 (`0x20040000`부터), stack top `0x200A0000` |
| 결과·진행 상태 | 별도 SRAM2 `0x20030000`; 계측 구간 밖에서 갱신 |
| 반복 | FN-DSA-512/1024 각각 키 생성·서명·검증 100회; 크기별 워밍업 각 1회 제외 |
| 입력 | 매회 새 결정적 시드로 키 생성 → 그 키로 서명 → 해당 서명 검증; 메시지 `blah` 4바이트, 빈 context, RAW |
| 난수 | 내부 SHAKE256, seeded/temp API; 외부 RNG 비용 제외 |
| 타이머 | DWT CYCCNT, 인터럽트/SysTick 비활성화, API 전체 시간; 내부 재시도 포함 |
| 제외 비용 | 시드 준비, 체크섬, 로그, 통계 처리; 함수별 프로파일링 훅 없음 |
| 모니터링 | 약 60초마다 SRAM2 상태 136바이트 읽기; 본 측정 중 코어 halt/reset/Flash 쓰기 없음 |

모니터링은 CPU를 정지시키지 않고 알고리즘 데이터와 다른 SRAM bank를 읽는다. 디버그 버스 접근의 영향이 수학적으로 0이라고 보장하지는 않는다.

DWT는 32비트 차분을 사용한다. API 한 번이 2^32 cycles(24 MHz에서 약 179초) 미만이라는 전제가 있으며, 다중 wrap 검출용 인터럽트는 넣지 않았다.

Flash 0 WS는 이 칩에서 HCLK 20 MHz 이하까지만 허용되므로 24 MHz에서는 1 WS를 사용한다. [ST RM0432 §3.3.3, Table 12](https://www.st.com/resource/en/reference_manual/dm00310109-stm32l4-series-advanced-armbased-32bit-mcus-stmicroelectronics.pdf)

논문과 다른 점: L4R/L4S 보드·SRAM 배치·Flash 1 WS·클럭 소스·ST HAL 초기화, 최신 소스/스킴, -O3, 100회다. 최신 코드의 공개키 NTT 표현·mu 처리 등도 포함하므로 논문 대비 차이를 -O3 효과만으로 해석하면 안 된다.

## 진행 및 정확성

- 현재 차수: 1024, 반복 인덱스: 99, 단계: 검증.
- 완료 횟수 [키 생성, 서명, 검증]: 512 `[100, 100, 100]`, 1024 `[100, 100, 100]`.
- 상태 `0x600d0000`, 오류 `0x00000000`.
- 설정값: core_clock=24000000, FLASH_ACR=`0x00000001`, VTOR=`0x081c0000`, PRIMASK=1.
- 워밍업 검증: True. 정상 서명 검증·변조 서명 거부 및 두 크기의 호스트 체크섬 대조.
- 전체 업스트림 portable C 테스트/KAT는 앞선 참조 프로파일링에서 통과했다. 이번 M4 경로는 별도 워밍업 대조와 100회 생성·서명·검증으로 확인한다.
- 결정적 시드는 벤치마크 전용이다. FNV-1a 체크섬 일치는 진단용이며 암호학적 동등성 증명은 아니다.

## 측정 결과

표준편차는 표본 표준편차다. 이상치를 임의로 제외하지 않았다. 시간은 공칭 24 MHz 환산값이다.

| 크기 | 단계 | 횟수 | 평균 cycles | 중앙값 | 표준편차 | 최소 | 최대 | 평균 ms |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| 512 | keygen | 100 | 72,795,466.49 | 62,270,050.0 | 24,623,138.40 | 54,006,043 | 154,557,236 | 3033.144 |
| 512 | sign | 100 | 22,013,521.04 | 22,024,159.5 | 87,833.47 | 21,805,258 | 22,208,600 | 917.230 |
| 512 | verify | 100 | 439,739.46 | 446,608.5 | 8,729.55 | 428,815 | 447,249 | 18.322 |
| 1024 | keygen | 100 | 295,754,302.83 | 252,264,813.5 | 132,731,637.42 | 178,810,167 | 762,220,922 | 12323.096 |
| 1024 | sign | 100 | 47,238,188.12 | 47,230,294.5 | 113,050.51 | 47,037,647 | 47,514,655 | 1968.258 |
| 1024 | verify | 100 | 866,016.35 | 871,892.5 | 8,520.27 | 853,666 | 872,996 | 36.084 |

### 회차별 원시 사이클

```csv
degree,index,keygen_cycles,sign_cycles,verify_cycles
512,1,60959184,21807525,446718
512,2,87801198,22024168,447036
512,3,89906012,21994574,446553
512,4,57933290,22043535,429027
512,5,58978600,22037972,429145
512,6,55873391,22044600,428913
512,7,87222685,21934565,446257
512,8,56365111,22068449,429275
512,9,63439977,22029804,446860
512,10,59351099,21991054,446600
512,11,54006210,22099554,428868
512,12,56364777,22119258,447013
512,13,63438808,22080916,429083
512,14,57346547,22015286,428820
512,15,63438641,22026392,446886
512,16,54006878,22088594,446736
512,17,136916255,21962960,446688
512,18,60098471,21916429,429207
512,19,72163104,21936198,446984
512,20,56620200,21945495,429218
512,21,54006043,21975871,429071
512,22,60590692,21936197,446791
512,23,60590024,21977109,429311
512,24,54006210,21907469,447249
512,25,81012207,22088419,446954
512,26,64419910,22121084,446777
512,27,68921464,22080094,429139
512,28,139949301,22040233,429230
512,29,60591026,21946343,428847
512,30,112244135,22077573,429010
512,31,56855495,21830086,446821
512,32,154557236,22042265,428820
512,33,54496761,22159281,446617
512,34,97093840,22039983,429079
512,35,141672847,22095517,447064
512,36,100708252,21998033,446516
512,37,103676562,21870744,446911
512,38,83754563,22009444,428931
512,39,118519480,21964484,446908
512,40,54497596,21946228,428815
512,41,63553045,22149927,446531
512,42,57740405,21919926,429060
512,43,83491229,21998048,446698
512,44,54006377,22153696,446521
512,45,54497763,21975869,429188
512,46,54006711,22079883,429087
512,47,55873558,22060523,446939
512,48,71909351,22028672,446917
512,49,58232459,21889241,429181
512,50,54496761,21952634,429191
512,51,63437973,21882649,429286
512,52,60591527,22024000,446686
512,53,72002871,21895454,446841
512,54,58723010,22052763,446394
512,55,56620868,22059238,447073
512,56,81453013,22041931,429262
512,57,75520484,21946633,429111
512,58,69436547,22012154,429188
512,59,75956356,22066048,446568
512,60,54496594,22163092,429217
512,61,60589690,22024151,446862
512,62,142505715,22002056,447218
512,63,110834712,21868992,447149
512,64,55478531,21990437,447123
512,65,87679973,22037880,429106
512,66,102126565,22025112,446755
512,67,64043262,21900974,446767
512,68,62062512,22130067,446528
512,69,54497596,22059015,446827
512,70,62732343,21883776,429333
512,71,70039999,22094328,446970
512,72,67287574,22096247,446526
512,73,58231624,22099441,428956
512,74,56460468,21883913,429492
512,75,62457038,22088519,446974
512,76,55873565,21895272,446725
512,77,72533599,21936371,446872
512,78,54987479,22129369,447017
512,79,97801953,22003006,446855
512,80,62083062,22025521,446986
512,81,55479700,22208600,429381
512,82,64420244,22182026,446947
512,83,67192885,21870950,446975
512,84,54006377,22001708,446845
512,85,54006043,21982641,429098
512,86,54497930,22053284,447129
512,87,54006544,21905826,446703
512,88,109815587,22122115,446769
512,89,57741240,22093842,446638
512,90,61571126,22009658,428970
512,91,63221892,21805258,446689
512,92,88256287,22158724,446967
512,93,97563417,22073882,428886
512,94,135081659,21958005,447234
512,95,54006210,21944557,429252
512,96,67173838,22028745,446959
512,97,82849103,22103098,428940
512,98,138914133,21927236,446985
512,99,54496928,21972351,429175
512,100,54497262,22148985,446676
1024,1,441576314,47280438,854300
1024,2,257409649,47230334,871801
1024,3,322034857,47400744,853865
1024,4,219797972,47140680,871950
1024,5,239358392,47165664,872391
1024,6,546184732,47047276,872928
1024,7,538312038,47154468,854373
1024,8,252381727,47067175,872190
1024,9,304710623,47262497,871916
1024,10,206464281,47257670,872004
1024,11,178810308,47220047,854443
1024,12,357482107,47397712,872029
1024,13,179746385,47137732,871782
1024,14,180681898,47044966,872296
1024,15,186036418,47054886,854124
1024,16,233662351,47258165,872460
1024,17,451504119,47200770,871788
1024,18,188327557,47200334,872303
1024,19,194038046,47204651,871823
1024,20,220227335,47230255,871885
1024,21,286087526,47394324,871968
1024,22,204515368,47144007,854463
1024,23,392673047,47261494,872487
1024,24,436144103,47221021,854210
1024,25,196506301,47131166,871965
1024,26,762220922,47296574,872271
1024,27,189200471,47295070,872122
1024,28,275401269,47359328,872014
1024,29,197010477,47130708,872597
1024,30,178810449,47393897,871761
1024,31,277850168,47467583,853880
1024,32,179745831,47380170,854462
1024,33,296251927,47251077,854090
1024,34,252147900,47219586,854146
1024,35,301885868,47169878,872188
1024,36,282436739,47162591,872003
1024,37,188775310,47419862,871901
1024,38,228911524,47041979,871780
1024,39,566702424,47186539,853802
1024,40,304750540,47084416,854279
1024,41,285189362,47111804,853828
1024,42,269838422,47326252,871812
1024,43,671958981,47106001,872599
1024,44,333167195,47201727,872381
1024,45,196499984,47293653,871555
1024,46,391818952,47361584,871916
1024,47,184079637,47303183,872222
1024,48,199810844,47344166,853666
1024,49,188326570,47236426,872216
1024,50,232082599,47246560,854041
1024,51,183568439,47122824,854517
1024,52,317491696,47514655,872033
1024,53,380437983,47258178,871590
1024,54,178810308,47313379,854331
1024,55,195911322,47170830,871955
1024,56,194037053,47037647,872043
1024,57,306574077,47100616,871829
1024,58,182632227,47429599,872269
1024,59,434215373,47402407,854297
1024,60,361261675,47174533,872167
1024,61,351285275,47044612,872126
1024,62,251274563,47093715,854326
1024,63,216405986,47240872,854216
1024,64,212747151,47281445,853820
1024,65,582464675,47322567,871935
1024,66,333691547,47429452,872117
1024,67,505351590,47194239,872593
1024,68,318151124,47166372,871900
1024,69,182632503,47311817,853904
1024,70,318349886,47233102,872261
1024,71,215975636,47157373,853891
1024,72,617863606,47147680,854663
1024,73,178810453,47154094,854050
1024,74,178810590,47262371,872232
1024,75,380250470,47152841,854181
1024,76,605701010,47401133,854268
1024,77,542250533,47072846,872083
1024,78,385520803,47451489,871877
1024,79,178810167,47340654,854517
1024,80,278520340,47165383,872419
1024,81,273266224,47398730,871695
1024,82,202620481,47076537,872238
1024,83,178810308,47227139,872014
1024,84,371319483,47214902,854053
1024,85,288598022,47145212,854307
1024,86,205528909,47236791,872371
1024,87,212298552,47156842,854494
1024,88,197858966,47267893,871850
1024,89,192660104,47228559,872298
1024,90,192149893,47137234,872235
1024,91,285945244,47165127,872114
1024,92,189772717,47338209,854465
1024,93,194974258,47291628,872221
1024,94,287517033,47327019,872155
1024,95,593209613,47201115,871997
1024,96,551117463,47369016,854918
1024,97,203553597,47398618,871643
1024,98,187392044,47236588,872097
1024,99,178810167,47393671,871788
1024,100,368671325,47360167,872996
```

## Flash 보존

- 전체 2 MiB 백업: `/Users/seungwon/FALCON/fn-dsa_m4/measurement_stage_a/backups/m4-original-zdqc3j0p/flash_08000000_2mib.bin`.
- SHA-256: `8899d461cef13b43b72c548e63fd1259df6d3e4b8bbd8eaeba44b6bdaececdf3`; 장비에 대한 verify_image 검증 완료.
- 사용 슬롯은 사전에 모든 바이트가 0xFF임을 확인했다. 기존 boot image와 option bytes는 쓰지 않는다.
- 측정 슬롯 복원 상태: **측정 슬롯 erase 완료; 전체 Flash가 백업과 일치함을 verify_image로 확인**.
- 복원 시 측정용으로 쓴 Flash 페이지만 erase한 뒤 전체 Flash를 백업과 검증한다. MCU의 실행 중 RAM 상태까지 복원하는 것은 아니다.

## 로그·재현

- [빌드 로그](logs/build.log), [실행·모니터링·복원 로그](logs/events.log), [진행 상태](status.json).
- [세션 메타데이터](session.json), [원시 결과 JSON](results.json), [측정 코드](benchmark.c), [제어·모니터링 코드](controller.py).
- [진행 확인·복구 방법](README.md).
- [논문 최적화 요약](../../REFERENCE/falcon_m4_implementation.md).

### 실행 로그

```text
2026-09-09T11:36:04.982301+00:00 OpenOCD: halt
2026-09-09T11:36:05.072255+00:00 OpenOCD: dump_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement_stage_a/backups/m4-original-zdqc3j0p/flash_08000000_2mib.bin} 0x08000000 0x200000
2026-09-09T11:37:01.948521+00:00 dumped 2097152 bytes in 56.874741s (36.009 KiB/s)
2026-09-09T11:37:01.952573+00:00 OpenOCD: verify_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement_stage_a/backups/m4-original-zdqc3j0p/flash_08000000_2mib.bin} 0x08000000 bin
2026-09-09T11:37:14.015696+00:00 verified 2097152 bytes in 12.061934s (169.790 KiB/s)
2026-09-09T11:37:14.018194+00:00 Fresh full backup verified; entire high 256 KiB slot is already blank (read-only check). Original boot image will be preserved.
2026-09-09T11:37:14.131260+00:00 OpenOCD: reset halt
2026-09-09T11:37:14.319987+00:00 OpenOCD: verify_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement_stage_a/backups/m4-original-zdqc3j0p/flash_08000000_2mib.bin} 0x08000000 bin
2026-09-09T11:39:11.332060+00:00 verified 2097152 bytes in 117.011307s (17.503 KiB/s)
2026-09-09T11:39:11.337477+00:00 OpenOCD: flash write_image erase {/Users/seungwon/FALCON/fn-dsa_m4/measurement_stage_a/build/fndsa_m4.bin} 0x081c0000 bin
2026-09-09T11:39:15.264701+00:00 auto erase enabled
wrote 103064 bytes from file /Users/seungwon/FALCON/fn-dsa_m4/measurement_stage_a/build/fndsa_m4.bin in 3.925578s (25.639 KiB/s)
2026-09-09T11:39:15.265487+00:00 OpenOCD: verify_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement_stage_a/build/fndsa_m4.bin} 0x081c0000 bin
2026-09-09T11:39:18.321463+00:00 verified 103060 bytes in 3.055246s (32.942 KiB/s)
2026-09-09T11:39:18.322129+00:00 OpenOCD: reg sp 0x200a0000
2026-09-09T11:39:18.322682+00:00 sp (/32): 0x200a0000
2026-09-09T11:39:18.322964+00:00 OpenOCD: reg msp 0x200a0000
2026-09-09T11:39:18.323257+00:00 msp (/32): 0x200a0000
2026-09-09T11:39:18.323415+00:00 OpenOCD: reg psp 0x200a0000
2026-09-09T11:39:18.323637+00:00 psp (/32): 0x200a0000
2026-09-09T11:39:18.323783+00:00 OpenOCD: reg xpsr 0x01000000
2026-09-09T11:39:18.324002+00:00 xpsr (/32): 0x01000000
2026-09-09T11:39:18.324138+00:00 OpenOCD: reg primask 0x00000000
2026-09-09T11:39:18.324341+00:00 primask (/1): 0x00
2026-09-09T11:39:18.324469+00:00 OpenOCD: reg basepri 0x00000000
2026-09-09T11:39:18.324697+00:00 basepri (/8): 0x00
2026-09-09T11:39:18.324960+00:00 OpenOCD: reg faultmask 0x00000000
2026-09-09T11:39:18.325368+00:00 faultmask (/1): 0x00
2026-09-09T11:39:18.325594+00:00 OpenOCD: reg control 0x00000000
2026-09-09T11:39:18.325885+00:00 control (/3): 0x00
2026-09-09T11:39:18.326063+00:00 OpenOCD: resume 0x081ccbf0
2026-09-09T11:39:42.498338+00:00 Both warmups and tampered-signature checks passed; scalar host fingerprints match.
2026-09-09T11:39:42.499179+00:00 OpenOCD: write_memory 0x20030078 32 {0x474f3130}
2026-09-09T11:39:42.512223+00:00 progress counts=[[0, 0, 0], [0, 0, 0]], degree=512, operation=0, state=0x52554e21, error=0
2026-09-09T11:40:42.524014+00:00 progress counts=[[16, 16, 16], [0, 0, 0]], degree=512, operation=0, state=0x52554e21, error=0
2026-09-09T11:41:42.543692+00:00 progress counts=[[31, 31, 31], [0, 0, 0]], degree=512, operation=0, state=0x52554e21, error=0
2026-09-09T11:42:42.647836+00:00 progress counts=[[44, 43, 43], [0, 0, 0]], degree=512, operation=1, state=0x52554e21, error=0
2026-09-09T11:43:42.669624+00:00 progress counts=[[61, 60, 60], [0, 0, 0]], degree=512, operation=1, state=0x52554e21, error=0
2026-09-09T11:44:42.679095+00:00 progress counts=[[75, 75, 75], [0, 0, 0]], degree=512, operation=0, state=0x52554e21, error=0
2026-09-09T11:45:42.701116+00:00 progress counts=[[92, 91, 91], [0, 0, 0]], degree=512, operation=1, state=0x52554e21, error=0
2026-09-09T11:46:42.722090+00:00 progress counts=[[100, 100, 100], [1, 1, 1]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T11:47:42.744546+00:00 progress counts=[[100, 100, 100], [5, 5, 5]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T11:48:42.762969+00:00 progress counts=[[100, 100, 100], [8, 8, 8]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T11:49:42.781508+00:00 progress counts=[[100, 100, 100], [14, 13, 13]], degree=1024, operation=1, state=0x52554e21, error=0
2026-09-09T11:50:42.802049+00:00 progress counts=[[100, 100, 100], [18, 18, 18]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T11:51:42.818139+00:00 progress counts=[[100, 100, 100], [23, 23, 23]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T11:52:42.827354+00:00 progress counts=[[100, 100, 100], [26, 25, 25]], degree=1024, operation=1, state=0x52554e21, error=0
2026-09-09T11:53:42.844405+00:00 progress counts=[[100, 100, 100], [31, 31, 31]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T11:54:42.857499+00:00 progress counts=[[100, 100, 100], [35, 35, 35]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T11:55:42.878691+00:00 progress counts=[[100, 100, 100], [39, 39, 39]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T11:56:42.890981+00:00 progress counts=[[100, 100, 100], [43, 42, 42]], degree=1024, operation=1, state=0x52554e21, error=0
2026-09-09T11:57:42.913262+00:00 progress counts=[[100, 100, 100], [47, 47, 47]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T11:58:42.937190+00:00 progress counts=[[100, 100, 100], [52, 52, 52]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T11:59:42.958860+00:00 progress counts=[[100, 100, 100], [57, 57, 57]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T12:00:42.983154+00:00 progress counts=[[100, 100, 100], [61, 61, 61]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T12:01:43.000856+00:00 progress counts=[[100, 100, 100], [65, 65, 65]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T12:02:43.017358+00:00 progress counts=[[100, 100, 100], [68, 68, 68]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T12:03:43.039798+00:00 progress counts=[[100, 100, 100], [72, 72, 72]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T12:04:43.049749+00:00 progress counts=[[100, 100, 100], [76, 75, 75]], degree=1024, operation=1, state=0x52554e21, error=0
2026-09-09T12:05:43.059416+00:00 progress counts=[[100, 100, 100], [79, 79, 79]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T12:06:43.081854+00:00 progress counts=[[100, 100, 100], [84, 84, 84]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T12:07:43.102664+00:00 progress counts=[[100, 100, 100], [89, 89, 89]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T12:08:43.116536+00:00 progress counts=[[100, 100, 100], [94, 94, 94]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T12:09:43.133571+00:00 progress counts=[[100, 100, 100], [97, 97, 97]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T12:10:43.149057+00:00 progress counts=[[100, 100, 100], [100, 100, 100]], degree=1024, operation=2, state=0x600d0000, error=0
2026-09-09T12:10:43.149686+00:00 OpenOCD: halt
2026-09-09T12:10:43.310621+00:00 All 600 timed operations passed, and both final fingerprints match the scalar host oracle.
2026-09-09T12:10:43.324723+00:00 OpenOCD: halt
2026-09-09T12:10:43.326924+00:00 OpenOCD: flash erase_address 0x081c0000 0x1a000
2026-09-09T12:10:43.974098+00:00 erased address 0x081c0000 (length 106496) in 0.645142s (161.205 KiB/s)
2026-09-09T12:10:43.975403+00:00 OpenOCD: verify_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement_stage_a/backups/m4-original-zdqc3j0p/flash_08000000_2mib.bin} 0x08000000 bin
2026-09-09T12:10:54.058804+00:00 verified 2097152 bytes in 10.081970s (203.135 KiB/s)
2026-09-09T12:10:54.062540+00:00 OpenOCD: reset halt
2026-09-09T12:10:54.257041+00:00 Restoration verified. Original Flash restored; board left reset/halted.
```

### 빌드 로그

```text
mkdir -p build
/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-gcc --version
arm-none-eabi-gcc (Arm GNU Toolchain 13.2.rel1 (Build arm-13.7)) 13.2.1 20231009
Copyright (C) 2023 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-gcc -Wall -Wextra -Wshadow -Wundef -Wno-unused-function -Wno-cast-function-type -std=c99 -ggdb3 -O3 -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -fno-common -ffunction-sections -fdata-sections -DFNDSA_ASM_CORTEXM4=1 -DUSE_HAL_DRIVER -DSTM32L4R5xx -DUSER_VECT_TAB_ADDRESS -DVECT_TAB_OFFSET=0x001C0000U -I. -I../ref -I/Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Inc -I/Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Inc/Legacy -I/Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/CMSIS/Device/ST/STM32L4xx/Include -I/Users/seungwon/.platformio/packages/framework-cmsis/CMSIS/Core/Include ../ref/codec.c ../ref/mq.c ../ref/sha3.c ../ref/sysrng.c ../ref/util.c ../ref/kgen.c ../ref/kgen_fxp.c ../ref/kgen_gauss.c ../ref/kgen_mp31.c ../ref/kgen_ntru.c ../ref/kgen_poly.c ../ref/kgen_zint31.c ../ref/sign.c ../ref/sign_core.c ../ref/sign_fpoly.c ../ref/sign_fpr.c ../ref/sign_sampler.c ../ref/vrfy.c ../ref/codec_cm4.s ../ref/mq_cm4.s ../ref/sha3_cm4.s ../ref/sign_fpr_cm4.s ../ref/sign_sampler_cm4.s benchmark.c platform.c /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/CMSIS/Device/ST/STM32L4xx/Source/Templates/system_stm32l4xx.c /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/CMSIS/Device/ST/STM32L4xx/Source/Templates/gcc/startup_stm32l4r5xx.s /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_cortex.c /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_rcc.c /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_rcc_ex.c /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_pwr.c /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_pwr_ex.c /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal.c --static -nostartfiles -Tstm32l4rs_flash.ld -ggdb3 -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -Wl,--gc-sections -Wl,-Map=build/fndsa_m4.map -Wl,--print-memory-usage -Wl,--start-group -lc -lgcc -lm -lnosys -Wl,--end-group -o build/fndsa_m4.elf
Memory region         Used Size  Region Size  %age Used
           FLASH:      103060 B       256 KB     39.31%
         MAILBOX:        2536 B        64 KB      3.87%
             RAM:      131472 B       384 KB     33.44%
/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-size build/fndsa_m4.elf
   text	   data	    bss	    dec	    hex	filename
 103024	     12	 133976	 237012	  39dd4	build/fndsa_m4.elf
/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objcopy -O binary build/fndsa_m4.elf build/fndsa_m4.bin
/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-nm -n build/fndsa_m4.elf > build/symbols.txt
clang -O3 -std=c99 -DBENCH_HOST -DFNDSA_PROFILE=0 -DFNDSA_ASM_CORTEXM4=0 \
 -DFNDSA_AVX2=0 -DFNDSA_SSE2=0 -DFNDSA_NEON=0 -DFNDSA_NEON_SHA3=0 -DFNDSA_RV64D=0 -DFNDSA_64=0 \
 -I. -I../ref -I../../fn-dsa_ref/profiling benchmark.c \
 ../../fn-dsa_ref/profiling/build/host-0/generated/codec.c ../../fn-dsa_ref/profiling/build/host-0/generated/mq.c ../../fn-dsa_ref/profiling/build/host-0/generated/sha3.c ../../fn-dsa_ref/profiling/build/host-0/generated/sysrng.c ../../fn-dsa_ref/profiling/build/host-0/generated/util.c ../../fn-dsa_ref/profiling/build/host-0/generated/kgen.c ../../fn-dsa_ref/profiling/build/host-0/generated/kgen_fxp.c ../../fn-dsa_ref/profiling/build/host-0/generated/kgen_gauss.c ../../fn-dsa_ref/profiling/build/host-0/generated/kgen_mp31.c ../../fn-dsa_ref/profiling/build/host-0/generated/kgen_ntru.c ../../fn-dsa_ref/profiling/build/host-0/generated/kgen_poly.c ../../fn-dsa_ref/profiling/build/host-0/generated/kgen_zint31.c ../../fn-dsa_ref/profiling/build/host-0/generated/sign.c ../../fn-dsa_ref/profiling/build/host-0/generated/sign_core.c ../../fn-dsa_ref/profiling/build/host-0/generated/sign_fpoly.c ../../fn-dsa_ref/profiling/build/host-0/generated/sign_fpr.c ../../fn-dsa_ref/profiling/build/host-0/generated/sign_sampler.c ../../fn-dsa_ref/profiling/build/host-0/generated/vrfy.c -lm -o build/host_oracle
build/host_oracle > build/host_oracle.json
```

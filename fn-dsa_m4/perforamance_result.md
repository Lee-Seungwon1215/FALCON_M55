# FN-DSA M4 성능 측정: 최신 ref / -O3 / 100회

> 새 A 단계 재측정 **완료 (2026-09-09 21:10:54 KST)**: [Stage A 결과](measurement_stage_a/result.md), [실행 조건](measurement_stage_a/README.md), [최종 감사](measurement_stage_a/audit.json). 아래 기존 결과는 보존한다.

> 추가 실험: [SRAM·캐시 OFF·CPU/HCLK 24 MHz 공통 조건 측정](measurement_controlled/result.md), [M4↔M55 비교](../comparison_m4_m55/result.md). 아래 기존 Flash 실행 결과는 그대로 보존한다.

상태: **측정·검증·Flash 복원 완료 (종료 후 데이터 읽기 복구)**. 갱신: `2026-09-09T00:31:08.010526+00:00`.

현재 연결된 STM32L4R/L4S에서 수행하는 대체 보드 실험이다. 논문 당시 코드·F407의 완전 재현이 아니다.

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

종료 후 수집 복구: 모든 100회 계산이 끝나 WFI 대기 상태에 들어간 뒤, 실행 중 디버그 읽기가 0을 반환했다. 코어를 halt한 후 DONE 상태·600개 사이클·최종 체크섬을 검증해 수집했다. 계측 중 halt한 것이 아니며 재측정도 하지 않았다. 처음의 수집 오류와 복구 과정은 아래 로그에 보존했다.

## 측정 결과

표준편차는 표본 표준편차다. 이상치를 임의로 제외하지 않았다. 시간은 공칭 24 MHz 환산값이다.

| 크기 | 단계 | 횟수 | 평균 cycles | 중앙값 | 표준편차 | 최소 | 최대 | 평균 ms |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| 512 | keygen | 100 | 72,795,466.52 | 62,270,050.0 | 24,623,138.61 | 54,006,043 | 154,557,240 | 3033.144 |
| 512 | sign | 100 | 22,013,521.04 | 22,024,159.5 | 87,833.41 | 21,805,258 | 22,208,600 | 917.230 |
| 512 | verify | 100 | 439,739.46 | 446,608.5 | 8,729.55 | 428,815 | 447,249 | 18.322 |
| 1024 | keygen | 100 | 295,754,302.90 | 252,264,813.5 | 132,731,637.70 | 178,810,167 | 762,220,922 | 12323.096 |
| 1024 | sign | 100 | 47,238,188.17 | 47,230,294.5 | 113,050.49 | 47,037,647 | 47,514,655 | 1968.258 |
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
512,17,136916257,21962960,446688
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
512,32,154557240,22042265,428820
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
512,44,54006377,22153694,446521
512,45,54497767,21975869,429188
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
512,76,55873558,21895274,446725
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
1024,2,257409643,47230334,871801
1024,3,322034857,47400744,853865
1024,4,219797972,47140680,871950
1024,5,239358392,47165664,872391
1024,6,546184731,47047276,872928
1024,7,538312038,47154468,854373
1024,8,252381727,47067175,872190
1024,9,304710625,47262497,871916
1024,10,206464281,47257670,872004
1024,11,178810308,47220047,854443
1024,12,357482107,47397712,872029
1024,13,179746385,47137732,871782
1024,14,180681898,47044963,872296
1024,15,186036420,47054886,854124
1024,16,233662351,47258165,872460
1024,17,451504119,47200770,871788
1024,18,188327557,47200334,872303
1024,19,194038040,47204651,871823
1024,20,220227335,47230255,871885
1024,21,286087526,47394324,871968
1024,22,204515368,47144007,854463
1024,23,392673047,47261494,872487
1024,24,436144104,47221021,854210
1024,25,196506301,47131166,871965
1024,26,762220922,47296579,872271
1024,27,189200471,47295070,872122
1024,28,275401269,47359328,872014
1024,29,197010477,47130708,872597
1024,30,178810449,47393897,871761
1024,31,277850168,47467583,853880
1024,32,179745824,47380170,854462
1024,33,296251927,47251077,854090
1024,34,252147900,47219586,854146
1024,35,301885868,47169878,872188
1024,36,282436737,47162594,872003
1024,37,188775310,47419862,871901
1024,38,228911524,47041979,871780
1024,39,566702424,47186539,853802
1024,40,304750536,47084416,854279
1024,41,285189362,47111804,853828
1024,42,269838422,47326252,871812
1024,43,671958981,47106000,872599
1024,44,333167195,47201727,872381
1024,45,196499984,47293653,871555
1024,46,391818952,47361584,871916
1024,47,184079637,47303183,872222
1024,48,199810841,47344166,853666
1024,49,188326570,47236426,872216
1024,50,232082599,47246560,854041
1024,51,183568439,47122824,854517
1024,52,317491696,47514655,872033
1024,53,380437988,47258178,871590
1024,54,178810308,47313379,854331
1024,55,195911322,47170830,871955
1024,56,194037053,47037647,872043
1024,57,306574077,47100616,871829
1024,58,182632221,47429599,872269
1024,59,434215373,47402407,854297
1024,60,361261675,47174533,872167
1024,61,351285275,47044612,872126
1024,62,251274571,47093715,854326
1024,63,216405986,47240872,854216
1024,64,212747151,47281445,853820
1024,65,582464675,47322567,871935
1024,66,333691550,47429452,872117
1024,67,505351590,47194239,872593
1024,68,318151124,47166372,871900
1024,69,182632503,47311818,853904
1024,70,318349886,47233102,872261
1024,71,215975636,47157373,853891
1024,72,617863606,47147680,854663
1024,73,178810453,47154094,854050
1024,74,178810590,47262371,872232
1024,75,380250470,47152841,854181
1024,76,605701010,47401129,854268
1024,77,542250541,47072846,872083
1024,78,385520803,47451489,871877
1024,79,178810167,47340654,854517
1024,80,278520346,47165383,872419
1024,81,273266224,47398730,871695
1024,82,202620481,47076537,872238
1024,83,178810308,47227139,872014
1024,84,371319483,47214902,854053
1024,85,288598030,47145212,854307
1024,86,205528909,47236791,872371
1024,87,212298552,47156842,854494
1024,88,197858966,47267893,871850
1024,89,192660104,47228559,872298
1024,90,192149893,47137238,872235
1024,91,285945244,47165127,872114
1024,92,189772717,47338209,854465
1024,93,194974258,47291628,872221
1024,94,287517033,47327019,872155
1024,95,593209611,47201115,871997
1024,96,551117463,47369016,854918
1024,97,203553597,47398618,871643
1024,98,187392044,47236588,872097
1024,99,178810168,47393671,871788
1024,100,368671325,47360167,872996
```

## Flash 보존

- 전체 2 MiB 백업: `/Users/seungwon/FALCON/fn-dsa_m4/measurement/backups/m4-original-hwggu2_5/flash_08000000_2mib.bin`.
- SHA-256: `943b305b6eb1d5d4230744cf4b2b283133e41a7bb8f7ac0cb2cb85b6244786d7`; 장비에 대한 verify_image 검증 완료.
- 사용 슬롯은 사전에 모든 바이트가 0xFF임을 확인했다. 기존 boot image와 option bytes는 쓰지 않는다.
- 측정 슬롯 복원 상태: **측정 슬롯 erase 완료; 전체 Flash가 백업과 일치함을 verify_image로 확인**.
- 복원 시 측정용으로 쓴 Flash 페이지만 erase한 뒤 전체 Flash를 백업과 검증한다. MCU의 실행 중 RAM 상태까지 복원하는 것은 아니다.

## 로그·재현

- [빌드 로그](measurement/logs/build.log), [실행·모니터링·복원 로그](measurement/logs/events.log), [진행 상태](measurement/status.json).
- [세션 메타데이터](measurement/session.json), [원시 결과 JSON](measurement/results.json), [측정 코드](measurement/benchmark.c), [제어·모니터링 코드](measurement/controller.py).
- [진행 확인·장비 분리 시 복구 방법](measurement/README.md).
- [논문 최적화 요약](../REFERENCE/falcon_m4_implementation.md).

### 실행 로그

```text
2026-09-08T23:44:19.685121+00:00 OpenOCD: halt
2026-09-08T23:44:19.692782+00:00 OpenOCD: dump_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement/backups/m4-original-hwggu2_5/flash_08000000_2mib.bin} 0x08000000 0x200000
2026-09-08T23:45:16.606490+00:00 dumped 2097152 bytes in 56.912342s (35.985 KiB/s)
2026-09-08T23:45:16.609108+00:00 OpenOCD: verify_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement/backups/m4-original-hwggu2_5/flash_08000000_2mib.bin} 0x08000000 bin
2026-09-08T23:46:16.665804+00:00 verified 2097152 bytes in 60.055367s (34.102 KiB/s)
2026-09-08T23:46:16.676528+00:00 Full backup verified; entire high 256 KiB slot is erased. Original boot image will be preserved.
2026-09-08T23:52:57.308447+00:00 OpenOCD: reset halt
2026-09-08T23:52:57.486118+00:00 OpenOCD: verify_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement/backups/m4-original-hwggu2_5/flash_08000000_2mib.bin} 0x08000000 bin
2026-09-08T23:53:57.558255+00:00 verified 2097152 bytes in 60.071144s (34.093 KiB/s)
2026-09-08T23:53:57.565878+00:00 OpenOCD: flash write_image erase {/Users/seungwon/FALCON/fn-dsa_m4/measurement/build/fndsa_m4.bin} 0x081c0000 bin
2026-09-08T23:54:01.512506+00:00 auto erase enabled
wrote 103064 bytes from file /Users/seungwon/FALCON/fn-dsa_m4/measurement/build/fndsa_m4.bin in 3.945039s (25.513 KiB/s)
2026-09-08T23:54:01.513829+00:00 OpenOCD: verify_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement/build/fndsa_m4.bin} 0x081c0000 bin
2026-09-08T23:54:04.565256+00:00 verified 103060 bytes in 3.050313s (32.995 KiB/s)
2026-09-08T23:54:04.566406+00:00 OpenOCD: reg sp 0x200a0000
2026-09-08T23:54:04.567259+00:00 sp (/32): 0x200a0000
2026-09-08T23:54:04.567779+00:00 OpenOCD: reg msp 0x200a0000
2026-09-08T23:54:04.568429+00:00 msp (/32): 0x200a0000
2026-09-08T23:54:04.568940+00:00 OpenOCD: reg psp 0x200a0000
2026-09-08T23:54:04.569567+00:00 psp (/32): 0x200a0000
2026-09-08T23:54:04.569972+00:00 OpenOCD: reg xpsr 0x01000000
2026-09-08T23:54:04.570506+00:00 xpsr (/32): 0x01000000
2026-09-08T23:54:04.571003+00:00 OpenOCD: reg primask 0x00000000
2026-09-08T23:54:04.571582+00:00 primask (/1): 0x00
2026-09-08T23:54:04.571942+00:00 OpenOCD: reg basepri 0x00000000
2026-09-08T23:54:04.572534+00:00 basepri (/8): 0x00
2026-09-08T23:54:04.573046+00:00 OpenOCD: reg faultmask 0x00000000
2026-09-08T23:54:04.573506+00:00 faultmask (/1): 0x00
2026-09-08T23:54:04.573834+00:00 OpenOCD: reg control 0x00000000
2026-09-08T23:54:04.574238+00:00 control (/3): 0x00
2026-09-08T23:54:04.574516+00:00 OpenOCD: resume 0x081ccbf0
2026-09-08T23:54:28.742672+00:00 Both warmups and tampered-signature checks passed; scalar host fingerprints match.
2026-09-08T23:54:28.743394+00:00 OpenOCD: write_memory 0x20030078 32 {0x474f3130}
2026-09-08T23:54:28.755019+00:00 progress counts=[[0, 0, 0], [0, 0, 0]], degree=512, operation=0, state=0x52554e21, error=0
2026-09-08T23:55:28.770533+00:00 progress counts=[[16, 16, 16], [0, 0, 0]], degree=512, operation=0, state=0x52554e21, error=0
2026-09-08T23:56:28.782893+00:00 progress counts=[[31, 31, 31], [0, 0, 0]], degree=512, operation=0, state=0x52554e21, error=0
2026-09-08T23:57:28.795972+00:00 progress counts=[[44, 44, 44], [0, 0, 0]], degree=512, operation=0, state=0x52554e21, error=0
2026-09-08T23:58:28.810012+00:00 progress counts=[[61, 60, 60], [0, 0, 0]], degree=512, operation=1, state=0x52554e21, error=0
2026-09-08T23:59:28.824507+00:00 progress counts=[[76, 75, 75], [0, 0, 0]], degree=512, operation=1, state=0x52554e21, error=0
2026-09-09T00:00:28.842650+00:00 progress counts=[[92, 91, 91], [0, 0, 0]], degree=512, operation=1, state=0x52554e21, error=0
2026-09-09T00:01:28.860381+00:00 progress counts=[[100, 100, 100], [1, 1, 1]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:02:28.879022+00:00 progress counts=[[100, 100, 100], [5, 5, 5]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:03:28.899769+00:00 progress counts=[[100, 100, 100], [8, 8, 8]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:04:28.912154+00:00 progress counts=[[100, 100, 100], [14, 14, 14]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:05:28.922367+00:00 progress counts=[[100, 100, 100], [18, 18, 18]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:06:28.936344+00:00 progress counts=[[100, 100, 100], [23, 23, 23]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:07:28.948779+00:00 progress counts=[[100, 100, 100], [26, 25, 25]], degree=1024, operation=1, state=0x52554e21, error=0
2026-09-09T00:08:28.960508+00:00 progress counts=[[100, 100, 100], [31, 31, 31]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:09:28.972945+00:00 progress counts=[[100, 100, 100], [36, 35, 35]], degree=1024, operation=1, state=0x52554e21, error=0
2026-09-09T00:10:28.984427+00:00 progress counts=[[100, 100, 100], [39, 39, 39]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:11:29.000258+00:00 progress counts=[[100, 100, 100], [43, 43, 43]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:12:29.014502+00:00 progress counts=[[100, 100, 100], [47, 47, 47]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:13:29.034545+00:00 progress counts=[[100, 100, 100], [52, 52, 52]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:14:29.056277+00:00 progress counts=[[100, 100, 100], [57, 57, 57]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:15:29.078122+00:00 progress counts=[[100, 100, 100], [61, 61, 61]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:16:29.092275+00:00 progress counts=[[100, 100, 100], [65, 65, 65]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:17:29.111804+00:00 progress counts=[[100, 100, 100], [69, 68, 68]], degree=1024, operation=1, state=0x52554e21, error=0
2026-09-09T00:18:29.126209+00:00 progress counts=[[100, 100, 100], [72, 72, 72]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:19:29.141792+00:00 progress counts=[[100, 100, 100], [76, 76, 76]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:20:29.153027+00:00 progress counts=[[100, 100, 100], [79, 79, 79]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:21:29.166199+00:00 progress counts=[[100, 100, 100], [84, 84, 84]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:22:29.184362+00:00 progress counts=[[100, 100, 100], [90, 89, 89]], degree=1024, operation=1, state=0x52554e21, error=0
2026-09-09T00:23:29.196169+00:00 progress counts=[[100, 100, 100], [94, 94, 94]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:24:29.208677+00:00 progress counts=[[100, 100, 100], [98, 98, 98]], degree=1024, operation=0, state=0x52554e21, error=0
2026-09-09T00:25:29.223801+00:00 ERROR: AssertionError()
2026-09-09T00:25:29.234529+00:00 Recovery requires attention: AssertionError()
2026-09-09T00:30:04.771919+00:00 OpenOCD: halt
2026-09-09T00:30:57.016632+00:00 OpenOCD: halt
2026-09-09T00:30:57.095102+00:00 All API calls finished before halt. WFI caused zero-valued running-target SRAM reads; completed data recovered after halt without rerunning any measurement.
2026-09-09T00:30:57.095185+00:00 All 600 recorded timings and both final host fingerprints validated after completion; no measurement rerun.
2026-09-09T00:30:57.103818+00:00 OpenOCD: halt
2026-09-09T00:30:57.105035+00:00 OpenOCD: flash erase_address 0x081c0000 0x1a000
2026-09-09T00:30:57.754322+00:00 erased address 0x081c0000 (length 106496) in 0.647565s (160.602 KiB/s)
2026-09-09T00:30:57.755471+00:00 OpenOCD: verify_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement/backups/m4-original-hwggu2_5/flash_08000000_2mib.bin} 0x08000000 bin
2026-09-09T00:31:07.814623+00:00 verified 2097152 bytes in 10.058166s (203.616 KiB/s)
2026-09-09T00:31:07.818338+00:00 OpenOCD: reset halt
2026-09-09T00:31:08.009388+00:00 Restoration verified. Original Flash restored; board left reset/halted.
2026-09-09T00:36:19.619655+00:00 Owned M4 OpenOCD server shut down after completed result recovery and full Flash restoration verification; ST-LINK released.
```

### 빌드 로그

```text
/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-gcc --version
arm-none-eabi-gcc (Arm GNU Toolchain 13.2.rel1 (Build arm-13.7)) 13.2.1 20231009
Copyright (C) 2023 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-gcc -Wall -Wextra -Wshadow -Wundef -Wno-unused-function -Wno-cast-function-type -std=c99 -ggdb3 -O3 -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -fno-common -ffunction-sections -fdata-sections -DFNDSA_ASM_CORTEXM4=1 -DUSE_HAL_DRIVER -DSTM32L4R5xx -DUSER_VECT_TAB_ADDRESS -DVECT_TAB_OFFSET=0x001C0000U -I. -I../ref -I/Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Inc -I/Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Inc/Legacy -I/Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/CMSIS/Device/ST/STM32L4xx/Include -I/Users/seungwon/.platformio/packages/framework-cmsis/CMSIS/Core/Include ../ref/codec.c ../ref/mq.c ../ref/sha3.c ../ref/sysrng.c ../ref/util.c ../ref/kgen.c ../ref/kgen_fxp.c ../ref/kgen_gauss.c ../ref/kgen_mp31.c ../ref/kgen_ntru.c ../ref/kgen_poly.c ../ref/kgen_zint31.c ../ref/sign.c ../ref/sign_core.c ../ref/sign_fpoly.c ../ref/sign_fpr.c ../ref/sign_sampler.c ../ref/vrfy.c ../ref/codec_cm4.s ../ref/mq_cm4.s ../ref/sha3_cm4.s ../ref/sign_fpr_cm4.s ../ref/sign_sampler_cm4.s benchmark.c platform.c /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/CMSIS/Device/ST/STM32L4xx/Source/Templates/system_stm32l4xx.c /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/CMSIS/Device/ST/STM32L4xx/Source/Templates/gcc/startup_stm32l4r5xx.s /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_cortex.c /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_rcc.c /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_rcc_ex.c /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_pwr.c /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_pwr_ex.c /Users/seungwon/.platformio/packages/framework-arduinoststm32/system/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal.c --static -nostartfiles -Tstm32l4rs_flash.ld -ggdb3 -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -Wl,--gc-sections -Wl,-Map=build/fndsa_m4.map -Wl,--print-memory-usage -Wl,--start-group -lc -lgcc -lm -lnosys -Wl,--end-group -o build/fndsa_m4.elf
/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/../lib/gcc/arm-none-eabi/13.2.1/../../../../arm-none-eabi/bin/ld: /private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/../lib/gcc/arm-none-eabi/13.2.1/../../../../arm-none-eabi/lib/thumb/v7e-m+fp/hard/libc.a(libc_a-init.o): in function `__libc_init_array':
init.c:(.text.__libc_init_array+0x1e): undefined reference to `_init'
Memory region         Used Size  Region Size  %age Used
           FLASH:      103060 B       256 KB     39.31%
         MAILBOX:        2536 B        64 KB      3.87%
             RAM:      131472 B       384 KB     33.44%
collect2: error: ld returned 1 exit status
make: *** [build/fndsa_m4.elf] Error 1
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
```

# ST/Arm 문서와 현재 설정 대조 — 2026-09-10

## 결론

이번에는 ST 일본 공식 사이트에서 **RM0486 Rev 3, December 2025, 4669쪽**
원문 전체를 확보했다. 관련 본문과 레지스터 도표를 직접 읽었다. st.com의 현행
다운로드와 파일 동일성까지 검증한 것은 아니므로 이 파일을 무조건 최신판이라고
부르지는 않는다.

**현재까지 대조한 필수 크기 설정·리셋 순서에서 원인으로 특정할 누락은 찾지
못했다.** 특히 `RAMCFG_FLEXRAMCR=0`을 TCM 크기 미설정의 증거로 보는 가설은
이 문서와 맞지 않는다. HAL 함수명과 비트 동작의 불일치는 발견했지만, 우리
독립 진단은 해당 함수를 사용하지 않으므로 이번 재현의 직접 원인은 아니다.
읽기 시 wait-state 설정에 따른 기존 69개 결과는 여전히 유효하다.

이번 작업은 문서·소스·기존 로그 대조와 오프라인 감사만 수행했다.
**보드 실행/리셋/설정 변경, Flash 쓰기, 성능 재측정, ST 문의는 하지 않았다.**

## 대조표

| 항목 | 문서/공식 구현의 조건 | 우리 구현/기존 관찰 | 판단 |
|---|---|---|---|
| TCM 크기 | SYSCFG 크기 필드에서 `0x9`가 각각 256 KiB | 하위 바이트 `0x99`, ITCMCR/DTCMCR `0x49` | 일치 |
| 크기 기록 방식 | I/D 크기 필드는 함께 잠기는 write-once 필드이므로 같은 접근으로 기록 | 한 번의 32비트 RMW로 하위 바이트 `0x99` 기록 | 일치 |
| 확장 적용 | 크기 기록 후 재부팅 필요; CORE_RESET_TYPE=1은 SYSRESETREQ에 power-on reset 선택 | reset type bit 0 설정 후 OpenOCD SYSRESETREQ | 필수 순서 일치 |
| `RAMCFG_FLEXRAMCR=0` | Rev 3에서는 bit 8 SRAMER만 유효; 31:9와 7:0은 reserved | 0을 읽었고 해당 레지스터에 쓰지 않음 | 확장 미설정 증거 아님 |
| ECC 담당 | TCM으로 배정된 FLEXMEM의 ECC는 Cortex-M55 TCM 인터페이스가 담당 | MSCR과 TEBR로 검사/오류 확인 | RAMCFG의 BKPSRAM ECC 절차와 구분 필요 |
| wait-state 비트 | bit 23/24는 확장 ITCM/DTCM의 기본 대기 해제 | 직접 bit 23 변경 시 기존 읽기 시험 결과가 바뀜 | 이전 비트 해석과 일치 |
| 초기화 중 ECC 검사 | Arm은 TECCCHKDIS로 초기화 중 오검출을 억제하는 방법 제공 | 전체 초기화 중에도 검사 ON; 준비 완료 시 TEBR VALID=0 | 차이는 있으나 원인 미입증 |

ST 문서 근거: RM0486 Rev 3 §10.3.2, §10.6.19, §16.1.3, §16.1.7.
[ST 공식 원문](https://www.stmcu.jp/wp/wp-content/uploads/2024/12/RM0486_Rev3.pdf),
[확보한 PDF](documents/RM0486_Rev3.pdf).
Arm 초기화 근거는 아래 절에 별도로 기록한다.

## 새롭게 해소한 의심: RAMCFG 값이 0인 이유

Rev 3 p.304의 FLEXRAMCR에는 TCM 크기 선택 필드가 없다. 기존 CMSIS 헤더의
`RAMCFG_CR_ITCMCFG`/`DTCMCFG` 매크로만 보고 이 레지스터에 쓰면, 해당 문서상
reserved 비트를 건드리게 된다. **매크로가 존재한다는 이유만으로 추가 설정을
적용하면 안 된다.** p.292는 크기 선택을 SYSCFG로 명시한다.

또한 p.290 표 35에서 256/256 KiB 구성은 지원되며 AXI 쪽 FLEXRAM은 남지 않는다.
p.291은 AXISRAM1 시작을 secure `0x34064000`으로 명시한다. 우리 독립 진단의
제어/스택/복사 출력은 `0x34080000` 이후이므로 이 부분을 소모된 FLEXRAM에
잘못 배치한 것으로 설명할 수 없다.

도표를 렌더링해 텍스트 추출과도 대조했다:
[FLEXRAMCR p.304](documents/rm0486_p304.png),
[TCMCR p.812](documents/rm0486_p812.png).

## HAL 이름과 실제 비트 동작의 불일치

사용 중인 고정 HAL 소스와 확인일의 ST 공식 main 소스 모두 다음 형태다.

| HAL 함수 이름 | 실제 동작 | RM의 해당 비트 설명에 따른 효과 |
|---|---|---|
| `HAL_SYSCFG_EnableITCMWaiteState` | ITCMWSDISABLE을 SET | 기본 ITCM 대기 해제 |
| `HAL_SYSCFG_DisableITCMWaiteState` | ITCMWSDISABLE을 CLEAR | 기본 ITCM 대기 적용 |
| `HAL_SYSCFG_EnableDTCMWaiteState` | DTCMWSDISABLE을 SET | 기본 DTCM 대기 해제 |
| `HAL_SYSCFG_DisableDTCMWaiteState` | DTCMWSDISABLE을 CLEAR | 기본 DTCM 대기 적용 |

즉 이름/설명과 구현된 비트 조작 사이에 불일치가 있다. 공식 수정 공지나 ST의
결함 인정까지 확인한 것은 아니다. **우리 재현 스크립트는 HAL 호출이 아니라
직접 레지스터 조작과 readback으로 조건을 통제하므로 이 불일치가 69개 결과를
뒤집지는 않는다.** 앞으로 HAL을 통해 설정할 때 함수명만 보고 판단하지 않는다.

[고정 HAL 소스](../env/hal_stm32/stm32cube/stm32n6xx/drivers/src/stm32n6xx_hal.c),
[ST 공식 HAL](https://github.com/STMicroelectronics/stm32n6xx-hal-driver/blob/main/Src/stm32n6xx_hal.c).

## ST 공식 FLEXMEM 예제가 입증하는 범위

ST Nucleo 예제는 DTCM 256 KiB / ITCM **128 KiB**로 설정한다. 이후 의도적으로
HardFault를 발생시켜 reset을 요청한다. 첫 구성은 SYSCFG clock enable →
두 크기 설정 → power-on reset 선택 순서다. HardFault handler가
HAL_NVIC_SystemReset을 호출한다.

우리 도구도 SYSCFG clock enable → 두 크기 동시 기록 → reset type 선택 →
reset 요청의 순서다. `reset_config none`과 target의
`cortex_m reset_config sysresetreq`를 함께 확인했으므로, 단순 NRST 요청을
power-on reset으로 오인한 것은 아니다. 다만 공식 예제는 Flash boot이고
우리 진단은 디버거 기반 RAM load라 전체 부팅 과정이 동일한 것은 아니다.

**이 예제는 우리의 ITCM 256 KiB·서로 다른 두 확장 창 접근 시험과 같지 않다.**
소스의 표시된 쓰기 루프도 포인터가 매번 같은 base에 설정되고 증가하지 않아,
그 자체를 전체 메모리 read/write 검사로 볼 수 없다. 예제 통과만으로 모든
확장 ITCM 접근 패턴을 검증했다고 판단하지 않는다.

[공식 main.c](https://github.com/STMicroelectronics/STM32CubeN6/blob/main/Projects/NUCLEO-N657X0-Q/Examples/SYSCFG/FLEXMEM_Configurations/FSBL/Src/main.c),
[확보한 main.c](documents/cube_flexmem_main.c),
[확보한 HardFault handler](documents/cube_flexmem_it.c).

## 남은 차이: ECC 초기화와 실제 읽기 경로

Arm TRM §5.14, §11.2.2는 초기화 중 speculative read/sub-word write로 생길 수
있는 ECC 오검출을 TECCCHKDIS로 억제하는 방법을 설명한다. 이 비트는 쓰기 ECC
생성을 막지 않으며 초기화 후 반드시 다시 0으로 돌려야 한다.

우리 진단은 검사 ON 상태에서 정렬 STRD로 전체 영역을 먼저 초기화하고,
그다음 코드/입력을 기록했다. 모든 완료 사례에서 실행 전 TEBR VALID가 0이었다.
기록 때 대기를 켰는지 껐는지와 무관하게 결과가 읽기 설정을 따른 것도 확인했다.
따라서 이 초기화 차이를 원인으로 단정할 근거는 약하다. 그래도 “초기화 중만
억제 → 재활성화 → 기존 1WS 조건으로 호출”하는 대조는 아직 하지 않았다.

또한 Arm TRM §11.2.1은 주소에 관한 ECC 오류도 multi-bit 오류로 분류한다.
따라서 ECC fault는 물리 SRAM 셀 자체가 뒤집혔다는 증거만은 아니다. 응답 경로에서
주소와 데이터/ECC의 조합이 어긋난 가능성도 남지만, 실제 내부 신호는 관찰하지
못했다. 캐시 OFF 역시 명령 fetch/TCM speculative read가 없다는 뜻은 아니다.
TCM은 MPU memory-type 지정도 무시하므로 Device 속성만 바꾸는 해결책을 제안하지 않는다.
[Arm Cortex-M55 r1p1 TRM](https://documentation-service.arm.com/static/6622c173fabc8c11c7b53a92).

## 다음으로 좁힐 수 있는 시험 — 아직 실행하지 않음

1. wait-state는 기본값 그대로 두고, **초기화 동안에만** TECCCHKDIS를 사용한 뒤
   다시 ECC 검사를 켜서 기존 실패/대조 주소 조합을 반복한다. 먼저 초기화
   절차의 영향을 분리하는 시험이다. 실행 중 ECC OFF를 해결책으로 쓰지 않는다.
2. 위 차이가 없다면 wait-state를 유지한 채 코드 정렬/접근 간격 및 ACTLR의
   명령 overlap 관련 제어를 독립적으로 비교한다. 이는 원인 분리용 조건이며
   성능 기준 설정에 자동 반영하지 않는다.
3. 필요할 때 별도 보드에서 같은 최소 재현을 비교한다. 한 보드의 결과로
   전체 실리콘 revision의 결함을 확정하지 않는다.

이번 문서 대조에서도 **800 MHz Flex-TCM 0WS의 보증 조건은 확보하지 못했다.**
ST 데이터시트 표 24의 Base-TCM 0WS / Flex-TCM 1WS 조건을 유지해서 해석한다.
[DS14791](https://www.st.com/resource/en/datasheet/stm32n657x0.pdf).

## 재현 자료/검증 상태

- 원문 URL은 [ST 일본 공식 문서 목록](https://www.stmcu.jp/design/document/reference_manual/112034/)에
  공개된 Rev 3 링크로 확인했다. 파일 크기 98,521,607 bytes, 4669 pages.
- PDF SHA-256: `df513ceb48a430f1b835f7ad4161ab762dac8f95c22f06495d2a4c46810a7858`.
- 본문 추출: [텍스트](documents/RM0486_Rev3.txt), [PDFKit 추출/렌더 도구](extract_reference.swift).
  전체 추출 시 PDFKit 경고가 있었으므로 핵심 레지스터 p.304/p.812는 렌더링도 확인했다.
- 공식 main.c SHA-256: `52037f9b0fa2f6cfcd4acbb79c73dd5a1508c6a280bd042dbae6e8ea2f3d5817`.
- 공식 it.c SHA-256: `dc88ccdeb74be9df91d31fd5e253190dfa03c4e0b8da82cda8e4161d5691d0fd`.
- `audit_tcm_root.py`: 기존 69개 사례 raw log/코드/입력/출력/레지스터 감사 PASS.
- `audit_result.py`: 완료된 600회 성능 측정의 소스/ELF/로그 해시 및 correctness PASS.
- 이전 ST 문의 ZIP은 **미발송 과거 초안**으로 보존했다. 새 매뉴얼 확인 전의
  RAMCFG 관련 미확정 질문이 포함되어 있으므로 현행 결론은 이 문서를 기준으로 한다.

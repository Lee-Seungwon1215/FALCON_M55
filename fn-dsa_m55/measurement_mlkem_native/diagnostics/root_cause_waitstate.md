# 확장 ITCM ECC 오류: wait-state 의존성 분리 — 2026-09-10

후속 문서 대조: [RM0486 Rev 3 원문 확인 결과](manual_crosscheck.md).
원문을 새로 확보해 RAMCFG 추가 크기 설정 가설과 HAL 함수명 불일치를 검토했다.
아래의 “RM0486 미확보”는 당시 상태이며, 실험 기록은 그대로 보존한다.

## 현재 결론

**단순한 용량 부족·남아 있는 값·FN-DSA 연산 문제가 아니라, 시험한 확장 ITCM
주소 조합에서 읽기를 수행할 때 기본 wait-state 설정에 의존하여 ECC fault가
발생한다.** 읽기 직전에 ITCM wait-state 비트 하나만 변경하면 같은 명령과
같은 입력이 정상 동작한다. 초기화/기록 때의 설정과 읽기 때의 설정을 분리해도
결과는 읽기 때 설정을 따른다.

이는 재현 조건과 직접적인 제어 요인을 확인한 결과다. **ST 내부의 wait 응답,
창 선택, 데이터/ECC 전달 중 어느 회로 또는 통합 설정이 잘못되는지까지
확정한 것은 아니다.** 공식 실리콘 erratum으로 단정하지 않는다.

쉽게 말해, wait-state는 메모리 응답에 추가 대기 주기를 두는 설정이다. 이번
결과를 “메모리가 너무 느려서 대기를 더 넣어야 한다”로 해석하면 안 된다.
관찰된 방향은 반대로, 기본 대기가 적용되는 경로에서 실패하고 그 대기를
해제한 경로에서 통과했다는 것이다. 내부 응답 타이밍/선택 문제라는 설명은
유력한 가설이지 아직 확인한 회로 수준 원인이 아니다.

## 실험 조건과 범위

- 보드: 연결된 NUCLEO-N657X0-Q 한 대, ST-LINK `003C00223335510735383531`.
- Cortex-M55 r1p1; ITCM/DTCM 각각 256 KiB, `ITCMCR=DTCMCR=0x49`.
- 부트 HSI 상태: `RCC_CFGR1=0`, `CFGR2=0x00100000`,
  `HSICFGR=0x8c800000`. 레지스터 해석상 명목 CPU 64 MHz이며 외부 실측값은 아니다.
- `CCR=0x201`: I/D cache OFF. `MSCR=0x1300a`: ECC 검사 ON.
- IRQ 차단, 벡터/스택/제어 루틴은 예약 AXISRAM에 배치.
- 매 사례마다 새 디버거 세션. CPU의 정렬 STRD로 전체 TCM을 초기화한 뒤,
  CPU가 직접 시험 명령과 입력을 기록했다. 디버거는 AXI 진단 ELF 적재와
  레지스터 인수 설정, 메모리 덤프/검증을 담당했다.
- 각 호출 전 TEBR valid 플래그가 0임을 확인했다. 이전 오류의 TEBR 데이터
  필드가 남아 있어도 valid=0이면 새로운 오류로 세지 않았다.
- 입력 128바이트, 각 32비트 값은 `word_address ^ 0x5a5aa5a5`.
  성공 판정은 정상 종료 + fault 레지스터 0 + 전체 복사/합산 결과 일치.
- FN-DSA API, Zephyr 실행, MVE, 부동소수점 연산을 사용하지 않는 독립 시험이다.
  이 조건은 원인 분리용이며 800 MHz 성능 측정 조건이 아니다.

## 1. 명령/입력 위치 대조: 25개 사례

LDM/STM 복사, LDM 합산, 스칼라 LDR 합산, LDRD 합산, LDR 뒤 DSB/ISB를
넣은 합산의 5종을 각각 아래 5개 배치에서 호출했다.

| 코드 주소 | 입력 주소 | 5종 결과 |
|---|---|---|
| AXISRAM `0x34081000` | ITCM `0x10024000` | 5/5 정상 |
| 기본 ITCM `0x10001000` | ITCM `0x10024000` | 5/5 정상 |
| 확장 ITCM 창 1 `0x1001302c` | 확장 ITCM 창 2 `0x10024000` | **5/5 ECC fault** |
| 확장 ITCM 창 2 `0x1002302c` | 같은 창 `0x10024000` | 5/5 정상 |
| 확장 ITCM 창 1 `0x1001302c` | DTCM `0x30008000` | 5/5 정상 |

복사 출력도 AXISRAM에 두었고 출력 메모리가 없는 스칼라 합산에서도 실패했다.
따라서 DTCM 목적지 쓰기는 오류의 필요조건이 아니다. **스칼라 LDR 루프도
실패할 수 있다.** 이전의 짧은 LDR/BX 루틴 통과를 모든 스칼라 접근에 일반화할
수 없다. 매 LDR 뒤 DSB/ISB를 넣는 것도 이번 배치에서는 해결책이 아니었다.

LDM 합산은 FECC(`AFSR=0x10000000`, `CFSR=0x100`), 나머지 4종은
PECC(`AFSR=0x20000`, `CFSR=0x8200`)로 실패했다. 모두 TEBR의 bank 필드가
ITCM을 가리켰다. FECC/PECC 구분은 Arm의 명령 fetch/precise ECC 보고
정의에 따른다. [Arm Cortex-M55 r1p1 TRM, AFSR/TEBR](https://documentation-service.arm.com/static/6622c173fabc8c11c7b53a92).

자료: [25개 결과](../runs/tcm-root-20260910T023126Z/results.json).

## 2. ITCM/DTCM wait-state를 각각 변경: 20개 사례

코드 `0x1001302c`, 입력 `0x10024000`을 고정하고 5종 루틴을 다시 시험했다.

| `SYSCFG_CM55TCMCR` | 변경 내용 | 결과 |
|---|---|---|
| `0x00000099` | 기본 설정 | **5/5 실패** |
| `0x00800099` | 확장 ITCM의 기본 대기만 해제 | **5/5 정상** |
| `0x01000099` | 확장 DTCM의 기본 대기만 해제 | **5/5 실패** |
| `0x01800099` | 둘 다 해제 | **5/5 정상** |

ST 헤더에서 bit 23은 `ITCMWSDISABLE`, bit 24는 `DTCMWSDISABLE`이다.
각각 확장 ITCM/DTCM에 기본 적용되는 wait-state 해제로 설명되어 있다.
[사용 중인 고정 ST 헤더](../env/hal_stm32/stm32cube/stm32n6xx/soc/stm32n657xx.h),
[ST 공식 헤더 저장소](https://github.com/STMicroelectronics/cmsis-device-n6/blob/main/Include/stm32n657xx.h).

이 20개에서는 기록 전부터 비트를 변경했으므로 기록 단계와 읽기 단계를
분리하는 추가 시험이 필요했다. 다음 시험이 그 혼동을 통제한다.

자료: [20개 결과](../runs/tcm-root-20260910T023253Z/results.json).

## 3. 기록 단계와 읽기 단계 분리: 24개 사례

순서: 쓰기 설정 → CPU 초기화/명령·입력 기록 → 동일 바이트 확인 →
**읽기 설정만 변경, TCM 내용을 다시 쓰지 않음** → DSB/ISB → 호출.

LDM 복사와 스칼라 LDR 합산, 두 루틴을 각 조건에서 새 리셋으로 3회씩 반복했다.

| 초기화/기록할 때 ITCM 대기 | 읽을 때 ITCM 대기 | 결과(두 루틴 × 3회) |
|---|---|---|
| 기본 대기 적용 | 기본 대기 적용 | **6/6 실패** |
| 기본 대기 적용 | 대기 해제 | **6/6 정상** |
| 대기 해제 | 기본 대기 적용 | **6/6 실패** |
| 대기 해제 | 대기 해제 | **6/6 정상** |

즉 기록 시 설정과 무관하게 **읽기 시 기본 대기 적용이면 12/12 실패,
해제하면 12/12 정상**이다. 이 분리는 “특정 쓰기 설정에서 초기 데이터/ECC가
잘못 만들어졌다”는 설명보다 읽기 시점의 접근 경로 문제를 지지한다.
단, 디버거 덤프가 메모리 내부 ECC 비트 자체를 검증한 것은 아니다.

실패 시 대표값:

```text
LDM copy: CFSR=0x8200 HFSR=0x40000000 AFSR=0x20000 BFAR=0x1002400c
LDR sum:  CFSR=0x8200 HFSR=0x40000000 AFSR=0x20000 BFAR=0x10024000
```

자료: [24개 결과](../runs/tcm-root-20260910T023429Z/results.json),
[실패 로그](../runs/tcm-root-20260910T023429Z/case-0.log),
[기록은 그대로 두고 읽기 대기만 해제한 정상 로그](../runs/tcm-root-20260910T023429Z/case-1.log).

## 확정하지 못한 부분 / 다음 검증

1. wait-state 적용 경로의 응답/창 선택 문제인지, 추가 통합 설정이 필요한지,
   물리 메모리 데이터와 ECC 중 어느 쪽이 어떤 시점에 불일치하는지는 미확정이다.
   임의 ECC 오류 주입, ECC 검사 해제, FPGA/RTL 내부 신호 관측은 하지 않았다.
2. 한 보드의 일부 주소/입력에 대한 재현이다. 모든 64 KiB 창 조합, 코드 정렬,
   전압/온도/주파수, 다른 실리콘/보드로 일반화할 수 없다.
3. 공개 ST errata ES0620 Rev 5에서 이 관찰에 해당하는 TCM 항목은 찾지 못했다.
   이것이 결함이 없다는 증거는 아니다.
   [ST ES0620](https://www.st.com/resource/en/errata_sheet/es0620-stm32n6xxxx-device-errata-stmicroelectronics.pdf).
4. 비슷한 확장 ITCM 접근/ECC 사례가 ST 커뮤니티에 있지만, 공개 ST 답변은
   Nucleo/DK 재현 여부를 묻는 내용이다. 공식 결함 확인이나 이번 wait-state
   원인 확인으로 인용하면 안 된다.
   [외부 재현 보고](https://community.st.com/stm32-mcus-products-25/reproducible-ecc-error-in-tcm-memory-following-a-certain-access-pattern-with-stm32n657i0-158561).
5. RM0486 전체 PDF를 이번 환경에서 확보하지 못해 FLEXRAM 상세 설정 본문을
   직접 확인하지 못했다. 헤더의 `RAMCFG_FLEXRAMCR=0`만 보고 미설정이라고
   단정하거나 임의로 변경하지 않았다.

**64 MHz 진단에서 통과했다고 800 MHz에서 ITCM 대기를 해제해도 된다는 뜻은
아니다.** ST DS14791 Rev 10 표 24는 Base-TCM 0WS와 Flex-TCM 1WS 조건을
명시한다. 이번 시험은 Flex-TCM 0WS의 보증 가능한 최대 주파수를 결정하지 않는다.
따라서 기존 800 MHz 측정에 대기 해제를 적용하지 않았다.
[ST 데이터시트, 표 24](https://www.st.com/resource/en/datasheet/stm32n657x0.pdf).

다음으로 유용한 확인은 이 최소 재현과 레지스터/명령 바이트를 바탕으로 ST에
wait-state 경로의 알려진 제한 및 필요한 설정을 문의하고, 다른 동일 보드에서
교차 검증하는 것이다. **외부 문의/코드 공개는 실행하지 않았다.**

## 감사, 재현 및 원상복구

- [실행 스크립트](run_tcm_root.py), [새 진단 커널](tcm_root_kernels.s).
  각 run 디렉터리에 당시 소스, ELF, disassembly, GDB 스크립트와 로그,
  실제 명령/입력/출력 덤프를 보존했다.
- [독립 사후 감사](audit_tcm_root.py), [감사 결과/파일 SHA-256](tcm_root_audit.json).
  69개 모두 raw log, 입력 전체, ELF와 실제 명령 바이트, 정상 출력,
  ECC/캐시/클럭/대기 설정과 종료 복구가 일치했다.
- 초기 harness 준비가 실패한 `tcm-root-20260910T023025Z`는 완료된 69개에
  포함하지 않았다. 수정한 harness의 세 완료 시리즈만 위 표에 사용했다.
- 각 변경 시험에서 `CM55TCMCR=0x00000099`로 복원한 뒤 reset/detach했다.
  ECC 검사를 끈 시험은 없으며 M4, Flash, option bytes는 건드리지 않았다.
- 기존 FN-DSA 소스/메모리 배치/측정 ELF를 수정하지 않았다.
  `audit_result.py`를 다시 실행해 기존 600회 측정의 ELF/소스/로더/로그 해시,
  22개 host digest, ECC ON 및 결과 통과를 재확인했다.
  보존된 측정 ELF SHA-256:
  `c415762b0c572db02f144fb77ac78a02e8af571544faab2dfa4334a5dfe1b65f`.

```sh
source env/environment.sh
python diagnostics/audit_tcm_root.py  # 오프라인 재검증, USB 불필요
```

하드웨어 재현은 보드가 다른 작업에 사용 중이지 않은 때에만 별도로 실행한다.
`run_tcm_root.py`는 M55 RAM을 초기화하고 리셋하는 진단이다.

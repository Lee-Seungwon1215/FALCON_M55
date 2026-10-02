# M55_ref 출발: 서명 전체 성능의 2×2 비교

## 비교 대상

네 구현은 각각 `variants/` 안에 독립적인 소스 전체를 보유한다. 다른 후보의 암호 소스를 링크하거나 빌드 옵션으로 알고리즘을 교체하지 않는다.

| 폴더 | NTT 최적화 | 서명 FFT 5개 함수 최적화 | 키생성 FFT |
| --- | --- | --- | --- |
| `variants/ref` | 없음 | 없음 | M55_ref 원본 |
| `variants/ntt_only` | pre-SLOTHY 공통 q-NTT + K4C RNS | 없음 | M55_ref 원본 |
| `variants/fft_only` | 없음 | 있음 | M55_ref 원본 |
| `variants/ntt_fft` | pre-SLOTHY 공통 q-NTT + K4C RNS | 있음 | M55_ref 원본 |

서명 FFT는 `fpoly_FFT()`, `fpoly_iFFT()`, `fpoly_LDL_fft()`, `fpoly_split_fft()`, `fpoly_merge_fft()`만 의미한다. 원본의 다른 `sign_fpoly.c` 함수와 GM 상수의 값은 유지한다. 채택 소스는 정리된 `FFT/6_sign_fft`에서 가져온다. NTT도 같은 폴더의 K4C·수동 최적화 상태이며 SLOTHY는 사용하지 않는다. RNS NTT는 키생성에만 사용되므로 이 실험의 서명 타이머에는 직접 포함되지 않는다.

`prepare.py`는 원본/채택 소스를 읽어 독립 복사본을 만들고 파일 해시를 기록한다. 원본 M4 정수 어셈블리는 네 구현 모두 켠다. 키생성 FFT A17, sampler 변경 등은 포함하지 않는다. 원본 `M55_ref`, `Final_code/Before_slothy`, `FFT/6_sign_fft`는 수정하지 않는다.

## 통제한 측정 조건

- NUCLEO-N657X0-Q, ST-Link `003C00223335510735383531`, CPU 800 MHz.
- GCC 15.2.1, 동일 Zephyr/보드 설정, `-O3`, Cortex-M55, hard-float, `-mfpu=fpv5-d16`, `-ffp-contract=off`, `-fno-fast-math`.
- 코드 ITCM, 상수·데이터·스택 DTCM, I/D cache OFF, TCM 설정 `0x99`.
- 변경 영역에 동일 크기 슬롯을 예약하여 **변경하지 않은 함수·상수·버퍼의 주소가 이동하지 않도록** 한다. 이는 측정용 배치 통제이지 다른 후보를 가져오는 소스 링크가 아니다. `audit_layout.py`가 실제 ELF의 주소를 검사한다. 변경된 객체 내부의 모든 함수 오프셋까지 같다는 뜻은 아니다.
- 똑같은 메시지, 키생성 seed, 서명 seed. 각 크기에서 키 10개를 생성·해시한 뒤 마지막 키로 서명을 측정한다. 키생성 시간은 제외한다.
- 워밍업 3회 후 서로 다른 서명 seed 100개, 각 후보 2회 실행. 실행 순서를 정방향/역방향으로 하여 시간 순서 영향을 확인한다. 같은 100개 입력을 두 번 실행하는 것이므로 200개 독립 seed는 아니다.
- DWT cycle counter, 서명 타이머 안에서 IRQ OFF. 정상 검증·변조 거부·출력 fingerprint 계산·로그는 타이머 밖이다. 서명 API 내부의 해시·인코딩 등은 포함한다.
- 성능 펌웨어에는 함수 내부 프로파일링 hook을 넣지 않는다.

실제 원시 로그, ELF, map, disassembly, 컴파일 명령, 소스 archive, SHA256을 실행별 `results/`에 보존한다. `run.py`는 실행 전후 소스 불변, 보드 fault/ECC 상태, 완료 marker, 출력 fingerprint를 검사한다.

## 재실행

```sh
python3 -B fn-dsa_m55/function_compare/sign_fft_fourway/prepare.py
bash fn-dsa_m55/function_compare/sign_fft_fourway/build.sh ref sign
bash fn-dsa_m55/function_compare/sign_fft_fourway/build.sh ntt_only sign
bash fn-dsa_m55/function_compare/sign_fft_fourway/build.sh fft_only sign
bash fn-dsa_m55/function_compare/sign_fft_fourway/build.sh ntt_fft sign
python3 -B fn-dsa_m55/function_compare/sign_fft_fourway/audit_layout.py
python3 -B fn-dsa_m55/function_compare/sign_fft_fourway/run.py ref sign
```

다른 후보도 같은 방식으로 실행한다. 보드는 한 번에 한 실행만 사용하고 하드웨어 접근 권한이 필요하다. `sigkat`은 후보별 서명 KAT 90건, `kat`은 두 종류의 키생성 구현에 대해 각각 300건을 검사한다. `analyze.py`는 계획된 8개 성능 실행·4개 서명 KAT·2개 키생성 KAT가 모두 존재해야 완료된다. 재실행을 더 추가하면 분석할 실행 집합을 명시적으로 조정해야 한다.

검사 통과는 측정한 입력의 정확성 확인이다. 모든 입력 동등성·전체 상수시간성·물리 부채널 내성을 증명하지 않는다. 최종 수치는 `result.md`와 `summary.json`에 기록한다.

## 추가: 같은 네 구현의 키생성·검증

`keyverify` 모드는 암호 소스 네 가지를 그대로 사용하여 전체 키생성·검증 API 시간을 따로 잰다. **여기에서도 FFT는 서명용 5개 함수다. 키생성 FFT A17은 포함하지 않는다.** 기존 서명 측정 ELF·로그는 그대로 보존한다.

- 키생성: 크기별 결정적 seed 100개, 워밍업 3회, 두 번 실행. 원래 서명 측정의 키생성 seed 생성 규칙을 index 0–99로 확장한다. 후보 재시도·NTRU solve·키 인코딩을 모두 포함한다.
- 키생성은 긴 재시도에도 카운터가 넘치지 않도록 `k_cycle_get_64()`와 IRQ/SysTick ON을 사용한다. 이 점은 앞선 서명 측정의 IRQ OFF와 다르며, **네 비교군 사이에는 동일**하다. 매 실행 시작에 100 ms 구간의 DWT/64비트 타이머 교차검사를 한다.
- 생성한 키마다 타이머 밖에서 서명·정상 검증·변조 거부를 검사한다. 키 100개의 SK/PK를 SHA3-256으로 누적하여 모든 후보·반복의 출력이 같은지 확인한다.
- 검증: 앞선 서명 측정과 같은 index 9의 키, 같은 메시지·서명 seed 100개. 각 유효한 서명을 타이머 밖에서 생성하고 검증 API만 DWT·IRQ OFF로 측정한다. 워밍업 3회, 두 번 실행한다.
- 검증 입력인 PK·서명들의 SHA3-256 누적값도 모든 후보·반복에서 대조한다. 유효한 서명 검증이 성능 지표이며, 변조 서명의 거부 시간은 측정하지 않는다.
- `audit_layout.py keyverify`가 새로운 측정 프로그램 안에서 네 구현의 실제 코드·상수·버퍼 주소를 다시 대조한다. 앞선 서명 펌웨어와 모든 절대 주소가 같다는 뜻은 아니다.

```sh
bash fn-dsa_m55/function_compare/sign_fft_fourway/build.sh ref keyverify
bash fn-dsa_m55/function_compare/sign_fft_fourway/build.sh ntt_only keyverify
bash fn-dsa_m55/function_compare/sign_fft_fourway/build.sh fft_only keyverify
bash fn-dsa_m55/function_compare/sign_fft_fourway/build.sh ntt_fft keyverify
python3 -B fn-dsa_m55/function_compare/sign_fft_fourway/audit_layout.py keyverify
python3 -B fn-dsa_m55/function_compare/sign_fft_fourway/run.py ref keyverify
```

실행 순서는 서명과 동일하게 `ref → ntt_only → fft_only → ntt_fft → ntt_fft → fft_only → ntt_only → ref`다. 완료 후 `analyze_keyverify.py`가 8개 실행의 원시 로그·해시·통계·입출력을 검사하고 `summary_keyverify.json`에 집계한다. 결과 설명은 `result_keyverify.md`에 기록한다.

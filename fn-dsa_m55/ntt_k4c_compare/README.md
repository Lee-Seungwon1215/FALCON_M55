# K4C 포함 NTT 최적화 — 전체 API 재측정

재측정 결과와 원시 로그 링크는 [result.md](result.md)에 있다.

비교 대상은 `../M55_ref`와 `../ntt_opt`다. 후자는 공통 q-NTT 최적화와
K4C RNS NTT/iNTT를 포함하고, SLOTHY 및 FFT 최적화는 포함하지 않는다.
암호 소스는 각 원래 경로에서 직접 빌드하며 이 프로젝트는 측정 도구만 제공한다.
`run.py`가 K4C·q-NTT 해시와 나머지 비-NTT 소스의 동일성을 검사한다.

## 측정 조건

- NUCLEO-N657X0-Q, ST-Link `003C00223335510735383531`만 사용한다.
- CPU/SYSCLK/HCLK = 800/400/200 MHz, I/D 캐시 OFF, TCM ECC ON.
- ITCM/DTCM 각각 256 KiB. 코드는 ITCM, 상수·데이터·스택은 DTCM.
- 동일 GCC 15.2.1 도구체인, `-O3`, M4 어셈블리 활성화.
- q-NTT·RNS 코드 및 상수에 동일한 예약 영역을 할당한다. 나머지 함수·상수·작업
  버퍼·스택 주소의 일치를 ELF에서 검사한다. 변경된 NTT 영역 내부 주소까지 같다는 뜻은 아니다.
- 키 크기별 고정 입력 10개 × 입력별 10회 = 키생성/서명/검증 각각 100회.
  각 입력/연산마다 10회 워밍업한다. 이는 100개 서로 다른 키의 평균이 아니다.
- 실제 API의 내부 재시도·인코딩을 포함한다. seed 준비, digest, 변조 검사는 계측 밖이다.
- 공통 `ntt_final_compare/app/benchmark.c`와 동일한 프로그램·seed·메시지 사용.
  기존 SLOTHY 결과는 재사용하지 않는다.
- 성능은 100회 산술평균 cycles/call. 원시 BATCH 총합과 상위 중앙값도 보존한다.
- RAM에 ELF를 적재한다. 보드 Flash를 수정하지 않는다.

## 재현

```sh
bash fn-dsa_m55/ntt_k4c_compare/build.sh ref
bash fn-dsa_m55/ntt_k4c_compare/build.sh ntt_opt
python3 -B fn-dsa_m55/ntt_k4c_compare/audit_layout.py
```

이후 `measurement_mlkem_native/env/build-venv/bin/python`으로 `run.py`를 호출한다.
각 구현은 동일 ELF의 `pilot` 통과 뒤 `full` 실행한다. 두 실행에 같은 새 `--label`을
지정하고, `summarize.py --label LABEL`로 검증된 원시 기록만 집계한다.
동시 보드 실행은 금지한다. 역순 반복은 새 label로 독립 실행한다.

이번 실행에서는 `k4c_v1`으로 `ref → ntt_opt`, `k4c_reverse_v1`으로
`ntt_opt → ref` 순서를 사용한다. 각 label에서 각 구현의 pilot를 별도로 확인한다.
최종 보고서는 다음 명령으로 재검증·생성한다.

```sh
python3 -B fn-dsa_m55/ntt_k4c_compare/report.py k4c_v1 --confirmation-label k4c_reverse_v1
python3 -B fn-dsa_m55/ntt_k4c_compare/test_measurements.py
```

정확성 검사는 host와의 출력 digest 일치, 서명 검증·변조 거절, q-NTT 오차/왕복 검사,
최적화 Barrett 상수표 검사다. 별도의 전체 공식 KAT나 전 입력 상수시간 증명을
완료했다는 뜻은 아니다. RNS 커널의 상세 검사는 `../function_compare/ntt_k4c`에 별도 기록한다.

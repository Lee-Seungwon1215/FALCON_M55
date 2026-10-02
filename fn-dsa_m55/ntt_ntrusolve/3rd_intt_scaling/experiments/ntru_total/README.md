# NTRU solve 전체 시간 — 별도 진단

기존 `fn-dsa_m55/ntru_profile`의 `control` 계측을 재사용한다.
각 크기 10개 결정적 seed로 키를 생성하며, 각 키에서 재시도된 호출을 포함한
`solve_NTRU` 진입/종료 사이클을 합산한다. 이 진단은 전체 API 100회 성능 측정과 별개다.
계측 오버헤드를 빼지 않으며, 결과의 평균은 `NTRU_TOTAL.total / 10`으로 키 1개당
NTRU solve 누적 사이클을 뜻한다. NTRU 호출 1회 평균과 혼동하면 안 된다.

암호 소스는 선택한 전체 H0 주소 대조군 또는 H1 폴더에서 온다.
계측은 `build/control/generated/`의 C 복사본에만 넣는다. 후보의 원본 C/S는 수정하지 않는다.
실제 `kgen_mp31_cm55.s`를 포함하고 `FNDSA_MVE_MP31=1`로 빌드하므로
이전 C-only RNS 프로파일 경로로 되돌아가지 않는다.
보드 설정·linker·loader는 기존 측정 도구를 그대로 사용한다.

```sh
bash fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/experiments/ntru_total/build.sh h0_layout
bash fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/experiments/ntru_total/build.sh h1
python3 -B fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/experiments/ntru_total/run.py h0_layout
python3 -B fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/experiments/ntru_total/run.py h1
```

각 결과는 `<subject>/results/control/`에 보관한다. 보드는 순차 실행한다.
크기별 키 fingerprint와 NTRU 호출 수가 같고, 진단 ELF의 iNTT 밖 배치가 일치하는지도 확인한다.

## 빌드·실행 일치 검사 (2026-09-15 보강)

`build.sh`가 컴파일 전에 `provenance.json`을 `ready=false`로 만들고,
성공 후에만 `ready=true`와 ELF·map·config·compile command·생성 C의 해시를 기록한다.
원본 C/H/S 전체(어셈블리 6개와 헤더 포함), 계측 생성기와 진단 harness도 함께 묶는다.

`run.py`는 보드 실행 전과 후, 결과 복사 후에 빌드와의 일치를 검사한다.
실행 중 소스/ELF가 바뀌거나 다른 빌드로 교체되면 성공 로그가 있어도 `valid=false`다.
복사한 소스·펌웨어도 확인한 뒤에만 새 `validated.json`을 발행한다.
실행 결과에는 빌드 당시 `provenance.json`을 함께 보관한다.

구형 빌드에 이 manifest가 없으면 실행을 차단한다. 수동으로 과거 ELF에 manifest를 붙이지 말고
위 `build.sh`로 다시 빌드해야 한다. `--prepare-build`/`--record-build`는 build.sh 내부 단계이며
직접 실행해서 재빌드를 생략하기 위한 명령이 아니다.

보드를 사용하지 않고 확인하려면 저장소 루트에서 실행한다.

```sh
python3 -B fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/experiments/ntru_total/run.py h0_layout --check-build
python3 -B fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/experiments/ntru_total/run.py h1 --check-build
```

과거 측정 archive는 수정하지 않는다. 2026-09-15 보강 후 H0/H1을 재빌드했고,
두 ELF 및 암호 소스는 각각 기존 archive와 byte-identical이었다. 보드 재측정은 하지 않았다.

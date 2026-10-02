# D1_vld4_last — M55 측정 도구

이 디렉터리의 도구는 상위 후보의 **로컬 암호 소스 전체**를 빌드한다.
구현 선택용 옵션/다른 후보 암호 소스 링크는 추가하지 않는다.
고정된 공용 Zephyr/보드 harness를 사용하므로 이 디렉터리만으로 완결된 독립 SDK는 아니다.

설정과 최종 비교 방법은 [stage-4 README](../../README.md), 결과는
[후보 결과](../result.md)를 따른다. 원본 D0 대신 주소를 맞춘 D0 대조군의
측정에는 상위 `build_compare.sh`/`compare_tools.py`를 사용한다.

이 디렉터리에서:

```sh
bash build_m55.sh audit
bash build_m55.sh perf
python3 -B m55.py check --built audit
python3 -B m55.py check --built perf
python3 -B audit_k2.py
```

보드 작업은 승인된 보드를 **단독으로 순차 사용**한다. 각 명령이 완전히 종료된 뒤
다음 명령을 실행한다. 새 label은 영문 소문자/숫자/밑줄/하이픈으로 지정한다.

```sh
python3 -B m55.py run audit pilot --label next_audit
python3 -B m55.py run perf pilot --label next_perf
python3 -B m55.py run perf full --label next_perf
```

`full`은 같은 label/ELF의 성능 파일럿 통과가 필요하다. audit/perf를 혼동하지 않는다.
검증은 원시 로그의 정확한 소수·변환·lane·배치 개수, KAT/digest, 정상 서명 및 변조 거부,
설정·오류 레지스터, 빌드/소스 해시를 확인한다. 누락·중복·검사량 0인 결과는 거부한다.
정적 상수시간 검사는 K1/K2 ELF disassembly를 별도 대조하며 동적 누출 실험은 아니다.

현재 K2 빌드 경로는 `build/k2-root-pipeline-m55-audit`,
`build/k2-root-pipeline-m55-perf`다. K1 로그와 ELF는 기존 run archive에 보존한다.
새 run마다 raw.log, run.json, ELF/map/config, 31개 C/H/S 및 build manifest를 보관한다.
`h1_build.json`은 호환을 위해 유지한 manifest 이름이고 내용은 실제 후보 경로/해시다.

과거 복사된 H1 빌드/로그와 `Makefile.legacy`, `README.legacy.md`,
C-only 프로파일러는 이번 비교에 사용하지 않는다.

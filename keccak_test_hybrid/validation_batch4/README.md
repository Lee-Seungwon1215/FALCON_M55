# 키생성·검증 배치의 실물 M55 시험

이 폴더는 테스트 도구다. 배포 구현은 상위 폴더의 `kgen.c`, `vrfy.c`,
`shake_independent4.c/.h`, `sha3x4_cm55.s` 및 `fndsa_batch4.h`에 직접 작성돼 있다.
상위 Makefile은 상위 폴더의 소스만으로 standalone archive를 만든다.

```sh
bash keccak_test_hybrid/validation_batch4/build.sh
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
python keccak_test_hybrid/validation_batch4/run.py
python keccak_test_hybrid/validation_batch4/analyze.py
```

빌드 도구는 원본 `Before_slothy/kgen.c`, `vrfy.c`의 **외부 함수 이름만 바꾼
테스트 비교군**을 만든다. candidate backend를 외부 경로로 연결하는 것이 아니다.
`fn-dsa_ref` portable 코드에서 deterministic fixture를 생성한다. 해당 원본 소스를
변경했다면 `build/fixtures/expected.h`도 다시 생성해야 한다.

시험은 실제 N657 RAM 실행이며 Flash 쓰기/지우기는 하지 않는다. 기존 두 board lock을
획득하고 종료 시 해제한다. GCC/Zephyr/mlkem-native/OpenOCD는 기존 pinned 환경이다.
`.bin`은 주소 간격 때문에 과도하게 커질 수 있어 출력하지 않고 ELF만 사용한다.

최종 `results/...`에 ELF, map, compiler commands, disassembly, source archive/hashes,
원본 fixture, raw log, manifest를 남긴다. `summary.json`의 단위는 **4개 요청 전체**다.

키생성 blocks=64 사용 예(실제 크기는 API로 구할 것):

```c
#include "fndsa_batch4.h"
/* jobs[0..3]에 서로 독립적인 seed와 sk/pk 출력 버퍼를 채운다. */
size_t need = fndsa_keygen_batch4_temp_size(64);
int ok = fndsa_keygen_seeded_batch4_temp(jobs, 64, work, need);
/* 출력 키는 유지하고 secret scratch/prefix만 지운다. */
fndsa_batch4_clear(work, need);
```

검증은 `fndsa_verify_batch4_temp()`가 1을 반환한 뒤 각 `jobs[i].valid`를 확인한다.
입력·출력·jobs·work의 비중첩 계약을 지켜야 한다. 내부 힙 할당/묵시적 큐는 없다.

결과/한계는 [상위 result.md](../result.md) 참고. 이번 작업은 단일 Keccak 최적화나
기존 KAT 변경형 서명 PRNG를 KAT 유지형으로 바꾸는 작업이 아니다.

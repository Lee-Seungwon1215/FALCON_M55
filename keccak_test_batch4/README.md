# 원본 출력을 보존하는 키생성·서명·검증 x4 배치

## 현재 상태 — 2026-10-01 전체 SHAKE x4 경로

키생성·서명 배치의 단일 SHAKE 복귀 경로를 제거했다. 추가 난수 생성과
서명 재시도도 x4 엔진을 사용한다. 단, **x4 엔진을 사용한다는 것과 매번
네 lane이 유효하게 병렬 처리된다는 것은 다르다.** 부분 배치에서는 일부
계산을 버리고 해당 lane의 이전 상태를 보존하므로 더 느려질 수 있다.
특히 서명 본체는 공유 scratch 때문에 여전히 순차 실행한다.

새 경로의 재현·검사는 [full_x4_validation/README.md](full_x4_validation/README.md),
최종 성능과 단일 호출 0회 검사는 [full_x4_validation/result.md](full_x4_validation/result.md)를 따른다.
이전 prefix-only C/ASM은 `full_x4_validation/baseline/prefix_only_20261001.tar.gz`에 보존했다.

이 폴더 하나에 다음 **세 가지 4건 배치 API**가 모두 있다.
각 요청의 원래 SHAKE 입력과 출력을 보존한다. KAT이 달라지는 옛 hybrid 서명
PRNG 코드는 가져오지 않았다. `Final_code/Before_slothy`는 변경하지 않았다.

| 대상 | 배치 API | x4로 처리하는 부분 |
|---|---|---|
| 키생성 | `fndsa_keygen_seeded_batch4_temp()` | 후보 난수의 연속 보충·재시도, 최종 공개키 해시 |
| 서명 | `fndsa_sign_seeded_batch4_temp()` | mu·개인키/seed 해시·nonce·샘플러 추가 출력·재시도·Hash-to-Point |
| 검증 | `fndsa_verify_batch4_temp()` | 공개키 해시·메시지 해시·Hash-to-Point |

NTT·FFT·NTRU solve·서명 샘플링·검증 다항식 계산 전체를 네 개 동시에 실행하는
구현은 아니다. 기존 단일 API도 남아 있으며, 네 건을 자동으로 모으거나 x4로
자동 전환하지 않는다. caller가 독립 요청 네 건을 준비해서 배치 API를 호출한다.
네 출력을 섞어 한 요청의 난수로 쓰지 않는다.

공개 API는 [fndsa_batch4.h](fndsa_batch4.h)에 모았다. 작업 공간은 각 size 함수로
확인한다. 현재 ARM ABI에서 키생성 blocks=64는 **73,599 bytes**, 서명 blocks=112는
**136,031 bytes**, 검증은 **14,207 bytes**이며 내부 호출 스택은 별도다.
서로 순차 호출한다면 완료된 작업 공간을 다음 작업에 재사용할 수 있지만,
살아 있는 입력·출력과 겹치면 안 되고 사용 후 비밀 작업 공간을 지워야 한다.
키생성·서명은 caller가 seed를 제공하는 API다.

검증 API의 반환값 1은 '배치 처리 완료'를 뜻하며, 개별 유효성은
`jobs[i].valid`를 확인해야 한다. 키생성은 blocks=0..128, 서명은 0..160을 지원한다.
blocks는 이제 반복해서 채우는 큐 용량이며 0은 최소 1블록 큐를 뜻한다.
세 경로 모두 512/1024 혼합 요청을 지원하지만 동일 크기 배치와 같은 속도를
보장하는 것은 아니다.

키생성·검증 구현은 이 폴더의 `kgen.c`, `kgen_gauss.c`, `vrfy.c`,
`shake_independent4.c/.h`에 직접 들어 있다. 이미 있던 `sha3x4_cm55.s`를 공유한다.
hybrid 폴더의 암호 소스를 include/링크하지 않는다. 기존 서명 산술/ASM은 유지하고
SHAKE를 호출하는 C 경로만 변경했다.

- [최신 전체 결과](result.md)
- [이전 prefix-only 연산 비중](profiling/result.md)
- [이전 prefix-only 키생성·검증 시험](validation_keygen_verify/README.md)
- `validation/` 및 `validation_keygen_verify/`는 이전 정책의 기록이다. 현재
  변경된 workspace/정책 검사는 `full_x4_validation/`을 사용한다.

## 아래는 2026-09-30 prefix-only 구현의 보존 설명

아래의 구조·메모리·측정 명령은 과거 버전에 대한 기록이며 현재 구현 지침이 아니다.

`Final_code/Before_slothy`를 복사한 독립 M55 라이브러리다. 기존 NTT/FFT,
단일 SHAKE 및 Keccak CM4 구현은 그대로 두고, **서로 독립적인 서명 네 건의
원래 SHAKE 스트림 일부만 같은 MVE Keccak x4 호출에서 계산**한다.
기존 `keccak_test_mlkem`, `keccak_test_vecfalcon`, `keccak_test_hybrid`와
`Final_code/Before_slothy`는 수정하지 않았다. SLOTHY는 적용하지 않았다.

## 이전 x4 실험과 다른 점

- 이전: 한 서명의 subseed로 네 스트림을 만들고 네 출력을 섞어서 샘플러에 공급.
- 현재: 서명마다 원본처럼 key/message/seed로 40-byte seed를 유도한다.
  각자의 `SHAKE256(derived_seed || counter=0)` 출력을 별도 버퍼에 저장한다.
- 첫 40바이트 nonce도 같은 스트림에서 가져온다. nonce 뒤의 바이트가 해당
  서명의 샘플러로 이어진다. lane ID나 새 도메인 구분자를 넣지 않는다.
- 남은 바이트가 u16/u64보다 짧아도 버리지 않는다. 버퍼/136-byte rate 경계를
  가로질러 원본처럼 읽는다.
- 버퍼를 소진하면 **그 서명의 다음 원래 SHAKE 상태**로 단일 CM4 처리를
  이어간다. 서명 재시도 counter 1..26은 원래 seed/counter 방식으로 실행한다.

이는 **고정 길이 prefix 선생성 방식**이다. 서명 네 개의 FFT/샘플러를 동시에
실행하는 코루틴이나, 모든 후속 SHAKE 호출을 끝까지 x4로 처리하는 구현은 아니다.
서명 네 건은 공통 임시 배열을 재사용하면서 순서대로 완성한다.
따라서 개선 수치는 네 건 전체 처리량이고 단일 요청 응답시간과 같지 않다.

## 파일 구성

| 파일 | 변경 내용 |
|---|---|
| `sha3x4_cm55.s` | hybrid의 동일 x4 permutation 재사용. 출력은 새 MVE scatter 저장으로 네 버퍼에 분리 |
| `shake_batch4.c/.h` | 원본 seed/counter의 prefix 생성, 독립 스트림 읽기, 원본 CM4 상태로 이어가기 |
| `fndsa_batch4.h` | 배치 API 및 작업 기술자 |
| `sign.c` | 원래 키/seed 준비 과정을 분리하고 네 작업을 준비·실행하는 API 추가 |
| `sign_core.c` | 최초 시도의 prefetched 스트림을 받음. 재시도는 원래 방식 |
| `sign_inner.h`, `sign_sampler.c` | 샘플러에서 자기 스트림의 바이트만 소비 |
| `validation/` | 원본과 동일 펌웨어 내 직접 비교. 테스트에만 이름을 바꾼 원본 복사본 포함 |

다른 후보 파일을 include/링크하여 암호 구현을 선택하지 않는다. 최상위 Makefile은
이 폴더의 실제 소스를 통상적으로 빌드한다. `validation/reference`는 원본 비교용이며
배포 라이브러리에 포함되지 않는다.

## 사용

`fndsa_sign_batch4_job jobs[4]`에 네 건의 키·메시지·context·seed·출력 버퍼를
각각 넣는다. 키/입력/크기가 모두 달라도 된다. 512/1024만 지원한다.

```c
/* jobs[0..3]는 각각 독립적인 서명 요청으로 초기화되어 있어야 한다. */
unsigned blocks = 112;
size_t need = fndsa_sign_batch4_temp_size(blocks);
/* work는 need 바이트 이상, 모든 입력/출력 및 jobs와 비중첩이어야 한다. */
int ok = fndsa_sign_seeded_batch4_temp(jobs, blocks, work, work_len);
/* 개별 반환 길이: jobs[s].sig_len */
fndsa_sign_batch4_clear(work, work_len);
```

`blocks`는 공개 메모리 정책이며 0..160까지 허용한다. 측정한 정책은 32/64/112다.
112이면 lane당 15,232바이트를 준비하고, 임시 공간 요구량은 **126,783바이트**다.
이 중 공통 서명 임시 배열도 포함된다. 기존 단일 서명 최대 임시 배열 요구량은
60,447바이트이며, 그 차이는 66,336바이트다. API에는 숨은 전역 상태나 동적 할당이 없다.

caller seed는 필수다. 이 실험용 결정적 API는 자체적으로 외부 엔트로피를 생성하지
않는다. 실제 사용 시 기존 seeded API와 동일하게 적절한 seed를 제공해야 한다.
기존 단일 `fndsa_sign*()` API도 그대로 제공한다.

작업 공간에는 비밀 키 파생값과 미사용 난수열이 남으므로 사용 후 지워야 한다.
키·seed·출력·work·job 배열은 겹치면 안 된다. 전체 검증 완료 전 네 결과를 게시하지
않는 정책 등은 호출자가 결정한다. 반환값 0이면 각 `sig_len`도 확인한다.

## 재현

```sh
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
make -C keccak_test_batch4 -j4
bash keccak_test_batch4/validation/build.sh
python keccak_test_batch4/validation/run.py
python keccak_test_batch4/validation/analyze.py
python keccak_test_batch4/validation/audit_sources.py
```

원본 일치·보드 조건·측정 한계는 [result.md](result.md)에 정리했다.

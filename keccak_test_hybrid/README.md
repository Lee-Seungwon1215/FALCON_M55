# 측정 기반 하이브리드 SHAKE256x4 — M55

## 현재 연결 상태 — 키생성·검증 배치 추가

이 폴더에는 **서로 다른 두 사용 방식**이 함께 있다. 혼동하지 말 것:

| 경로 | 요청 단위 | 기존 기본 구현과 출력 호환 |
|---|---|---|
| 기존 서명 샘플러 x4 | 서명 1건 안에서 새 난수 4줄을 결합 | 기존 KAT과 다름. 이번 변경 대상 아님 |
| 새 키생성 x4 배치 | 독립적인 키생성 4건 | 시험한 입력에서 원본 키와 byte-exact |
| 새 검증 x4 배치 | 독립적인 검증 4건 | 시험한 입력에서 원본 검증 결과와 일치 |
| 기존 단일 키생성·검증 API | 1건 | 기존 동작 유지. 자동으로 x4를 호출하지 않음 |

KAT 유지형 **서명 4건 배치**는 별도 `../keccak_test_batch4`에 있다.
그 코드를 이번 작업에서 여기에 통합하지 않았다. `Before_slothy`도 변경하지 않았다.

새 공개 인터페이스는 [fndsa_batch4.h](fndsa_batch4.h)다.

- `fndsa_keygen_seeded_batch4_temp(jobs, blocks, work, work_len)`:
  각 원본 `SHAKE256(seed)`의 첫 `blocks × 136` bytes를 함께 생성한 뒤,
  네 키를 순서대로 풀되 자기 prefix만 소비한다. 소진 후 원래 단일 SHAKE 상태로
  계속한다. `f,g`의 난수/홀수 parity/재시도 순서는 바꾸지 않는다.
  NTRU solve, NTT/FFT, 공개키 생성과 마지막 공개키 해시는 원래 계산이다.
- `fndsa_verify_batch4_temp(jobs, work, work_len)`:
  공개키 해시, 원래 context/domain/message로 만드는 `mu`, Hash-to-Point를 x4로
  계산한다. 디코딩·NTT·다항식 연산·노름 검사는 원본과 같은 함수를 사용한다.
  반환값 1은 **배치 실행 완료**이며, 각 서명의 판정은 `jobs[i].valid`에 있다.
- `fndsa_batch4_clear(work, work_len)`: 키생성 작업 공간의 비밀 prefix를 사용 후 삭제.

두 API 모두 512/1024 혼합, 서로 다른 입력 길이를 지원한다. 네 건이 이미 준비됐을
때 caller가 명시적으로 호출한다. 자동 큐/대기/전역 상태/동적 할당은 없다.
한 건만 있으면 기존 단일 API를 호출하면 된다.

키생성 `blocks=64`의 caller 작업 공간은 **57,375 bytes**, 검증은 **14,207 bytes**다.
내부 호출 스택은 별도다. 키생성 blocks는 0..128이며 NULL seed는 거부한다
(임의 길이의 non-NULL seed, 길이 0 포함, 사용 가능). 버퍼 간 비중첩 등 계약은 헤더 참조.

새 구현 파일은 `shake_independent4.c/.h`, `fndsa_batch4.h`이며,
`kgen.c`, `kgen_gauss.c`, `vrfy.c`, `sha3x4_cm55.s`를 직접 수정했다.
기존 x4 permutation은 그대로, 독립 출력용 MVE scatter 루틴만 추가했다.
`Makefile`에는 같은 폴더의 새 C 파일 한 개만 일반 소스로 등록했다.
다른 후보의 소스를 링크하거나 옵션으로 구현을 선택하지 않는다.

실물 M55 검사 및 네 건 전체 성능: [result.md](result.md).
재현 도구: [validation_batch4](validation_batch4/README.md).

## 아래는 보존한 기존 단일 서명 x4 설명

VecFalcon 적응 후보의 low/high x4 상태 및 sampler PRNG 구조에, ML-KEM 후보에서 사용한 θ·ρ·π 결합을 적용했다. 마지막 출력은 새 MVE `VST20/VST21` 전치 루프로 처리한다. 세 후보 중 실제 전체 서명 및 32KiB PRNG 성능을 기준으로 선택했다.

## 출처와 이식 범위

- [mlkem-native MVE 개발 원본](https://github.com/pq-code-package/mlkem-native/blob/fc269bc2d1068486625a3775310c2c1f28d74732/dev/fips202/armv81m/src/keccak_f1600_x4_mve.S): even/odd 비트 분리, 4개 독립 상태의 같은 위치 병렬 처리, θ·ρ·π 통합 메모리 흐름을 참고했다. upstream ASM을 그대로 가져온 성능 재현이 아니라 새 M55 ASM 구현이다.
- [VecFalcon SHAKE/PRNG](https://github.com/Ji-Peng/VecFalcon/blob/61b326e9bb6afe2ea4927e7a25832e7a64485367/opt/sha3.c) 및 [서명 연결](https://github.com/Ji-Peng/VecFalcon/blob/61b326e9bb6afe2ea4927e7a25832e7a64485367/opt/sign_core.c): 56-byte subseed, SHAKE256(seed || stream ID), 8-byte 출력 교차 배치와 sampler 연결을 참고했다.
- VecFalcon의 원래 AArch64 ASM은 **스칼라 2개 + NEON 2개 상태**를 교차 실행한다. 여기서는 그 레지스터 스케줄을 복제하지 않는다. M55의 8개 Q 레지스터와 32-bit 정수 MVE에 맞춰 네 스트림을 4×32-bit로 처리했다. 그러므로 이 결과는 'VecFalcon 원본 ASM의 M55 재현 수치'가 아니다.

## 공통 연결

`sign_core.c`에서 기존 SHAKE256(seed || 1-byte counter)의 첫 40 bytes를 nonce로 유지하고,
다음 56 bytes를 x4 PRNG seed로 사용한다. `sign_sampler.c`의 u8/u16/u64 공급원만 x4로 바꿨다.
네 스트림은 SHAKE256(subseed || 0), ..., SHAKE256(subseed || 3)이다.
각 136-byte rate block의 8-byte word를 stream 0→1→2→3 순서로 배치해 544-byte buffer를 만든다.
u16/u64를 얻을 때 남은 공간이 부족하면 마지막 1~7 bytes를 버리고 refill하는 VecFalcon 규칙도 유지한다.

현 FN-DSA 버전의 counter/nonce/hash API를 보존했으므로, VecFalcon 구버전의 4-byte counter,
별도 Gaussian vector sampler, 전체 서명 API까지 복제한 것은 아니다. **연결 지점은 같은 서명 샘플러**다.
기존 단일 SHAKE와 SHA3 API, 키생성, Hash-to-Point, 검증 경로는 그대로다.
`Final_code/Before_slothy`에는 이 실험을 반영하지 않았다.

## 파일

- `sha3x4_cm55.s`: 새 M55/MVE x4 permutation. 소스 자체에 직접 작성했다.
- `sha3x4.c`, `sha3x4.h`: x4 상태/seed/refill/출력.
- `sign_core.c`, `sign_inner.h`, `sign_sampler.c`: sampler 연결.
- `Makefile`: 이 폴더 소스만으로 archive 생성. 누락되어 있던 기존 서명 ASM 3개도 목록에 포함했다.
- 다른 후보의 암호 코드를 include/link하거나 빌드 옵션으로 backend를 고르는 구조가 아니다.
- 공통 **시험 도구만** `../keccak_test_mlkem/validation`에서 각 폴더의 소스를 빌드한다.
  시험의 고정 배치 링크 스크립트는 함수/데이터 위치를 맞추는 용도이며 암호 구현을 대체하지 않는다.

## 실험용 주의사항

기존 FN-DSA deterministic signature KAT 유지가 목적이 아닌 **변경 PRNG 성능 실험**이다.
세 후보와 순차 x4 대조군의 난수·서명은 서로 같아야 하지만 원래 단일 SHAKE 서명과는 다르다.
독립 Keccak oracle, SHAKE 출력 대조, 서명 검증·변조 거부를 검사했다.
상수시간/누출/새 PRNG 보안의 종합 인증을 끝낸 배포용 구현이라고 주장하지 않는다.
시험 키는 공개된 결정적 입력으로 만든 키이므로 실제 사용 금지.

`baseline_documents/`는 복사 당시의 README/result 보존본이다.
기존 `stage_profile_result.md`, `ntru_fft_profile_result.md`도 이전 코드 기록이며 x4 재계측 결과가 아니다.
최신 결과는 [result.md](result.md)를 확인한다.

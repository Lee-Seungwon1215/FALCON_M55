# FN-DSA (in C)

## 2026-09-17 최신 상태: 공통 q-NTT + RNS NTT Slothy 통합

- `mq_cm55.s`: 공통 q-NTT/iNTT의 기존 Slothy A.
- `kgen_mp31.c` + `kgen_mp31_cm55.s`: K4-C 기반 RNS NTT/iNTT + Slothy A.
- 루트 C/H/S 31개가 검증된 `../ntt_ntrusolve/ref_slothy`와 동일하다.
- 이 경로의 소스로 새 펌웨어를 빌드하고, 최적화 전 `../M55_ref`와 같은
  측정 프로그램·배치 정책에서 보드 KAT/서명검증 및 API별 100회 실측을 완료했다.
- 최신 수치·원시 로그는 [result.md](result.md)와
  [원본 대비 동일 조건 비교](../ntt_final_compare/result.md)에 기록했다.
- 비교 재실행은 [ntt_final_compare/README.md](../ntt_final_compare/README.md)를 따른다.
  기존 `measurement/run.py`·`measurement/audit.py`는 과거 q-NTT-only 실험의
  고정된 소스/경로를 전제로 하므로 현재 누적 구현의 측정에 그대로 사용하지 않는다.

**아래 2026-09-14 설명은 공통 q-NTT Slothy 통합 당시의 이력이다.**
당시 파일 개수·경로·"RNS 미변경" 표현을 현재 상태로 해석하지 않는다.

## Local Cortex-M55 NTT implementation — 1~4단계 + SLOTHY A

2026-09-14: **검증된 SLOTHY A의 완성 어셈블리를 이 폴더의 `mq_cm55.s`에 직접 반영했다.**
`../ntt_opt`는 SLOTHY 적용 전 기준본으로 보존하고, 이 디렉터리는 적용 후 기준본으로 사용한다.
두 기준본 모두 upstream reference인 `fn-dsa_ref`와 구분한다.

- 1단계: MVE 8×16-bit 병렬 처리와 마지막 layer 재배열.
- 2단계: 512는 `2+3+2`, 1024는 `2+2+2+2` 병합 후 기존 마지막 2-layer.
- 3단계: B1 3명령 Barrett 상수곱. 전용 root/twist 네 배열 8,192 B는 `mq.c`에 유지.
- 4단계: **S1-B phase-grouped + S2-B cross-layer + S3-A twiddle preload**.
- 5단계: **SLOTHY A — 반복 내부 명령 스케줄링 및 제한적인 벡터 레지스터 재배정**.
- `mq_cm55.s`에 직접 반영. 후보 파일을 include하거나 빌드 설정으로 조합하지 않는다.
- 키생성·서명·검증별 구현 선택은 없으며, 모두 같은 공통 함수를 호출한다.
- 다른 공개 logn의 기존 경로, FFT, sampler, NTRU solver는 이번 통합에서 변경하지 않았다.

### 직접 반영한 범위

계산 소스에서 `../ntt_opt`와 다른 파일은 `mq_cm55.s` 하나이며, 내용은
`../ntt_opt_5thStage/slothyA/mq_cm55.s`와 바이트 단위로 동일하다.
대상은 `fndsa_mqpoly_int_to_ntt`와 `fndsa_mqpoly_ntt_to_int`의 512/1024용 10개 구간이다.
`mq.c`의 Barrett 상수표, 나머지 C/H/S, Makefile, 링크 스크립트는 변경하지 않았다.
SLOTHY B의 반복 간 파이프라인은 포함하지 않는다.

### 검증 및 측정 상태

이번 반영에서 확인한 항목:

- 루트의 C/H/S 30개 파일이 선택한 SLOTHY A와 모두 동일하다.
- `mq_cm55.s` SHA-256: `b826d79ed25d1529007fe8bf5eac71e60bdde336e65e7c3bb6738264d28b382d`.
- 기존 A와 같은 GCC 15.2.1 Cortex-M55 컴파일 조건으로 새 파일을 단독 어셈블했다.
  생성된 `.text` 전체 바이트와 relocation 항목이 기존 A object와 동일하다.
- 원본 대비 stack·분기 구조가 유지되며, 독립 ISA interpreter의 816개 연산 상태·메모리 접근 순서 회귀검사를 통과했다.
- 검사 object는 임시 디렉터리에서 생성·정리했다. Makefile과 링크 설정은 변경하지 않았다.

**2026-09-14: 새 경로 전체 펌웨어 빌드·보드 검증·100회 성능 재측정도 완료했다.**
계산 C/S 23개 모두 이 폴더에서 컴파일했고, ELF의 실행 section 전체 바이트·데이터·주소와
모든 함수 바이트·주소가 기존 A와 동일하다. 기존 결과를 새 측정으로 복사하지 않았다.

실제 M55에서 512/1024 NTT oracle/roundtrip 오차 0, 고정-seed host DIGEST/AUDIT 22개 일치,
정상 서명·변조 거부 PASS, fault 레지스터 0 및 TCM ECC ON을 확인했다.
각 크기·연산별 10배치 × 10회 측정 결과는 기존 A와 0~2 cycles/call 차이였다.
자세한 수치·조건·원본 로그는 [새 경로 실측 결과](result.md)에 기록했다.
이 검사는 형식적 상수시간 증명이나 dudect/전력·EM TVLA, 공식 인증 KAT를 뜻하지 않는다.
실행 주소 고정 진단은 별도 linker 설정을 사용한 과거 실험이며 이번 일반 배치 측정과 구분한다.

- [새 경로 전체 빌드·보드 KAT·성능 결과](result.md)
- [SLOTHY A 적용 범위·검증 방법](../ntt_opt_5thStage/README.md)
- [기존 A/B 보드 결과](../ntt_opt_5thStage/RESULTS.md)
- [실행 위치 고정 대조 결과](../ntt_opt_5thStage/layout_diagnostic/RESULTS.md)
- [SLOTHY 적용 전 통합 결과](../ntt_opt/result.md)
- [12개 조합 비교](../ntt_opt_4thStage/combinations/RESULTS.md)
- [4단계 충돌 해결과 논문 근거](../ntt_opt_4thStage/combinations/REVISION.md)
- [이전 1~3단계 기준 소스·ELF](../ntt_opt_4thStage/integration/before/README.md)

기존 stage-4 `build_integrated.sh` / `run_integrated.py`는 `ntt_opt`를 대상으로 한다.
이를 새 경로의 실행기로 간주하지 않는다. 새 경로 전용 실행기는 `measurement/build.sh`,
`measurement/run.py`, `measurement/audit.py`이며, [실행 순서](result.md#5-재실행-방법)를 따른다.
이 실행기는 기존 공통 보드 측정 환경을 재사용하되 계산 소스는 이 폴더에서 직접 빌드한다.
SLOTHY 코드가 빌드 옵션·Makefile·링커를 통해 적용되는 것은 아니며 다른 후보 계산 파일을 가져오지 않는다.
향후 범위를 넓힐 때도 두 기준본의 공통 알고리즘 변경을 맞추고 실제 SLOTHY 적용 구간을 기록한다.

---

FN-DSA is a new *upcoming* post-quantum signature scheme, currently
being defined by NIST as part of their [Post-Quantum Cryptography
Standardization](https://csrc.nist.gov/pqc-standardization) project.
FN-DSA is based on the [Falcon](https://falcon-sign.info/) scheme.

**WARNING:** As this file is being written, no FN-DSA draft has been
published yet, and therefore what is implemented here is *not* the
"real" FN-DSA; such a thing does not exist yet. When FN-DSA gets
published (presumably as a draft first, but ultimately as a "final"
standard), this implementation will be adjusted accordingly.
Correspondingly, it is expected that **backward compatiblity will NOT be
maintained**, i.e. that keys and signatures obtained with this code may
cease to be accepted by ulterior versions. Only version 1.0 will provide
such stability, and it will be published only after publication of the
final FN-DSA standard.

**2026-07-22:** This code has been adjusted to match my *best guess* of
what the FIPS 206 (FN-DSA) draft will contain. The public process within
the complicated layers of red tape above NIST seems to be currently
stuck for unclear reasons, so that nobody really knows when the draft
will be published (presumably it *will* be published at some point,
between now and the End of Times, but a more precise date estimate
cannot be obtained). The guess is based what NIST announced, in
particular at [a NIST-sponsored workshop in September
2025](https://csrc.nist.gov/presentations/2025/fips-206-fn-dsa-falcon).
Compared to the Falcon scheme, and to previous versions of this code,
the following points are noteworthy:

  - Encoding rules (public keys, private keys, hash-to-point sampling)
    have been harmonized to little-endian.

  - Public keys are now in NTT format (original Falcon used plain format
    so as to leave room for alternate NTT implementations or for non-NTT
    computations, but in practice the usual "bit-reversal" NTT is just
    too convenient and there is little point in using anything else).

  - Maximum infinity norm of signatures is now set to 840 (a suggestion
    from Yang Yu; it apparently helps with some security proofs), down
    from the previous limit of 2047 (which was needed for encoding format
    reasons).

  - An intermediate "mu" value (64 bytes) is computed from the input, with
    the same method as in ML-DSA. This covers both "raw" and "pre-hashed"
    variants, and supports "external mu" hashing for people who like that
    kind of thing.

  - A hash of the public key (using SHAKE256, with a 64-byte output) is
    included in the "mu" computation. This hash value is now part of the
    private key storage format, which is thus enlarged by 64 bytes (it
    is conceptually possible to recompute the public key and then its
    hash from the other private key fields, but the interchange format
    for private keys must now include the hash).

  - All internal seeds are harmonized to 40 bytes (except the keygen
    seed, which is at 32 bytes). When signing, a new 40-byte seed is
    generated for each attempt (this is inexpensive now that an
    intermediate "mu" is computed, and it [helps with security
    proofs](https://eprint.iacr.org/2024/1769)).

  - The base sampler (in the Gaussian sampling) now uses 79 bits of
    randomness instead of 72 (since an extra bit is needed for the sign,
    the base sampler already used 10 bytes from the PRNG, so this merely
    uses the 7 extra bits instead of discarding them).

  - The "SHAKE256x4" optional support was removed (it provided only
    marginal speed benefits, and only for platforms with AVX2, while
    breaking test vector reproducibility).

  - Some improvements to keygen were imported from [eprint
    2025/1239](https://eprint.iacr.org/2025/1239), making keygen a bit
    faster and reducing RAM usage.

If I guessed right then this code *might* perfectly align with the
future FIPS 206 and would then not need any further adjustment, but no
such guarantee can be offered (in fact, the future FIPS 206 draft will
be a *draft* precisely because extra modifications might be included
into the final FIPS 206).

This implementation is the C variant of the [Rust
implementation](https://github.com/pornin/rust-fn-dsa/). It is
interoperable (indeed, it reproduces the same test vectors) and mostly
has feature parity and similar performance, with the following notes:

  - The C code's external API is in [fndsa.h](fndsa.h). This is the
    only file that application code needs to include.

  - The files `codec.c`, `mq.c`, `sha3.c`, `sysrng.c` and `util.c` are
    used for all operations. The files `kgen*.c` are used only for key
    pair generation. They can be omitted if not generating key pairs.
    Similary, the `sign*.c` files are only for signature generation, and
    `vrfy.c` is used only for signature verification. Typically, an
    application that only needs to verify signatures can avoid the code
    footprint cost of including the "kgen" and "sign" files.

  - The `speed_fndsa.c` and `test*.c` files are only for benchmarks and
    tests.

  - The API works only with keys in their encoded formats. Contrary to
    the Rust code, there is no "state" object that can be built and
    store reusable values across subsequent operations. Temporary
    buffers are normally allocated from the stack, but they can also be
    provided externally for builds targeting small embedded systems with
    shallow stacks.

  - When random bytes are needed, the operating system's RNG is invoked.
    This supports Windows and Unix-like systems (including Linux and macOS).
    For unsupported systems (including bare metal OS-less systems), the
    API has the option for the caller to provide a seed on which to work.
    It is then up to the caller to provide an adequately-sized seed with
    enough entropy (in general, aim for at least 256 bits of entropy).

For build options, see the [Makefile](Makefile). In general, the code
should work fine without needing much fiddling.

## ARM Cortex-M4

The implementation includes some assembly routines (some inline, and
some in separate assembly source files) which offer substantial
speed-ups, especially for signature generation, when running the code on
an ARM Cortex-M4F CPU. See [Makefile.cm4](Makefile.cm4) for compiling
that code with a cross-compiling system toolchain. Alternatively, see
the [bench_cm4/](bench_cm4) subdirectory for a benchmarking application
that can run on an STM32F407G-DISC1 board (using an STM32F4
microcontroller).

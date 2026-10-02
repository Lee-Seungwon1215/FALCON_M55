# Stage 4 S3-C: cross-iteration software pipeline

이 후보는 `fn-dsa_m55/ntt_opt`의 산술·레이어 병합·Barrett 상수표를
그대로 유지하고, 반복되는 MVE 데이터 chunk에만 명시적인
`prologue -> steady state -> epilogue` 파이프라인을 적용한다.

- prologue가 첫 iteration의 `q1..q4`를 적재한다.
- steady state는 iteration `i`의 산술을 수행한다. 먼저 완성되는 `q1`
  또는 `q1/q2`를 canonical 순서로 저장한 즉시 같은 레지스터에
  iteration `i+1` 값을 적재하고, 독립적인 현재-iteration tail 산술을
  계속한다. 나머지 결과도 저장 후 다음 값을 적재하므로 back edge에
  도달했을 때 다음 iteration의 `q1..q4`가 모두 준비되어 있다.
- epilogue는 이미 적재된 마지막 iteration만 계산·저장하며 successor
  load를 발행하지 않는다. 따라서 마지막 iteration의 경계 밖 read가 없다.
- prologue의 감소된 고정 loop count만 successor 유무를 결정하므로 추가
  분기는 공개 degree와 고정 counter에만 의존한다.

적용된 full-width 반복 loop는 다음 네 곳이다.

| degree/direction | loop | pipeline 단위 |
|---|---|---|
| 512 forward | `L512_CT2_chunk` | 8개 butterfly, 4개 stream |
| 1024 forward | `F2_vector` | 8개 butterfly, 4개 stream |
| 1024 inverse | `I2_vector` | 8개 butterfly, 4개 stream |
| 512 inverse | `L512_GS2_wide` | 8개 butterfly, 4개 stream |

`L3x512`는 q0-q7과 twiddle GPR이 모두 live이고 upper/lower half가 같은
scratch 위치를 재사용하므로 제외했다. 512 packed CT2/GS2 loop도 한 q
레지스터에 두 물리 group을 결합하고 iteration마다 여섯 packed twiddle을
갱신하여, stack spill 없이 다음 data와 twiddle을 동시에 유지할 공간이
없어 제외했다. `L5/L0` boundary kernel과 F2/I2 half-width 경로는 내부
반복 successor가 없으므로 epilogue-only로 유지했다. 이 제외로 S3-A의
현재-iteration twiddle preload나 S3-B의 within-iteration late-store와
S3-C의 실험 범위가 섞이지 않는다.

### 보드 측정 결과

2026-09-13 NUCLEO-N657X0-Q에서 ITCM/DTCM, cache OFF, GNU Arm 15.2.1,
`-O3`, degree·operation별 10 batch, 각 batch에서 10회 warm-up 후 10회
측정했다. 값은 upper median cycle/call이다.

| degree | 연산 | stage 1~3 기준 | S3-C | 절약 cycle | 개선율 |
|---:|---|---:|---:|---:|---:|
| 512 | keygen | 51,722,695 | 51,723,584 | -889 | -0.001719% |
| 512 | sign | 17,150,930 | 17,158,420 | -7,490 | -0.043671% |
| 512 | verify | 323,738 | 323,990 | -252 | -0.077841% |
| 1024 | keygen | 260,391,745 | 260,385,717 | 6,028 | 0.002315% |
| 1024 | sign | 36,748,666 | 36,758,816 | -10,150 | -0.027620% |
| 1024 | verify | 626,546 | 626,084 | 462 | 0.073738% |

1024 keygen·verify의 20개 대응 batch는 모두 개선됐지만 나머지 40개는
모두 느려졌다. 특히 두 sign API가 퇴행하고 코드도 2,256 B 증가하므로
**일반 S3 후보로는 선택하지 않는다.** 1024 keygen 전용 또는 조합의
상호작용을 확인하는 연구 대조군으로만 유지한다.

### 검증 및 상수시간 구조 감사

- GNU Arm 15.2.1, Cortex-M55/MVE assembly 성공
- Zephyr 4.4.1 `build-stage4-s3c`, `-O3` 전체 link 성공
- `mq_cm55.s` object text: 12,756 B (기준 10,500 B, epilogue body 복제)
- firmware FLASH: 108,572 B, RAM reservation: 225,728 B
- 새 stack push/pop 또는 stack spill 없음
- 논리 iteration당 butterfly·twiddle·data load/store 횟수는 기준과 동일
- Barrett 상수곱·forward oracle·inverse/oracle round-trip mismatch 0,
  최대 modular error 0
- board KAT digest 22개 일치, 서명검증·1-bit 변조 거부 PASS
- fault register 0, TCM ECC 실행 전후 `0x1300a`, stack 상한 9,624 B
- `mq_cm55.s` SHA-256:
  `8da35c7dcec4776ef760f020ff369231e8bb4f7fd505bd380327babbdb402b68`
- source tree SHA-256:
  `496775160f4764f483aaec4393480d51eddc8d3e1f67df53461531cd9247658a`
- build ELF SHA-256:
  `f76218498b8f75f885bf7e76493b9b79e0daa06fdf7c2929032f1d724353b128`

- [S3-C full raw log](../results/s3c/runs/full-20260913T091620Z/raw.log)
- [S3-C validated manifest](../results/s3c/full_validated.json)
- [정적 감사 기록](../results/s3c/static_audit.json)
- [기준 full raw log](../../ntt_opt_3rdStage/results/ntt_opt/runs/full-20260913T063156Z/raw.log)

상수시간 감사는 정적 소스·역어셈블 검사이며 전력/EM TVLA는 포함하지
않는다.

# FN-DSA (in C)

## Local Cortex-M55 NTT implementation

이 디렉터리는 1단계 MVE 배치, 2단계 레이어 병합, 3단계 B1 Barrett을
직접 합친 **M55 NTT 최적화 기준점**이다. upstream 공식 reference인
`fn-dsa_ref`와 구분한다. 3단계 후보 비교와 선택 근거는
[`../ntt_opt_3rdStage/README.md`](../ntt_opt_3rdStage/README.md)에 있다.

- FN-DSA-512 (`logn=9`): `2+3+2` 레이어 병합 후 기존 마지막 2-layer
- FN-DSA-1024 (`logn=10`): `2+2+2+2` 레이어 병합 후 기존 마지막 2-layer
- 그 외 공개 `logn`: 기존 1단계 일반 MVE 경로
- q=12289 NTT의 알려진 twiddle 상수곱은 B1의
  `VQRDMULH` → `VMUL` → `VMLA` 3명령 Barrett reduction을 사용한다.
- forward/inverse root와 보정상수 네 배열은 `mq.c`에 직접 들어 있으며
  총 8,192 B이다.
- 추가된 제어 흐름은 공개 `logn`과 고정 loop counter에만 의존한다.

2026-09-13 NUCLEO-N657X0-Q에서 ITCM/DTCM, cache OFF, GNU Arm 15.2.1,
`-O3`, degree·operation별 10개 고정 입력 batch, batch마다 10회 warm-up 후
10회 측정 조건으로 `ntt_opt` 경로를 다시 빌드·측정했다. 값은 upper median
cycle/call이다.

| degree | keygen | sign | verify |
|---:|---:|---:|---:|
| 512 | 51,722,695 | 17,150,930 | 323,738 |
| 1024 | 260,391,745 | 36,748,666 | 626,546 |

통합 후 검증 결과는 다음과 같다.

- B1 후보와 모든 C/H/S 소스 및 stripped 실행 이미지가 byte-identical
- Barrett 전용 MVE 상수곱 2,048쌍 mismatch 0
- 512/1024 scalar forward oracle, inverse round-trip, 최대 modular error 모두 0
- 고정-seed board KAT digest 22개가 host 정답과 일치
- 키생성·서명·검증 및 1-bit 변조 서명 거부 PASS
- `CFSR=HFSR=AFSR=0`, TCM ECC 실행 전후 활성
- 정적 상수시간 감사 PASS: secret-dependent branch/address 추가 없음;
  최종 ELF에 `VQRDMULH.S16`과 `VMLA.I16` 각각 57개 site
- main stack 사용 상한 9,624 B

현재 메모리 점유는 코드 106,316/131,072 B, DTCM 전체 예약량
225,728/262,144 B이며 각각 24,756 B와 36,416 B가 남는다. 상수시간 감사는
소스·역어셈블 수준이며 전력/EM TVLA는 포함하지 않는다.

통합 full run은
[`../ntt_opt_3rdStage/results/ntt_opt/runs/full-20260913T063156Z/raw.log`](../ntt_opt_3rdStage/results/ntt_opt/runs/full-20260913T063156Z/raw.log),
검증 manifest는
[`../ntt_opt_3rdStage/results/ntt_opt/full_validated.json`](../ntt_opt_3rdStage/results/ntt_opt/full_validated.json)에 있다.

- `mq.c` SHA-256: `58ca9a7d8b58862016cd43d24eca43343f3d2479981afdd6c1a9819f56a718a9`
- `mq_cm55.s` SHA-256: `b4f5834ac4cb72c6d51f62bf4c9746b58350e668ebcb193bf1e51272ae9fbbc3`
- full ELF SHA-256: `0a6e2474a2081f0e6ff493f028124df32200ac8fcade17a5707f5bb7a1e2839a`

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

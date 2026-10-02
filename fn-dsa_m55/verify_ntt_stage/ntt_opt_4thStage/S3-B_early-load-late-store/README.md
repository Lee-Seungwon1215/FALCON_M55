# Stage 4 S3-B: early input load / late output store

이 폴더는 [`../../ntt_opt`](../../ntt_opt)의 1~3단계 통합 코드를 기준으로
**한 loop iteration 안에서만** 데이터 load/store 시점을 넓힌 독립 후보다.
twiddle/root load 위치(S3-A)와 iteration 간 software pipeline(S3-C)은
변경하지 않았다.

구현 범위는 다음과 같다.

- 512 forward `L3x512`의 첫 CT layer에서 비어 있던 `q7`을 사용해
  lower stream을 두 개씩 먼저 load하고, 독립 butterfly 두 개가 끝난 뒤
  두 결과를 store한다. load 주소 순서와 store 주소 순서는 각각
  `128,160,192,224`로 유지된다.
- forward 512의 `CT2`, `L3x512`, packed `CT2`, forward 1024의 `F2`,
  공통 final `L5_mve_stage3`에서 공개 loop-counter 갱신을 store burst
  앞으로 옮겼다.
- inverse 공통 `L0_mve_stage3`, 1024 `I2`, 512 packed `GS2`, `L3x512`,
  wide `GS2`에서도 같은 late-store 배치를 적용했다.
- arithmetic, layer fusion, root/twist table과 그 load 위치, loop bound,
  load 주소 순서, store 주소 순서 및 분기 조건은 바꾸지 않았다. 전체
  load/store interleaving만 S3-B 목적에 맞게 바뀌었다.

추가 이동을 제외한 구간도 명시한다.

- `CT2`, packed `CT2/GS2`, `F2/I2`, final `L5`와 inverse `L0`의 데이터
  벡터는 이미 iteration 시작에 모두 load되고 연산 종료 뒤 모두 store된다.
- 1024의 64-bit half tail은 각 middle group에서 한 번만 실행되므로 숨길
  다음 vector iteration이 없다.
- 512 forward CT3의 upper/lower 경계와 inverse GS3의 두 half 및 join은
  `q0-q7`이 live data와 reduction temporary로 가득 차 추가 preload 또는
  store 지연을 하면 spill이나 추가 명령이 필요하므로 제외했다.
- scalar fallback과 `logn<9` 경로는 변경하지 않았다.

### 보드 측정 결과

2026-09-13 NUCLEO-N657X0-Q에서 ITCM/DTCM, cache OFF, GNU Arm 15.2.1,
`-O3`, degree·operation별 10 batch, 각 batch에서 10회 warm-up 후 10회
측정했다. 값은 upper median cycle/call이다.

| degree | 연산 | stage 1~3 기준 | S3-B | 절약 cycle | 개선율 |
|---:|---|---:|---:|---:|---:|
| 512 | keygen | 51,722,695 | 51,722,311 | 384 | 0.000742% |
| 512 | sign | 17,150,930 | 17,150,545 | 385 | 0.002245% |
| 512 | verify | 323,738 | 323,674 | 64 | 0.019769% |
| 1024 | keygen | 260,391,745 | 260,391,042 | 703 | 0.000270% |
| 1024 | sign | 36,748,666 | 36,748,282 | 384 | 0.001045% |
| 1024 | verify | 626,546 | 626,482 | 64 | 0.010215% |

대응 batch 60개가 모두 기준보다 빨랐으므로 작은 이득이지만 반복
가능하다. 다만 6개 API 모두 S3-A보다 느려서 우선 선택하지 않고
조합 실험의 대조 후보로 유지한다.

### 검증 및 상수시간 구조 감사

- 기준과 candidate 모두 `.text` 10,500 B, 명령 2,725개
- mnemonic multiset 동일, memory 명령 377개, control 명령 86개로 동일
- push/pop, stack 조정, branch 수가 동일해 새 spill이나 분기는 없음
- Cortex-M55 standalone assemble 및 Zephyr 전체 link 성공
- 전체 build 메모리: FLASH 106,316/262,144 B, RAM 225,728/262,144 B
- Barrett 상수곱·forward oracle·inverse/oracle round-trip mismatch 0,
  최대 modular error 0
- board KAT digest 22개 일치, 서명검증·1-bit 변조 거부 PASS
- fault register 0, TCM ECC 실행 전후 `0x1300a`, stack 상한 9,624 B
- `mq_cm55.s` SHA-256: `354c0318f0c882c2685ee2546afda67f661f57b41c3193b8eb4cbde7df07f2be`
- source tree SHA-256: `3766c45984367e7bd75125ec4adae5a8313b0da6187be7abf3c6cb2c557a2e1c`
- `zephyr.elf` SHA-256: `ea9ac9d3e6bf2fca57233a8f776e84d1b0b99f1da9fe5e3398a845952e6ddb27`

- [S3-B full raw log](../results/s3b/runs/full-20260913T091429Z/raw.log)
- [S3-B validated manifest](../results/s3b/full_validated.json)
- [정적 감사 기록](../results/s3b/static_audit.json)
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

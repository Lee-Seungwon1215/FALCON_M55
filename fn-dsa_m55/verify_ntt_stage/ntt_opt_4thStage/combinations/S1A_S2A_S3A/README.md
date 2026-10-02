# FN-DSA (in C)
## Stage-4 combination: `S1A_S2A_S3A`

- `S1-A staggered` + `S2-A same-layer` + `S3-A twiddle preload`를 이 디렉터리의
  [`mq_cm55.s`](mq_cm55.s)에 직접 통합했다. 다른 후보의 어셈블리 파일을
  Makefile, include 또는 빌드 변수로 끌어오지 않는다.
- Cortex-M55/MVE 단독 조립과 NUCLEO-N657X0-Q 전체 펌웨어 링크를 통과했다.
- 2026-09-13 보드 pilot에서 512/1024 NTT·iNTT oracle 오차 0, 고정-seed
  digest 일치, 키생성·서명·검증, 변조 서명 거부를 모두 통과했다.
- secret-dependent branch/address는 추가하지 않았다. 이 평가는 소스와
  역어셈블 기반 정적 상수시간 감사이며 전력/EM TVLA는 포함하지 않는다.
- **2026-09-13 v2의 100회 full 측정과 사후 로그 검증을 완료했다.**
  [전체 비교](../RESULTS.md), [수정 내용](../REVISION.md),
  [full manifest](../results/S1A_S2A_S3A/full_validated.json).

이 조합의 upper median cycle/call:

| degree | keygen | sign | verify |
|---:|---:|---:|---:|
| 512 | 51,720,019 | 17,148,551 | 323,391 |
| 1024 | 260,378,986 | 36,742,726 | 625,698 |


## 복사해 온 1~3단계 기준 코드 기록 (위 조합의 결과 아님)

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

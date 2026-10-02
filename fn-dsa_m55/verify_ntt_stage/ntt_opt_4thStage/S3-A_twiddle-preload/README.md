# FN-DSA (in C)

## Stage 4 isolated candidate: S3-A twiddle preload

이 디렉터리는 `../../ntt_opt`의 stage 1~3 통합 코드를 기준으로 하는
**단독 S3-A 후보**다. 산술식과 레이어 병합은 그대로 두고, 같은 공개
iteration/group에서 이미 읽기 시작한 root/twist가 실제로 사용될 때까지
독립 명령을 사이에 배치한다.

- `MQ_LOAD_PAIR`의 35개 호출 지점에서 twist `LDRH` 직후에 독립적인
  공개 table-pointer 갱신을 먼저 수행한다. 따라서 dependent `ORR`까지
  한 명령의 간격이 생긴다.
- scalar inverse `L0`에서는 두 번째 twiddle을 같은 반복의 register-only
  repack 세 명령보다 먼저 읽는다.
- forward 적용 지점은 512 CT2(3), 512 GS3용 CT3(7), 512 packed CT2(6),
  1024 CT2(3)으로 총 19개다.
- inverse 적용 지점은 1024 GS2(3), 512 packed GS2(6), 512 GS3(7)으로
  총 16개다.
- 다음 반복 twiddle을 미리 읽는 software pipeline은 S3-C의 범위이므로
  사용하지 않았다. 입력 조기 load와 출력 지연 store도 S3-B와 분리했다.
  `MQ_LOAD_PAIR_OFF`는 함수당 한 번 실행되는 고정 setup이고 pointer-update
  간격도 없어 변경하지 않았다. MVE final-two-layer의 vector twiddle load는
  live vector-register 부족으로 입력/산술을 움직이지 않고는 앞당길 수 없어
  제외했다.

### 보드 측정 결과

2026-09-13 NUCLEO-N657X0-Q에서 ITCM/DTCM, cache OFF, GNU Arm 15.2.1,
최종 유효 옵션 `-O3`, degree·operation별 고정 입력 10 batch, 각 batch에서
10회 warm-up 후 10회 측정했다. 값은 upper median cycle/call이다.

| degree | 연산 | stage 1~3 기준 | S3-A | 절약 cycle | 개선율 |
|---:|---|---:|---:|---:|---:|
| 512 | keygen | 51,722,695 | 51,721,172 | 1,523 | 0.002945% |
| 512 | sign | 17,150,930 | 17,149,415 | 1,515 | 0.008833% |
| 512 | verify | 323,738 | 323,487 | 251 | 0.077532% |
| 1024 | keygen | 260,391,745 | 260,386,135 | 5,610 | 0.002154% |
| 1024 | sign | 36,748,666 | 36,745,607 | 3,059 | 0.008324% |
| 1024 | verify | 626,546 | 626,036 | 510 | 0.081399% |

동일 입력의 대응 batch 60개가 모두 기준보다 빨랐다. S3 세 후보 중
1024 keygen을 제외한 5개 API에서 가장 빠르며 코드 크기도 증가하지 않아
**일반 목적의 S3 우선 후보로 선택한다.**

### 검증 및 상수시간 구조 감사

- GNU Arm 15.2.1 Cortex-M55 assembler와 전체 Zephyr 빌드 성공
- 기준과 `mq_cm55.s` object `.text` 크기 동일: 10,500 B
- 기준과 mnemonic multiset 동일: 2,725 instructions
- memory instruction 377개와 control instruction 86개가 동일하며,
  memory/control access sequence도 동일
- 다른 C/H/S 파일은 `../../ntt_opt`와 byte-identical
- full ELF 메모리 사용은 기준과 동일: FLASH 106,316 B, RAM 225,728 B
- 새 branch, spill, table, loop-bound 변경 없음
- Barrett 상수곱 2,048쌍, 512/1024 forward oracle, inverse 및 oracle
  round-trip mismatch 0, 최대 modular error 0
- board KAT digest 22개 일치, 서명검증·1-bit 변조 거부 PASS
- `CFSR=HFSR=DFSR=AFSR=0`, TCM ECC 실행 전후 `0x1300a`
- main stack 사용 상한 9,624 B

상수시간 감사는 소스와 역어셈블의 제어 흐름·주소·명령 수 대조이며,
전력/EM TVLA는 포함하지 않는다.

- [S3-A full raw log](../results/s3a/runs/full-20260913T091151Z/raw.log)
- [S3-A validated manifest](../results/s3a/full_validated.json)
- [정적 감사 기록](../results/s3a/static_audit.json)
- [기준 full raw log](../../ntt_opt_3rdStage/results/ntt_opt/runs/full-20260913T063156Z/raw.log)

- `mq_cm55.s` SHA-256:
  `b7970786ec42a35c7174e43c7a115750afceba68e5fda9b25a18740d9b065bb7`
- source tree SHA-256:
  `6d13f0aab28ed598dd2f00408fb83e7e56f2396ccc5bca715e1c184dded7a829`
- build ELF SHA-256:
  `a04d82758a19210e520c3e9c76607bc5804b71d7d26e7290e5bc49d56e99e50b`

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

# FN-DSA (in C)

## Local Cortex-M55 stage-4 S2-A candidate

이 디렉터리는 [`../../ntt_opt`](../../ntt_opt)의 stage 1~3 기준 코드에서
**같은 NTT layer의 독립한 butterfly 두 개를 교차 배치한 후보**다.
산술식, 레이어 병합, twiddle table, 메모리 load/store 순서와 명령
수는 바꾸지 않았다.

기준 코드:

```text
butterfly A 완료 -> butterfly B 완료
```

S2-A same-layer 코드:

```text
sum A/B -> sum reduction A/B -> difference A/B -> difference reduction A/B
```

- 수정 파일: `mq_cm55.s` 한 개
- 적용 범위: forward CT 12쌍, inverse GS 10쌍, 총 22쌍
- 적용 경로: 512 CT2·3-layer·packed, 1024 F2·I2, forward L5,
  inverse 512 GS2·3-layer·wide
- inverse L0는 root/twiddle이 `q5`~`q7`을 점유해 두 butterfly를 동시에
  독립 register chain으로 유지할 수 없었다. load 이동이 필요하므로 S3
  memory-scheduling 실험과의 분리를 위해 적용하지 않았다.
- 새 분기, 메모리 접근, lookup table, stack spill 없음

### 보드 측정 결과

2026-09-13 NUCLEO-N657X0-Q에서 ITCM/DTCM, cache OFF, GNU Arm 15.2.1,
최종 유효 옵션 `-O3`, degree·operation별 고정 입력 10 batch, 각 batch에서
10회 warm-up 후 10회 측정했다. 값은 upper median cycle/call이다.

| degree | 연산 | stage 1~3 기준 | S2-A | 차이(기준-S2-A) | 판정 |
|---:|---|---:|---:|---:|---|
| 512 | keygen | 51,722,695 | 51,722,694 | +1 | 동일 |
| 512 | sign | 17,150,930 | 17,150,930 | 0 | 동일 |
| 512 | verify | 323,738 | 323,738 | 0 | 동일 |
| 1024 | keygen | 260,391,745 | 260,391,745 | 0 | 동일 |
| 1024 | sign | 36,748,666 | 36,748,666 | 0 | 동일 |
| 1024 | verify | 626,546 | 626,546 | 0 | 동일 |

512 keygen의 1 cycle 차이는 0.000001933%이며 측정 분해능 안의
동일한 결과로 판정한다. 대응하는 60개 batch를 직접 비교하면 S2-A가
빠른 경우 10개, 동일 41개, 느린 경우 9개였고 평균은 S2-A가
0.083 cycle 느렸다. 따라서 **S2-A 단독 스케줄은 채택 이득이 없다.**
현재 최선 단독 후보 S1-B는 S2-A보다 API에 따라 0.004453%~0.130557%
빠르다.

### 검증 및 상수시간 구조 감사

- Barrett 전용 MVE 상수곱 2,048쌍 mismatch 0
- 512/1024 forward oracle mismatch 0, inverse round-trip mismatch 0,
  최대 modular error 0
- 고정-seed board KAT digest 22개가 host 정답과 일치
- 키생성·서명·검증 및 1-bit 변조 서명 거부 PASS
- `CFSR=HFSR=AFSR=0`, TCM ECC 실행 전후 `0x1300a`로 활성
- 기준/S2-A `mq_cm55.s` object 크기: 모두 10,500 B
- 두 구현의 명령 수 동일: control flow 86, memory 377, `VADD` 318,
  `VSUB` 142, `VCMP` 232, `VQRDMULH` 57, `VMUL` 117, `VMLA` 57,
  vector push/pop 4
- 전체 ELF 크기 동일; main stack 사용 상한 9,624 B

상수시간 감사는 소스와 역어셈블의 제어 흐름·주소·명령 수 대조이며,
전력/EM TVLA는 포함하지 않는다.

- [S2-A full raw log](../results/s2a/runs/full-20260913T082009Z/raw.log)
- [S2-A validated manifest](../results/s2a/full_validated.json)
- [정적 감사 기록](../results/s2a/static_audit.json)
- [기준 full raw log](../../ntt_opt_3rdStage/results/ntt_opt/runs/full-20260913T063156Z/raw.log)
- `mq_cm55.s` SHA-256: `ec20b22a2f0d0748842cbb79fd5fd3e429a8bc3fddfc1ad6d624711ca8ce07e8`
- source tree SHA-256: `87125d02874719eb649a0c3d6ec95625f2e808ea3cb2525bde1d6fca0ba684c0`
- full ELF SHA-256: `be8a0ebc48692a54c9beeefe65abf431360d9f386da4fbeb8feb1a22e355face`

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

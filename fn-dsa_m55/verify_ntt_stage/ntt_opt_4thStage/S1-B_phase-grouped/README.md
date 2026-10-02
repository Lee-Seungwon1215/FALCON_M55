# FN-DSA (in C)

## Local Cortex-M55 stage-4 S1-B candidate

이 디렉터리는 [`../../ntt_opt`](../../ntt_opt)의 stage 1~3 기준 코드에서
**서로 독립인 두 Barrett 곱셈을 명령 종류별 phase로 묶은 후보**다.
산술식, 레이어 병합, twiddle table 및 load/store 순서는 바꾸지 않았다.

기준 코드:

```text
QH A -> MUL A -> MLA A -> QH B -> MUL B -> MLA B
```

S1-B phase-grouped 코드:

```text
QH A -> QH B -> MUL A -> MUL B -> MLA A -> MLA B
```

- 수정 파일: `mq_cm55.s` 한 개
- 적용 범위: forward NTT 9쌍과 inverse NTT 1쌍, 총 10쌍/20개 곱셈
- 적용 위치: 512 CT2·3-layer·packed 경로, 1024 F2·L5 경로,
  inverse L0 경로
- 서로 다른 twiddle을 쓰는 구간은 기존 root/twist 생성 명령을 QH phase와
  MUL phase로 분할하여 추가 명령 없이 배치
- butterfly를 사이에 둔 곱셈과 inverse GS 내부 곱셈은 S2와의 실험 분리를
  위해 보존
- 새 분기, 메모리 접근, lookup table, stack spill 없음

### 보드 측정 결과

2026-09-13 NUCLEO-N657X0-Q에서 ITCM/DTCM, cache OFF, GNU Arm 15.2.1,
최종 유효 옵션 `-O3`, degree·operation별 고정 입력 10 batch, 각 batch에서
10회 warm-up 후 10회 측정했다. 값은 upper median cycle/call이다.

| degree | 연산 | stage 1~3 기준 | S1-A | S1-B | 기준 대비 개선율 | S1-A 대비 개선율 |
|---:|---|---:|---:|---:|---:|---:|
| 512 | keygen | 51,722,695 | 51,721,543 | 51,720,391 | 0.004455% | 0.002227% |
| 512 | sign | 17,150,930 | 17,150,065 | 17,149,202 | 0.010075% | 0.005032% |
| 512 | verify | 323,738 | 323,642 | 323,546 | 0.059307% | 0.029662% |
| 1024 | keygen | 260,391,745 | 260,384,705 | 260,374,037 | 0.006801% | 0.004097% |
| 1024 | sign | 36,748,666 | 36,745,786 | 36,741,465 | 0.019595% | 0.011759% |
| 1024 | verify | 626,546 | 626,226 | 625,728 | 0.130557% | 0.079524% |

기준과 대응하는 60개 입력/연산 배치 모두에서 S1-B cycle이 감소했다.
S1-B가 S1-A보다 전 항목에서 빨랐지만 전체 API 개선폭은 작으므로, 최종
채택은 이후 S2/S3 및 조합 후보와 같은 조건으로 비교한 뒤 결정한다.

### 검증 및 상수시간 구조 감사

- Barrett 전용 MVE 상수곱 2,048쌍 mismatch 0
- 512/1024 forward oracle mismatch 0, inverse round-trip mismatch 0,
  최대 modular error 0
- 고정-seed board KAT digest 22개가 host 정답과 일치
- 키생성·서명·검증 및 1-bit 변조 서명 거부 PASS
- `CFSR=HFSR=AFSR=0`, TCM ECC 실행 전후 활성
- 기준/S1-A/S1-B `mq_cm55.s` object 크기: 모두 10,500 B
- 세 구현의 명령 수 동일: control flow 86, memory 377,
  `VQRDMULH` 57, `VMUL` 117, `VMLA` 57, vector push/pop 4
- main stack 사용 상한: 모두 9,624 B

상수시간 감사는 소스와 역어셈블의 제어 흐름·주소·명령 수 대조이며,
전력/EM TVLA는 포함하지 않는다.

- [S1-B full raw log](../results/s1b/runs/full-20260913T080417Z/raw.log)
- [S1-B validated manifest](../results/s1b/full_validated.json)
- [정적 감사 기록](../results/s1b/static_audit.json)
- [기준 full raw log](../../ntt_opt_3rdStage/results/ntt_opt/runs/full-20260913T063156Z/raw.log)
- `mq_cm55.s` SHA-256: `38a0502db847819ed2a85cb870c39f36c6ab7e06bc38509695c52441f7c3f655`
- full ELF SHA-256: `3ce0bf31b5d87a63a1276ec335e58deb9d0f5d51706a20dd559c32295755aa3e`

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

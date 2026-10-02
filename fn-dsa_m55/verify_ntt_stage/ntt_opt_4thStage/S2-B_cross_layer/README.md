# FN-DSA (in C)

## Local Cortex-M55 stage-4 S2-B candidate

이 디렉터리는 [`../../ntt_opt`](../../ntt_opt)의 stage 1~3 기준 코드에서
**인접한 NTT layer의 종속 연산을 교차 배치한 후보**다. 산술식, layer
병합, twiddle table, load/store 순서와 명령 수는 바꾸지 않았다.

forward에서는 현재 layer의 butterfly 출력이 만들어지는 즉시 그 출력에
대한 다음 layer의 twiddle 곱을 시작한다. inverse에서는 child GS의 왼쪽
출력이 준비되면 오른쪽 곱셈의 최종 보정과 독립인 parent GS의 첫 `VADD`를
먼저 발행한다. 모든 진짜 데이터 의존성은 유지한다.

```text
기준: layer L 완료 -> 다음 layer L+1 시작
S2-B: L 출력 준비 -> 가능한 L+1 곱/합 시작 -> L의 독립 tail 완료
```

- 수정 파일: `mq_cm55.s` 한 개
- 적용 지점: forward 7곳, inverse 5곳, 총 12곳
- 적용 경로: 512 initial CT2·3-layer·packed 및 1024 F2,
  512 packed·3-layer·wide inverse 및 1024 I2
- twiddle load 이동, 새 분기, 새 메모리 접근, stack spill 없음
- S1/S3 후보를 섞지 않은 S2-B 단독 후보

### 보드 측정 결과

2026-09-13 NUCLEO-N657X0-Q에서 ITCM/DTCM, cache OFF, GNU Arm 15.2.1,
최종 유효 옵션 `-O3`, degree·operation별 고정 입력 10 batch, 각 batch에서
10회 warm-up 후 10회 측정했다. 값은 upper median cycle/call이다.

| degree | 연산 | stage 1~3 기준 | S2-B | 차이(기준-S2-B) | 개선율 |
|---:|---|---:|---:|---:|---:|
| 512 | keygen | 51,722,695 | 51,722,695 | 0 | 0% |
| 512 | sign | 17,150,930 | 17,150,642 | +288 | 0.001679% |
| 512 | verify | 323,738 | 323,642 | +96 | 0.029654% |
| 1024 | keygen | 260,391,745 | 260,391,746 | -1 | -0.000000384% |
| 1024 | sign | 36,748,666 | 36,747,706 | +960 | 0.002612% |
| 1024 | verify | 626,546 | 626,226 | +320 | 0.051074% |

동일 입력의 대응 batch를 직접 비교하면 sign과 verify의 40개 batch는
전부 S2-B가 빨랐다. keygen은 512에서 평균 0.3 cycle, 1024에서 평균
0.4 cycle 느린 수준으로 측정 분해능 안에서 동일하다. 따라서 S2-B는
**서명·검증에서 반복 가능한 단독 이득이 있지만, 6개 API 전체에서는
S1-B가 더 빠르다.** S2-B는 이후 조합 실험 대상으로 유지한다.

### 검증 및 상수시간 구조 감사

- Barrett 전용 MVE 상수곱 2,048쌍 mismatch 0
- 512/1024 forward oracle mismatch 0, inverse 및 oracle round-trip
  mismatch 0, 최대 modular error 0
- 고정-seed board KAT digest 22개가 host 정답과 일치
- 키생성·서명·검증 및 1-bit 변조 서명 거부 PASS
- `CFSR=HFSR=DFSR=AFSR=0`, TCM ECC 실행 전후 `0x1300a`
- 기준/S2-B `mq_cm55.s` object 크기: 모두 10,500 B
- 총 2,725개 명령의 mnemonic multiset 동일; control-flow 86개와
  memory-access 377개의 순서 동일
- 공통 명령 수: `VADD` 318, `VSUB` 142, `VCMP` 232,
  `VQRDMULH` 57, `VMUL` 117, `VMLA` 57, vector push/pop 4
- 전체 ELF 메모리 점유는 기준과 동일; main stack 사용 상한 9,624 B

상수시간 감사는 소스와 역어셈블의 제어 흐름·주소·명령 수 대조이며,
전력/EM TVLA는 포함하지 않는다.

- [S2-B full raw log](../results/s2b/runs/full-20260913T085019Z/raw.log)
- [S2-B validated manifest](../results/s2b/full_validated.json)
- [정적 감사 기록](../results/s2b/static_audit.json)
- [기준 full raw log](../../ntt_opt_3rdStage/results/ntt_opt/runs/full-20260913T063156Z/raw.log)
- `mq_cm55.s` SHA-256: `0bd22d65a90bcfc2d1ebe046e7bf4f5c17d79631ce8dfd1ceb2f6293fb3bf815`
- source tree SHA-256: `6c5340fea271477e76706a3c812c165826ed1d1795b308fb1cf5ed28c4462157`
- full ELF SHA-256: `541aade9cc70c26ea05598fd0b44b56268722fcd48cea7424453189c61390413`

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

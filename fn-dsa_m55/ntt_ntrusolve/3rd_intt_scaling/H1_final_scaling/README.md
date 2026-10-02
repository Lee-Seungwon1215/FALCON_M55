# FN-DSA (in C)

## Stage 3 — H1_final_scaling (구현·M55 측정 완료)

이 폴더는 최신 [L2_two_layer](../../2nd_layer_opt/L2_two_layer/)를 복사한
H1 실험용 소스다. **iNTT의 단계별 절반 보정을 제거하고 마지막 레이어에 최종 보정을 통합했다.**
2026-09-15 M55 보드 산술 검사·KAT/digest·서명검증·변조 거부 및 각 API 100회 측정을 통과했다.
최상위 C/H/S 31개 중 [H0_stagewise_half](../H0_stagewise_half/)와 다른 파일은
`kgen_mp31_cm55.s` 하나다. H0 및 L2 원본에는 반영하지 않았다.

현재 포함된 구현:

- M1_improve의 정확한 rounding Montgomery, MVE `4×32-bit`, signed GS difference.
- 2-layer 병합 및 forward NTT `logn=4/6` 전용 제어 경로.
- iNTT 중간 레이어는 보정 없이 계산하고 마지막 레이어에 `n^-1 mod p` 보정 통합.
- 원본 half-scaled `igm` 상수는 유지하고, 필요한 root만 레지스터에서 복원.
- `logn<4` C fallback 및 기존 q=12289 `mq_cm55.s` 구현.

H1 변경은 `kgen_mp31_cm55.s`의 iNTT에 직접 작성했다.
별도의 전체 배열 scaling pass 없이 마지막 버터플라이에서 계산과 저장을 마친다.
원본 `igm` 배열, forward NTT, Montgomery 내부 `VHADD`, C fallback은 유지한다.
별도 후보의 어셈블리 include/링크나 후보 선택 매크로로 구현하지 않는다.

측정 도구는 [profiling/README.md](profiling/README.md)를 따른다.
L2와 같은 공용 보드 harness를 재사용하되 **암호 C/어셈블리는 전부 이 폴더에서**
빌드한다. 빌드 옵션은 기존 MVE 경로 활성화와 산술 self-test 구분에만 사용하며,
H0/H1 보정 방식을 선택하지 않는다.

- [H1 결과](result.md): 주소를 맞춘 H0 대비 iNTT 5.36~13.39%, 키생성 512/1024는 0.2913%/0.1864% 개선.
- [구현 원리·범위·상수시간 해석](IMPLEMENTATION.md): 정적 구조 검토이며 누출 검사/형식적 증명은 아님.
- [최신 L2 결과 — 역사적 비교 자료](../../2nd_layer_opt/L2_two_layer/result.md)
- [L2 작은 크기 최적화 기록](../../2nd_layer_opt/SMALL_LOGN_RESULT.md)

아래 내용은 원 업스트림 README를 보존한 것이며, 아래의 업스트림 설명/날짜를
H1 구현 완료나 보드 검증 상태로 해석하면 안 된다.

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

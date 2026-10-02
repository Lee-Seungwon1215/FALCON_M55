# Signing FFT: hand-written ASM experiments

Date: 2026-09-28. Production scope: `fpoly_FFT()` and `fpoly_iFFT()` only.
No SLOTHY, FP32 representation, fused FMA, or arithmetic reassociation.

The frozen C native-FP64 implementation is in `native_c_baseline.tar.gz`.
The kernel test compiles its original arithmetic into `native_c.c`, sharing
the unchanged GM bit table. The original integer-emulated implementation
is separately extracted verbatim from `Final_code/Before_slothy` as an oracle.
Only test symbol names/table visibility are changed; no numerical code changes.

## Sequential experiments

Values are cycles/call, upper median of 100 samples, including call,
loads/stores and iFFT normalization. Each row was physically written into
the production `.s`, compiled and measured; no runtime candidate selection.
All rows passed 3,840 original-vs-ASM transforms (logn=1..10), and the
same 3,840 cases also checked the frozen C native implementation.

| Candidate | FFT 512 | FFT 1024 | iFFT 512 | iFFT 1024 | Kernel log timestamp |
|---|---:|---:|---:|---:|---|
| Frozen native C, measured alongside every row | 190,425 | 427,504 | 200,914 | 448,998 | same ELF as candidate |
| A0: direct ASM, high-word-only normalization pass | 195,177 | 438,386 | 200,073 | 447,893 | 20260928T081848Z |
| A1: two independent butterflies interleaved | 192,391 | 431,761 | 199,191 | 445,602 | 20260928T082027Z |
| A1b: non-fused VMLA/VMLS form | 192,391 | 431,761 | 199,191 | 445,602 | 20260928T082158Z |
| A2: dedicated singleton-distance boundary layer | 190,736 | 428,443 | 197,529 | 442,276 | 20260928T082314Z |
| A3: register-resident final/initial two layers | 188,750 | 424,602 | 195,026 | 437,277 | 20260928T082456Z |
| A4: iFFT exponent correction combined with stores | 188,750 | 424,602 | 192,600 | 432,294 | 20260928T082654Z |
| **A5: register-resident pairs across all layers** | **187,178** | **421,686** | **191,249** | **429,621** | **20260928T082942Z** |

Logs: `results/candidate_kernel/<timestamp>/raw.log`.
Each directory preserves the actual source in `production_sources.tar.gz`,
ELF, disassembly, compiler commands and SHA256 manifest. Rejected versions
are retained there, not as conditional paths in production.

## Selected A5 structure

- One binary64 D register per real or imaginary scalar; unchanged in-place
  split real/imaginary array layout and existing `fpr` bit representation.
- Four complex coefficients (8 D registers), three complex twiddles
  (6 D registers), and two arithmetic temporaries fit in d0..d15.
- Two radix-2 layers keep their intermediate values in registers. No
  coefficient spills in the hot loops. Twiddles are loaded once per group.
- 512: 8 complex-FFT layers grouped 2+2+2+2. 1024: 9 layers grouped
  2+2+2+2+1. The remaining single layer has a dedicated implementation.
- iFFT corrects the exponent at final stores using exactly the original
  `fpr_div2e` bit rule, including signed zero. This is not a new double
  hi/lo numerical representation. A small logn=2 path retains a short pass.
- Preserve r4..r11 and d8..d15. Fixed stack frame 112 bytes for logn>1,
  no nested calls. logn=1 returns without changing the input.
- All loop decisions/addresses depend only on public logn and indices.

The extra gain beyond already-native FP64 is modest: this does not reduce
the mathematical number of FP64 products/sums. Speed comes from less memory
traffic, repeated loop setup, and an extra normalization traversal.

## Validation boundaries

`abi_probe.s` additionally tests preservation of all callee-saved core/FP
registers in both directions for logn=1..10 (20 calls).
The timing screen uses eight input classes, 100 calls/class, four size/direction
combinations. It is not a formal constant-time or power/EM proof.
Final whole-signature and KAT results are in `../result.md` and `summary.json`.

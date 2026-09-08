# Falcon-512 PQClean profile on NUCLEO-N657X0-Q

Measured on 2026-09-08 with the instrumented PQClean clean implementation.
Each table is an exclusive partition of its public API operation; the raw
category counters sum exactly to the operation total.  Displayed percentages
can differ from 100% by the final decimal-place rounding.

## Configuration

- Target: NUCLEO-N657X0-Q, Cortex-M55 r1p1, secure development mode
- CPU clock reported by firmware: 600,000,000 Hz
- I-cache and D-cache: enabled
- Timer: DWT CYCCNT with 64-bit wrap extension
- Falcon source: PQClean commit `0586a824fc0d49df0b6b6e9179d8d15d06d0974f`
- STM32 support: STM32CubeN6 commit `80a3a665fccaf9a429343a7ab96a97c1b8a6467a`
- Compiler: Arm GNU Toolchain 15.3.Rel1, GCC 15.3.1
- Flags: `-O3 -mcpu=cortex-m55 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard -fno-tree-vectorize`
- Samples: keygen 10, sign 100, verify 100 after one discarded warm-up
- RNG: deterministic benchmark-only generator; not suitable for production
- Completion state: `0x600d0000`; error: `0`; checksum: `0x5b`

## Key generation

Total: 2,100,796,382 cycles / 10 calls = 210,079,638 cycles per call
(about 350.133 ms at 600 MHz).

| Exclusive category | Raw cycles | Cycles/call | Share |
|---|---:|---:|---:|
| Other/API glue | 6,959 | 696 | 0.0003% |
| RNG + seed SHAKE | 38,435 | 3,844 | 0.0018% |
| Key/signature codec | 573,956 | 57,396 | 0.0273% |
| FFT + iFFT (`fpr` emulation) | 632,080,542 | 63,208,054 | 30.0877% |
| q=12289 NTT + iNTT | 2,858,029 | 285,803 | 0.1360% |
| 31-bit RNS NTT + iNTT | 137,240,052 | 13,724,005 | 6.5328% |
| Keygen screening/other | 490,595 | 49,060 | 0.0234% |
| Key completion/preparation | 1,948,301 | 194,830 | 0.0927% |
| NTRU solver (excluding separately listed work) | 616,413,389 | 61,641,339 | 29.3419% |
| CRT reconstruction | 114,796,939 | 11,479,694 | 5.4644% |
| Gaussian0 sampler | 531,549,549 | 53,154,955 | 25.3023% |
| Norm/rejection check | 62,799,636 | 6,279,964 | 2.9893% |
| **Total** | **2,100,796,382** | **210,079,638** | **100%** |

## Signing

Total: 5,821,162,906 cycles / 100 calls = 58,211,629 cycles per call
(about 97.019 ms at 600 MHz).

| Exclusive category | Raw cycles | Cycles/call | Share |
|---|---:|---:|---:|
| Other/API glue | 109,403 | 1,094 | 0.0019% |
| RNG + seed SHAKE | 367,182 | 3,672 | 0.0063% |
| Key/signature codec | 6,675,928 | 66,759 | 0.1147% |
| Message hash-to-point | 49,654,133 | 496,541 | 0.8530% |
| FFT + iFFT (`fpr` emulation) | 1,996,638,133 | 19,966,381 | 34.2996% |
| q=12289 NTT + iNTT | 35,468,465 | 354,685 | 0.6093% |
| Key completion/preparation | 21,832,913 | 218,329 | 0.3751% |
| LDL tree + ffSampling plumbing | 2,689,222,339 | 26,892,223 | 46.1973% |
| Sampler arithmetic/PRNG | 280,706,203 | 2,807,062 | 4.8222% |
| Gaussian0 sampler | 124,500,188 | 1,245,002 | 2.1388% |
| BerExp rejection test | 215,799,389 | 2,157,994 | 3.7072% |
| Norm/rejection check | 431,933 | 4,319 | 0.0074% |
| Sign core (excluding separately listed work) | 399,756,697 | 3,997,567 | 6.8673% |
| **Total** | **5,821,162,906** | **58,211,629** | **100%** |

## Verification

Total: 84,281,096 cycles / 100 calls = 842,811 cycles per call
(about 1.405 ms at 600 MHz).

| Exclusive category | Raw cycles | Cycles/call | Share |
|---|---:|---:|---:|
| Other/API glue | 48,699 | 487 | 0.0578% |
| Key/signature codec | 3,245,673 | 32,457 | 3.8510% |
| Message hash-to-point | 49,675,335 | 496,753 | 58.9401% |
| q=12289 NTT + iNTT | 26,841,361 | 268,414 | 31.8474% |
| Key completion/preparation | 1,043,503 | 10,435 | 1.2381% |
| Norm/rejection check | 523,202 | 5,232 | 0.6208% |
| Verify core (excluding separately listed work) | 2,903,323 | 29,033 | 3.4448% |
| **Total** | **84,281,096** | **842,811** | **100%** |

## Interpretation

PQClean's clean Falcon stores `fpr` as a 64-bit integer representation and
implements binary64 operations in software.  Therefore the hard-float build
does not by itself move the FFT or tree arithmetic onto the M55 FPU.  The main
native-FPU opportunity in signing is the combined FFT/iFFT and exclusive tree
path (80.50%); the main MVE-oriented verification opportunities are
hash-to-point and q-NTT (90.79%).

Instrumentation transitions are included in the measured totals.  Use a
separate uninstrumented build when reporting final end-to-end performance.

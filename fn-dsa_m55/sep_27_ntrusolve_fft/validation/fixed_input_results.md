# A7: exact Q32 FFT input conversion

This is `poly_big_to_fixed` in the NTRU intermediate FFT input boundary.
It is NOT an FP32/FP64 FFT replacement, a different Babai iteration policy,
or an NTT/CRT/Bezout optimization. The surrounding intermediate function
remains byte-identical to the frozen ntt_opt source.

## Implementation and equivalence argument

- `A_tw_bridge/kgen_poly.c` retains the original DIVREM31 and zero-length
  handling, then calls the local `fndsa_fixed_input_mve` assembly function.
- `A_tw_bridge/kgen_fft_cm55.s` scans every limb in public order. Four lanes
  perform the original three-word mask selection, sign extension and shifts.
  Each lane represents one coefficient, NOT the real and imaginary parts of
  a complex number. There is no FP rounding or approximation in this helper.
- The original 24-bit limb-index masking and wraparound sch=-1 for sc=0
  are retained. The documented DIVREM31 scale domain is 0..63487. The
  tests do not invent an extension of that contract.
- VCTP/VPST loads limit n=1/2 reads to existing coefficients. Full blocks
  write four little-endian 64-bit Q32 values via the VST2 instruction pair;
  small sizes store exactly one or two low/high word pairs.
- Public len/n determine loops and branch paths. Input values/sc determine
  masks and shifts only. Linked disassembly is archived in `audit/`.
- ABI save area is 88 bytes, plus the current linked C wrapper's 24-byte
  frame. No new size-dependent scratch array or global table is allocated.

This is a lane-wise translation of the original source, not a claim that a
paper supplies this exact helper. Output equality follows locally from using
the same selected words and bit operations within the API domain; the
following finite tests are supporting evidence, not a formal machine proof.

## Raw-word comparison and memory checks

[Board log](results/A_tw_bridge/fixed_input/20260927T164349Z/raw.log),
[manifest](results/A_tw_bridge/fixed_input/20260927T164349Z/manifest.json).
220,672 function calls match the frozen original C function exactly.

- All scales 0..63487 for designated 3-limb arrays at n=1,2,4.
- n=1..1024, selected lengths 0..2047 subject to an 8192-word input buffer.
- Zero, all-one 31-bit limbs, sign patterns and random inputs; scale/length
  boundaries and four word-alignment offsets.
- len=0 passes a null source. Output guard words before/after the n values
  are included in the comparison. CFSR/HFSR/AFSR and TCM checks pass.
- Input ends were NOT placed behind an inaccessible MPU guard page. Absence
  of over-read is supported by the predicated-load/address review, not an
  exhaustive dynamic memory-safety proof. Overlapping restrict arguments
  are not valid API inputs and are not tested as supported aliasing.

## Paired boundary performance

Same ELF, inputs, compiler and placement policy; IRQ masked; two warmups;
32 timed calls. Times below are per-call minima including the wrapper and
measurement overhead. The original C oracle is noipa to prevent cloning or
constant propagation. This is NOT a whole-keygen speedup table.

| n | limbs | Original C cycles | A7 cycles | Original/A7 |
| ---: | ---: | ---: | ---: | ---: |
| 1 | 4 | 300 | 331 | 0.906× |
| 2 | 1 | 319 | 235 | 1.357× |
| 2 | 32 | 2,841 | 1,258 | 2.258× |
| 2 | 512 | 39,081 | 17,098 | 2.286× |
| 4 | 32 | 5,511 | 1,256 | 4.388× |
| 16 | 8 | 7,131 | 1,472 | 4.844× |
| 512 | 1 | 42,139 | 13,568 | 3.106× |
| 512 | 8 | 223,387 | 43,136 | 5.179× |
| 1024 | 1 | 84,123 | 27,008 | 3.115× |
| 1024 | 8 | 446,619 | 86,144 | 5.185× |

The n=1, len=4 regression is not hidden. The NTRU intermediate conversion
calls use logn>=1; n=1 is retained/tested as a supported boundary case, not
selected by a secret-dependent fast/slow fallback.

## Timing evidence

For public n=2, len=32, 32 input/scale classes ×20 trials of 128 calls:
A7 158738–158739 cycles, original C 361870–361871. Class minima agree;
occasional one-cycle differences occur. This is finite timing evidence, not
universal constant-time, power/EM safety, or constant-duration key generation.
The new linked helper and wrapper have only public len/n branches and no
operand-indexed memory access. Existing arithmetic requires its own review.

## Integration

Initial whole keygen run `20260927T164817Z`: 55,394,596.20 /238,879,145.04
cycles (512/1024, 100 common seeds each, retries included). This is 1.1326×
/1.0956× M55_ref, including the pre-existing NTT improvements. Relative to
ntt_opt, time decreases 2.7333% /1.7595%; relative to A6, 1.5318% /1.1850%.
The 1.7× objective is NOT met. Function addresses are not all pinned across
ELFs, so small end-to-end changes may include layout effects.

The complete current-source gates and repeated measurement are tracked in
[current_validation.json](current_validation.json) and [result.md](../result.md).
KAT does not prove every possible NTRU input has identical intermediate FFT
values; only this input boundary is intended to preserve every raw Q32 bit.

Repeat `20260927T165420Z`: 55,394,595.48 /238,879,145.49 cycles. The mean
differs from the first run by less than one cycle per key. Upstream KAT 300,
independent-seed comparison 300, signature/verify/tamper 90, kernel 640 and
the 16 divider classes are completed for this source. Kernel raw errors
remain recorded separately; they are not all zero.

## Instrumented attribution

A6 profile `20260927T151722Z` versus A7 `20260927T165209Z`, same 100 seeds
per degree. Cycles include profiling overhead; these must not be substituted
for uninstrumented whole-keygen timings.

| NTRU intermediate operation | A6 512 | A7 512 | A6 1024 | A7 1024 |
| --- | ---: | ---: | ---: | ---: |
| Input conversion | 1,530,543.17 | 667,002.90 | 4,798,895.89 | 1,929,010.03 |
| FFT | 1,533,426.85 | 1,533,350.47 | 4,105,779.57 | 4,105,746.65 |
| Reciprocal | 932,959.28 | 932,970.21 | 1,871,720.33 | 1,871,720.31 |
| Point product | 450,923.46 | 450,912.54 | 1,168,406.79 | 1,168,461.16 |
| iFFT | 1,632,381.13 | 1,632,413.89 | 4,412,966.97 | 4,413,032.47 |
| Integer update (outside FFT target) | 14,739,328.52 | 14,739,513.99 | 63,910,766.19 | 63,910,755.25 |

Input conversion decreases 56.42% /59.80%; the unchanged FFT, reciprocal,
point product, iFFT and integer-update costs remain nearly equal. Thus the
measured gain is attributable to the intended boundary, not silently credited
to a change in CRT/Bezout/NTT or integer-update algorithm. The complete target
scope is now 10.66996% /6.33265% of instrumented whole keygen, versus
12.00849% /7.42767% in A6. It is not a 56–60% improvement in whole keygen.

# A13 packed short Q32 FFT stages

Status: implementation, raw FFT checks, all nine main gates, both extra
input gates and same-ELF whole repeat pass. A12 is archived; its passes were
not inherited. B18 and external reference sources are unchanged. A13 is the
new best tested candidate, but the 1.7x whole target remains unmet.

## Change

Only own `kgen_fxp.c` and `kgen_fft_cm55.s` change. Public ht=1/2 stages
are packed across four different butterflies/roots instead of scalar tail
loops. Each original three-product Q32 complex formula and inverse stagewise
rounded half remains exact. No NTRU iteration, fixed/FP threshold, candidate
norm, point product, NTT, CRT, Bezout or signing changes. No SLOTHY, external
crypto link, backend flag or new mutable global workspace. This is an integer
MVE improvement in A's hybrid, not a native-FP64 rewrite.
[Derivation, lane mapping and references](../research/packed_tail_design.md).

## Isolated complete-kernel comparison

UTC 2026-09-27 [fixed_fft/212259Z](results/A_tw_bridge/fixed_fft/20260927T212259Z/manifest.json)
passes 5120 raw-word transform cases (logn1..10, both directions, full guards,
four offsets, edge/random words). Sixteen classes per transform have twenty
timed repetitions. All current minima/maxima are equal except a one-cycle
spread at iFFT1024. Valid manifest, zero faults, expected TCM/ECC state.

A12 archived run202020Z versus A13 run212259Z: same harness/inputs/compiler/
placement policy, not all addresses pinned. Each minimum includes complete
function call and timer overhead; IRQ masked. Original fixed and current
implementation coexist in each ELF. These timings are not whole-keygen gains.

| Kernel | n | A12 cycles | A13 cycles | time change | Original fixed / A13 |
| --- | ---: | ---: | ---: | ---: | ---: |
| FFT | 512 | 84205 | 69922 | -16.9622% | 1.8026x |
| FFT | 1024 | 179669 | 150983 | -15.9660% | 1.8587x |
| iFFT | 512 | 102365 | 89152 | -12.9077% | 1.6077x |
| iFFT | 1024 | 221030 | 194408 | -12.0445% | 1.6381x |

The same run's original fixed minima are 126038/280632 forward and
143331/318466 inverse. Actual intermediate NTRU solve uses degrees up to
256 for key512, up to512 for key1024; kernel1024 is coverage, not a claim it
executes in that intermediate path. Forward logn<5 and inverse logn<4 keep
the previous kernels. At affected smaller sizes the measured reduction
is 18.01--19.82% forward and 13.84--15.83% inverse (inverse n16:14.42%).

## Linked control flow and memory

New helper branches only on public ht, direction and four-butterfly count.
Gather/scatter offsets and root loads are public, never indexed by coefficient
bits. Carries/borrows/signs are arithmetic lane predicates, not secret branches.
The original scalar/generic fixed kernels remain the raw-bit oracle. Human
disassembly inspection and finite timing are not formal CT or leakage proofs.

Signature ELF end symbols: ITCM0x1001e97c (125308 bytes, +1044 from A12),
DTCM0x3003d668 (251496 bytes, +64 for immutable offset table), including
the common 64-KiB reserved stack. DTCM link headroom10648 bytes. New helper
frame360 bytes; C forward/inverse frames128/120 bytes. Local maximum
FFT-to-tail chains488/480 bytes versus previous FFT-to-long-helper384/416.
The new long-span chains are304/296 bytes. These are local/static checks,
not a full-keygen worst-case stack proof or a claim that stack use decreased.

## Whole measurement

First plain-keygen run [212510Z](results/A_tw_bridge/keygen/20260927T212510Z/manifest.json)
passes 200 keys/KAT/NTRU equations. Means53946545.18/235115934.69 cycles,
0.40905%/0.24764% less time than A12. M55_ref ratios1.16297x/1.11314x,
including prior NTT gains. Incremental time reductions versus ntt_opt are
5.27593%/3.30711%. This does not meet the 1.7x whole-keygen target.

Same-ELF [repeat/212904Z](results/A_tw_bridge/keygen/20260927T212904Z/manifest.json)
passes the same 200 keys/KAT/equations. Means are 53,946,545.42 /
235,115,934.24 cycles: only +0.24 /-0.45 cycles per key versus the first run.
Same 100 seeds per degree, three excluded warmups, all retries included,
IRQ allowed. Do not count the repeat as 200 additional independent inputs.

| Implementation | 512 mean cycles | 1024 mean cycles |
| --- | ---: | ---: |
| Original M55_ref | 62,738,244.34 | 261,716,429.63 |
| ntt_opt | 56,951,253.03 | 243,157,429.30 |
| A12 repeated | 54,168,121.70 | 235,699,616.15 |
| A13 repeated | 53,946,545.42 | 235,115,934.24 |

## Actual intermediate profile

A12 profile/202301Z and A13 profile/212647Z have exactly the same 218
operation/size keys and call counts. NTRU attempts/success and integer update
work are unchanged. The analysis uses the runner's normal removal of OpenOCD
Info lines before parsing SWO rows; raw logs remain intact. These instrumented
totals are not interchangeable with the uninstrumented whole means above.

| Interval | Key512 A12 -> A13 cycles/key | time change | Key1024 A12 -> A13 cycles/key | time change |
| --- | ---: | ---: | ---: | ---: |
| Intermediate FFT, all sizes | 1,320,054.88 -> 1,201,180.46 | -9.0053% | 3,427,533.35 -> 3,116,739.75 | -9.0676% |
| Intermediate iFFT, all sizes | 1,449,476.16 -> 1,367,001.08 | -5.6900% | 3,847,176.96 -> 3,630,896.47 | -5.6218% |
| NTRU solve total | 43,427,943.83 -> 43,226,703.79 | -0.4634% | 183,383,199.96 -> 182,856,245.76 | -0.2874% |

Input, reciprocal, point product, rounding and integer update intervals change
by less than 0.008%, with their code/counts unchanged. All-size integration
gains are smaller than large isolated-kernel gains: small fallback sizes,
call context and instrumentation must not be conflated with a large-kernel
microbenchmark. This is evidence for the changed FFT path, not a claim that
all timing-context causes have been proved.

## Source-matched gates

All dates UTC 2026-09-27. Every manifest is valid with zero faults and the
required TCM/ECC state. Current crypto source hashes are checked explicitly.

| Gate | Run | Result |
| --- | --- | --- |
| fixed_fft | [212406Z](results/A_tw_bridge/fixed_fft/20260927T212406Z/manifest.json) | 5120 original raw transform cases pass |
| fixed_input | [212411Z](results/A_tw_bridge/fixed_input/20260927T212411Z/manifest.json) | 220672 input cases pass |
| fixed_division | [212418Z](results/A_tw_bridge/fixed_division/20260927T212418Z/manifest.json) | 1018184 quotients and 320 inverse arrays pass |
| kat | [212425Z](results/A_tw_bridge/kat/20260927T212425Z/manifest.json) | 300 original KAT/equations pass |
| keygen | [212510Z](results/A_tw_bridge/keygen/20260927T212510Z/manifest.json) | 200 keys/KAT/equations pass |
| extra | [212554Z](results/A_tw_bridge/extra/20260927T212554Z/manifest.json) | 300 independent-seed KAT/equations pass |
| sigkat | [212637Z](results/A_tw_bridge/sigkat/20260927T212637Z/manifest.json) | 90 sign/verify/tamper cases pass |
| profile | [212647Z](results/A_tw_bridge/profile/20260927T212647Z/manifest.json) | 200 keys; interval totals consistent |
| kernel | [212732Z](results/A_tw_bridge/kernel/20260927T212732Z/manifest.json) | 640 bounded floating/bridge comparisons; 16 division classes pass |
| input_pair | [212846Z](results/A_tw_bridge/input_pair/20260927T212846Z/manifest.json) | 68608 cases pass |
| input_predicate | [212850Z](results/A_tw_bridge/input_predicate/20260927T212850Z/manifest.json) | 220672 cases pass |
| whole repeat | [212904Z](results/A_tw_bridge/keygen/20260927T212904Z/manifest.json) | same ELF, 200 keys/KAT/equations pass |

Finite tests do not establish universal input equivalence, formal CT,
physical side-channel security or worst-case stack safety. KAT, raw FFT
equality, floating bridge error checks and signature verification are
separate evidence, not interchangeable claims.

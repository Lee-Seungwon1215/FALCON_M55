# A9: exact MVE twiddle products and NTRU-local FFT

## Isolated multiplication and rejected staged variant

[Design and bounds](../research/twiddle_multiply_design.md).
The original Q32 complex formula uses three separately truncated products.
The new helper exploits a PUBLIC constant whose high word is -2,-1,0,1;
it does not assume small secret coefficients or omit carries.

[Isolated run 184341Z](results/A_tw_bridge/twiddle/20260927T184341Z/manifest.json)
passes 1,228,864 raw output comparisons, 49,056 table/input cases and 256
alias/guarded spans. At n=512, 16 calls per sample including dispatch and
memory traffic, scalar takes 123341 minimum cycles. New times by high-word
and low-word-top-bit class are 82717,84829,64285,66381,51949,54045,66301,68397:
1.4540x--2.3743x speedup. Each fixed public constant has identical class
minima; some maxima differ by one cycle. At n=4, some constants lose
(worst .9362x), so an isolated long-span result is not a universal speedup.

[First full transform run 184830Z](results/A_tw_bridge/twiddle_fft/20260927T184830Z/manifest.json)
tested batch 32/64/128 times vector cutoff 4/8/16. All 2880 array cases
matched the original exactly, but all meaningful transform sizes lost.
Even the best n=512 FFT/iFFT took 144019/149036 vs 125911/143331 baseline
cycles. Scalar combining, extra temporary traffic and helper calls consumed
the isolated multiplication gain. This staged C-surrounding version was
retained for comparison and NOT adopted.

[Same-ELF two-variant run 185259Z](results/A_tw_bridge/twiddle_fft/20260927T185259Z/manifest.json)
adds vectorized exact surrounding add/sub/half/complex combination.
Both old and new variants, nine configurations each, pass 5760 class/size
cases. For n=512/1024 the vector version selects batch128, forward cutoff4,
inverse cutoff8. Best trial transform speedups are 1.1880x/1.2380x for FFT,
1.1228x/1.1570x for iFFT. n<=64 still loses. These numbers belong to the
trial ELF, not the final production entry-point test below.

## Direct source implementation and exact kernel checks

A9 modifies only four crypto files from archived A8:

- kgen_fft_cm55.s: directly written exact twiddle/add/sub/half spans.
- kgen_fxp.c: own NTRU-local FFT loops reuse this file's original GM_TAB.
- kgen_inner.h: two NTRU-local declarations.
- kgen_ntru.c: replace only two FFT calls and one iFFT call in intermediate.

No test source or another candidate is linked into the keygen firmware.
Small logn<7 uses the unchanged fixed kernels. The candidate norm check
and original fixed-transform interfaces remain unchanged, checked by
check_scope.py; depth0 keeps its earlier FP path. This is exact integer-MVE
work within A's hybrid, NOT a claim that all FFTs now use native FP64.

[Production kernel run 185809Z](results/A_tw_bridge/fixed_fft/20260927T185809Z/manifest.json)
compares 5120 array/class/direction cases at n=2..1024, including full-width
raw extremes, pseudorandom words, four 8-byte-offset alignments and guard
slots. Every raw word matches. Each of the first 16 classes is additionally
timed 20 times with IRQ masked and identical input reset outside timing.
All kernel calls and their temporary-array work are inside timing.

| n | FFT original | FFT A9 | original/A9 | iFFT original | iFFT A9 | original/A9 |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 128 | 24451 | 22707 | 1.0768x | 27944 | 26620 | 1.0497x |
| 256 | 55924 | 49056 | 1.1400x | 63750 | 58312 | 1.0933x |
| 512 | 126039 | 105269 | 1.1973x | 143332 | 126525 | 1.1328x |
| 1024 | 280633 | 225014 | 1.2472x | 318466 | 272969 | 1.1667x |

Minima are reported; occasional maxima are +1 cycle. Small original paths
have a 0--6 cycle wrapper overhead in this test. Same placement policy is
used, but addresses are not pinned across earlier ELFs; slight changes in
baseline times between harnesses are not credited as arithmetic gains.
For keygen1024, intermediate reaches n=512; the new n=1024 kernel's ratio
is NOT automatically its integrated keygen gain. depth0 remains unchanged.

The signature-test image links at 116268 ITCM bytes (+3176 vs A8) and
250920 DTCM bytes (unchanged, including a reserved 64-KiB stack). Local
large-forward frame is 3320 bytes, inverse 3344; their deepest 96-byte
helper makes 3416/3440 bytes below the caller. This is local frame accounting,
not a full NTRU worst-case stack proof. Small wrappers tail-branch without
allocating these frames. No new global mutable polynomial workspace exists.

All source-matched A9 gates passed: original KAT300, independent-seed300,
signature/verification/tamper90, keygen200 and profile200 with exact NTRU
equation checks, fixed-input220672, fixed-division1018184 raw words plus320
arrays, and the previous FP bridge kernel tests640. The retained FP bridge
still has small raw differences and zero tested rounded differences; do not
extend the exact fixed-kernel result to every FP intermediate. The integrity
checker now requires the new fixed_fft gate as well (20 A/B gates total).

## Whole key generation and integration discrepancy

Common 100 seeds per degree, three excluded warmups, retries included;
unmodified shared hardware/compiler/placement policy. Function addresses
are not all pinned, and the profile build adds hooks/stack state.

| Implementation | 512 mean cycles | 1024 mean cycles |
| --- | ---: | ---: |
| Frozen M55_ref | 62738244.34 | 261716429.63 |
| Frozen ntt_opt | 56951253.03 | 243157429.30 |
| A8 previous best | 54765620.59 | 237610757.98 |
| A9 first, 185939Z | 54620522.07 | 237010994.74 |
| A9 same-ELF repeat, 190419Z | 54620522.69 | 237010994.05 |

A9 decreases whole time .2649%/.2524% versus A8. M55_ref/A9 is
1.1486x/1.1042x including earlier NTT gains; additional time decreases
against ntt_opt are 4.0925%/2.5278%. The target 1.7x is still NOT met.
Both timed-output checks pass; repeated means differ by +.62/-.69 cycles.

Profile A8 172818Z versus A9 190117Z has identical 104/114 call/success
counts, and keeps unrelated arithmetic essentially unchanged. However,
its gains are smaller than the separate kernel/whole-ELF result:

| Interval | A8 512 | A9 512 | A8 1024 | A9 1024 |
| --- | ---: | ---: | ---: | ---: |
| Intermediate FFT | 1533361.40 | 1504105.54 | 4105724.95 | 3942850.36 |
| Intermediate iFFT | 1632381.14 | 1632493.64 | 4412956.06 | 4368754.38 |
| FFT, logn>=7 only | 839562.83 | 809387.99 | 2642180.83 | 2476828.71 |
| iFFT, logn>=7 only | 864095.24 | 863306.36 | 2769281.27 | 2722588.24 |

For example, instrumented logn7 iFFT is about 1.53% slower, despite the
isolated kernel winning at n128. Small wrapper overhead is also visible.
The scope percentages are 9.62196%/5.75947%. The profile saving cannot
be substituted for the non-instrumented whole saving or claimed to explain
all of it. A dedicated array/stack alignment sweep was therefore completed
before assigning a root cause. Potential instruction placement effects
are hypotheses at this point, not a confirmed chip-level diagnosis.

### Array/stack alignment: completed negative finding

[Alignment run 190715Z](results/A_tw_bridge/fft_alignment/20260927T190715Z/manifest.json)
varies data and entry SP modulo 32 independently through 0/8/16/24 in the
same ELF. Every placement uses the same 16 input classes and 20 timed
repetitions; the common test shim is included in both times. All 2048
array/direction/placement cases match the original exactly, including guards.

| n | A9 FFT minimum range over placements | A9 iFFT minimum range |
| ---: | ---: | ---: |
| 128 | 22714–22746 | 26627–26633 |
| 256 | 49063–49127 | 58318–58325 |
| 512 | 105276–105404 | 126531–126539 |
| 1024 | 225021–225277 | 272975–272984 |

The forward spread is at most 0.15%, and inverse spread at most nine
cycles. This does NOT explain the thousands-of-cycles integration gap.
The tested data/stack alignment hypothesis is therefore not supported as
its main cause. This does not test all DTCM addresses or every calling context.
An isolated diagnostic also varied multiplier instruction addresses while
keeping arithmetic and data fixed; no production implementation was changed
for that diagnostic. Profile timing uses k_cycle_get_64 and IRQ is allowed,
while kernel timing uses DWT with IRQ masked. Those contexts also remain
distinct until directly tested; do not infer a confirmed silicon fault.

### Multiplier code placement: completed negative finding

[Placement run 191506Z](results/A_tw_bridge/fft_placement/20260927T191506Z/manifest.json)
uses eight test-only mechanical copies of the current multiplier at address
offsets 0/4/8/12/16/20/24/28 modulo 32, plus the production multiplier.
The linked copies have identical streams of 360 instruction halfwords;
the board verifies each requested address offset before timing. This is an
isolated diagnostic, not a link-time or build-option production selector.

All 2304 class/constant/size/position cases pass original fxr_mul raw-word
and guard comparisons. For every one of eight public twiddle classes and
both sizes n=4/128, minimum times are identical at all eight positions and
at the production entry point. Thus this multiplier's modulo-32 code
placement does NOT explain the profile discrepancy. It does not prove
that every other function address or arbitrary code layout is irrelevant.

### Timer, IRQ and wider absolute memory placements

[Context run 191836Z](results/A_tw_bridge/fft_context/20260927T191836Z/manifest.json)
passes 1152 original-bit/guard cases. Data starts at 0x30005640,
0x3000d640 and 0x30015640; test stack entries are 0x3002e2b0,
0x300312b0 and 0x300322b0. The same input is timed simultaneously with
DWT CYCCNT and k_cycle_get_64, with IRQ masked and allowed separately.

For each n/direction, minimum cycles are identical over these nine memory
placement combinations and both IRQ states. The outer k_cycle interval
is consistently 81 cycles longer than the enclosed DWT interval for BOTH
original and A9; no different clock scale or A9-specific timer inflation
is seen. Allowed IRQ adds occasional spikes (up to about 852 cycles in
the new-kernel rows), but the underlying minimum is unchanged. These
spikes alone cannot justify assigning the entire integration discrepancy
to interrupts. New-kernel minima are FFT 22715/49064/105277/225022 and
iFFT 26628/58319/126532/272976 at n128/256/512/1024.

This test rules out those tested placements and timer differences as the
main explanation, not every processor-state or calling-context effect.
The next diagnostic captured actual intermediate inputs in NTRU, repeated
the new kernel and compared the original kernel on the identical array.
Its extra work is NOT reported as production whole-keygen performance.

### Actual NTRU inputs and immediate replay

[Replay run 192254Z](results/A_tw_bridge/fft_replay/20260927T192254Z/manifest.json)
captures 16 real intermediate calls for each logn7/8/9 and direction (96
total), saves the input, times the new kernel twice on that exact input
and then the original kernel on the same caller array. IRQ is masked for
the paired diagnostic. Original/new/repeat outputs match in every case;
the resulting 200 full keys also pass original KAT and the NTRU equation.
The production sources are untouched; the three call replacements are in
a generated diagnostic copy and byte-recovery is asserted by the generator.

| n | FFT original / new | iFFT original / new |
| ---: | ---: | ---: |
| 128 | 24445 / 22702 | 27940 / 26615 |
| 256 | 55919 / 49051 | 63746 / 58306 |
| 512 | 126033 / 105264 | 143328 / 126519 |

These are minimum cycles. First/repeated new calls agree (one +1-cycle
maximum at n256 FFT), and match the earlier isolated scale. Actual NTRU
input values therefore do not reproduce the earlier profile slowdown in
this diagnostic. This finite result is not a universal constant-time proof.

### Both tests in one profile firmware: discrepancy remains

[Combined profile/probe run 192720Z](results/A_tw_bridge/profile_probe/20260927T192720Z/manifest.json)
adds the same isolated fixed_fft test before the existing instrumented
keygen benchmark. All 5120 raw kernel cases and 200 original-KAT/NTRU
equation checks pass. A representative comparison in THIS ELF is:

| n | FFT isolated original/new minima | iFFT isolated original/new minima | NTRU new FFT mean | NTRU new iFFT mean |
| ---: | ---: | ---: | ---: | ---: |
| 128 | 26221 / 26162 | 30367 / 31033 | 24757.96 | 28584.51 |
| 256 | 60030 / 57157 | 69390 / 68884 | 53905.06 | 63357.82 |
| 512 | 135392 / 123859 | 156203 / 151139 | 116543.48 | 138926.08 |

The last two columns use the degree1024 profile's per-call means, with
timer overhead and allowed IRQ; they are not interchangeable with minima.
The standalone kernel is now slower than in its separate ELF, and the
NTRU interval is not equal to that standalone measurement either. Adding
the probe keeps ntru_fft_large and GM_TAB addresses but moves other code;
this is NOT an all-address-pinned experiment. These findings do not establish
an algorithmic regression, an operand-dependent instruction, a silicon fault,
or one specific placement cause. Both code layout and caller context still
need more precise control. Do not substitute any of these diagnostic totals
for the verified A9 plain-keygen repeat 190419Z.

An external primary-source cross-check was also made against Arm's
[Cortex-M55 Software Optimization Guide, issue03](https://documentation-service.arm.com/static/63ac5ce1396e6135830ba9fe),
§3.5 (multiply/divide latency) and §4.1.3 (TCM bank conflicts). The table
does not support blaming this finding on variable-time UMULL/SMULL;
the documented same-bank rule uses address bits [3:2]. These general
descriptions are not a diagnosis of the observed discrepancy.

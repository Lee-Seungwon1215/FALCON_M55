# Constant-time evidence (not a proof)

## Discovered issue and correction

The A4 inherited FP64 division C code used arithmetic masks for exceptional
zero/sign handling. GCC 15.2.1 compiled some of these into operand-dependent
branches in `fndsa_vect_div_selfadj_fft_fp64`. The dedicated 16-class M55 test
found 94859–95243 cycles for 128 calls, depending on the input. A4 therefore
does not pass the no-new-secret-branch gate, despite matching KAT.

A5 adds a local opaque 32-bit mask helper before expanding a mask to two
words. It does NOT change numerical formulas, replace inputs or add dummy
delay. It prevents GCC from reintroducing those control-flow selections.
The inspected A5 linked function has no conditional B/CBZ branches; its loop
is a public-count low-overhead loop. VDIV still receives normalized normal
mantissas, with exact exponent reconstruction and masked special handling.

Post-fix operand timings and original-result comparisons are recorded in
`kernel_summary.md`. This does not prove every possible hardware latency,
all-input error bounds or absence of power/EM leakage.

A5 removed branches, but the 16 classes still differed by two cycles/call.
The generated zero-case mask selections used predicated instructions of
different forms. A6 therefore also implements zero/unsigned-range predicates
with explicit CLZ/shift and CMP/SBC/shift sequences, without IT selection.
It does not silently claim that removing branches alone solved timing.

A6 result: `kernel/20260927T151343Z`, all 16 classes measured exactly 99979
cycles per 128 calls in each of 20 trials. All 16 original-quotient comparisons
passed. The inspected function has only its public-count LE loop, no IT/Bcc/CBZ
selection. These finite results support the fix; they are not a universal proof.

## B evidence

B4 retains the original fixed-count integer divider. Its new exponent decoder
uses fixed ARM register shifts and masks, not variable-length loops or
operand-indexed tables. The 14 tested raw/multiply operand classes had equal
timings in the corrected arithmetic harness. DS FFT assembly branches depend
on public transform sizes/loop counts; finite kernel tests also report native
minimum and maximum over 32 inputs.

Whole key generation includes rejection sampling and is NOT constant-duration
across seeds. No whole-keygen constant-time claim is made.

## B5/B6 vector boundaries

The linked `fndsa_ds_encode4` and `fndsa_ds_round4` have no operand-dependent
branch, IT block or table address. The rounder uses VPSEL mask selection;
its wrapper branches only on public logn and block counts in the vector path.
The retained small-logn scalar path and older DS compatibility helpers still
require separate audit; this is not a whole-program no-conditional-instruction
claim.

The first encoder timing run showed a zero-class difference. Explicit warmup
and then a single noinline timed region eliminated that observation. The two
early runs have review.json annotations and are NOT used as constant-time
evidence. In the controlled run encoding/20260927T154222Z, all 20 class/order
cases ×20 trials measured 18,824 cycles per 128 four-lane MVE calls; the scalar
reference measured 28,810. This gives 1.5305x for this boundary benchmark.
The early difference was not sufficient evidence of hardware operand latency;
do not claim its low-level cause is proven simply because the corrected
harness no longer reproduces it.

Rounder run rounding/20260927T153700Z tested 32 classes ×20 trials, including
zero, subnormal, half-boundary, out-of-range and NaN/Inf patterns. Every new
128-call, eight-coefficient measurement was 74,762 cycles. Scalar minimum was
145,289 (occasional maximum +1). There was no change in integer outputs or
range-valid results across the 1,273,664 numerical test values.

These measurements and fixed instruction sequences are supporting evidence,
not a proof of universal timing behavior, whole-keygen constant duration,
all-input FFT equivalence or absence of power/EM leakage.

Final oracle-ABI check: rounding/20260927T154822Z disables inlining/cloning/
IPA on the frozen scalar public function. It repeats all 1,273,664 values
successfully; all 32 classes ×20 trials measure exactly 74,762 MVE cycles.
Scalar minimum is 150,410, with occasional maximum 150,411 (2.0119x by minima).
Encoder/20260927T154832Z likewise disables oracle IPA and
adds 1,024 explicit word-boundary values: all numerical tests pass, with all
20 classes ×20 trials still 28,810 scalar /18,824 MVE cycles.

## B7/B8 decoder and four-coefficient tiles

The new decoder's linked instruction sequence has no Bcc/CBZ/IT selection
or operand-indexed address. DSD_SCALE32 handles subnormal inputs with integer
exponent/mantissa operations and VPSEL, not a branch. The inverse/division
tile wrappers branch on public logn and fixed loop counts; the quotient
primitive remains the original integer implementation. Focused disassembly
and ELF hashes are archived in audit/B_continuous_ds.*. The retained scalar
small-size path is not included in a blanket no-predication claim.

In decoding/20260927T160856Z, all 24 operand classes ×20 trials of the new
decoder take 42,763 cycles per 128 four-lane calls, including subnormal and
large finite cases. Frozen scalar decode takes 61,195 in this run. The
surrounding-function timings use 32 repetitions but do NOT constitute a
new broad operand-class timing experiment on all inverse/division inputs.
No universal CT or power/EM claim follows from these finite tests.

The earlier decoder failed numerical equivalence because MVE scaling flushed
a subnormal operand in a dedicated test whereas scalar scaling preserved it.
That failed numerical run is invalid; it is not accepted merely because
its timing would be stable. See boundary_results.md for the correction.

## B9 input scan

The new selector's only conditional branch compares a public limb counter
to public len. All input addresses use the public stride; sch/scl are used
only as data in mask/shift instructions. The wrapper's vector path loops
over public polynomial size/real-imaginary halves. It does not skip zero
limbs or address a secret-selected limb. Retained small-size compiler paths
are not described as having no conditional instructions.

encoding/20260927T162610Z: 32 operand/scale classes ×20 trials, 128 calls
per trial, 8 limbs and 4 lanes. New selector range 48651–48652 cycles;
old C oracle 139403–139404. All class minima agree but occasional one-cycle
variation exists in both. This is finite supporting evidence, not exact
constant timing, a proven cause of the variation, or universal CT/security.
See selection_results.md for numerical coverage and the unhidden complete
conversion cost. The original DIVREM31 documented scale domain is enforced
by test inputs rather than inventing behavior for out-of-contract shifts.

## A7 fixed-input boundary

`poly_big_to_fixed` now calls the local integer-MVE `fndsa_fixed_input_mve`.
The linked wrapper branches only for public len=0. The helper loops over
public len/n and selects the n=1/2 store by public n. Secret input/scale
never determine addresses or branch direction; they affect word masks and
fixed instructions for variable shifts. No limb scan exits early.

fixed_input/20260927T164349Z: 32 classes ×20 trials, public n=2 and len=32,
128 calls per trial. New path 158738–158739 cycles; frozen C oracle
361870–361871. All class minima agree, with occasional +1 cycle in both.
Do not claim exact universal timing or a proved cause for the variation.
220,672 raw-result comparisons pass; see fixed_input_results.md. This new
boundary uses integer MVE, so it introduces no FP exceptional-value latency.

The current A7 kernel run `20260927T165324Z` also re-tests the unchanged A6
divider: all 16 class minima remain 99979 cycles per 128 calls; one maximum
is 99980. All 16 quotient comparisons pass. This run is not described as
having exactly identical timing for every sample. The finite FFT tests also
show a four-cycle min/max range; kernel_summary.md records it explicitly.

## B10 four-lane quotient

`fndsa_ds_div4` uses two public, fixed loop counters (31 and 32), one
straight-line intervening bit step, and masked lane-wise arithmetic. The
linked helper has no data-dependent branch or address. Input values only
change vector predicates and words; no precision/domain fallback is added.
In the isolated 170513Z test, new timing is 136969 cycles per 64 four-lane
calls across 32 classes ×20 trials; the original scalar path has class
minima 448589. Full ranges/current-source re-tests are in division_results.md
and raw logs. This evidence does not prove universal CT or physical leakage
resistance. Other B helpers and retained scalar paths keep their own limits.

The integrated-source repeat division/20260927T171330Z again matches all
1,018,184 raw outputs. New timing minima are 136969 for all classes, but
occasional maxima are 136970. This latest run is not claimed to be exactly
equal on every sample, nor is the cause of the one-cycle variation proved.

## A8 direct fixed-array quotient

The independently written `fndsa_fxr_div4` has the same two fixed 31/32
loop counters, lane-local borrow/carry and no operand-indexed memory or
operand-dependent fallback. VLD2/VST2 operate on the fixed four-element
fxr arrays; no FP conversion is needed. The C reciprocal wrapper branches
on public logn and array counters; squared norm and shift preserve the
original arithmetic sequence. Global scalar division is unchanged.

fixed_division/20260927T172407Z: 1,018,184 quotient outputs and 320 full
reciprocal arrays match. All 32 operand classes x20 trials measure 134346
cycles per 64 four-lane helper calls. This is finite evidence for this
local routine; there is no universal timing/power/EM or whole-keygen CT
claim. Focused current ELF disassembly is in audit/A_tw_bridge.txt.

Repeat fixed_division/20260927T173029Z again has all class minima 134346,
but occasional maxima 134347 (the scalar repeat is 445390–445391). The
repeat is not exact-equal on every sample. The unchanged FP64 divider's
current kernel run 172903Z likewise has all minima 99979 with one maximum
99980. These variations are recorded without asserting a proved cause.

## B11 fused point product

The new `fndsa_ds_mul_span` has one conditional branch controlled by its
public block count. Its vector carry/borrow and decoder/encoder exceptional
handling use fixed instruction sequences and predicates; no operand-derived
address, early exit or accuracy fallback was introduced. The C wrapper
dispatches on public logn and restores its own frame before a tail jump.
The retained scalar path and unrelated helpers retain their previous limits.

Initial decoding/173852Z raw-product experiment: all 32 classes x20 trials
give 10249 cycles for 128 four-lane calls (scalar 10891). The extended
decoding/174449Z harness, with changed code/data layout but identical crypto
sources, gives 9993 (scalar 11019), equal across its 32 classes. Do not
interpret the harness-to-harness shift as an arithmetic improvement.

The extended fused-loop test resets identical input arrays outside each
timed call, includes conversions/calls/stores, and uses 24 operand classes
x20 trials at each of public logn=3 and 9. Numerical results match the
frozen scalar DS point product. For 32 calls, logn=3 totals are 56383–56384;
logn=9 totals are 3421088–3421089. Small one-cycle differences are not hidden
or claimed to have a proven cause. There is no systematic multi-cycle
per-call split in these finite tests, but that is not a universal timing,
all-input equivalence or physical-leakage proof. Full integer product
correspondence is separately checked on 1,000,484 raw results.

Same-ELF decoding repeat 174653Z passes all numerical cases again. Raw
multiply remains exactly 9993/11019 for every new/scalar sample. The fused
32-call range is 56383–56384 at logn=3 and 3421087–3421089 at logn=9.
Those occasional ±1 deviations around the usual totals are not called
perfect constant time or attributed to a proved microarchitectural cause.

## B12 fixed-input boundary

B12 has its own `fndsa_fixed_input_mve` body in the B assembly file. Linked
inspection finds only public len/n loop and short-store branches. The C
wrapper's only data-flow split is public len==0. Secret scale selects limbs
through arithmetic masks and shift counts, never a secret-indexed load or
early exit. VCTP predicates the valid coefficient count, not secret values.
This retains the original read-all-limbs input rule and shift domain.

fixed_input/20260927T175449Z compares 220672 exact outputs. At n=2,len=32,
32 input/scale classes x20 trials x128 calls have new minima 158738 and
maxima 158739; original minima 361870 and maxima 361871. All class minima
agree. These finite observations and branch/address inspection are not a
machine-code CT proof, a physical leakage assessment, or a claim that
rejection-based whole key generation has constant duration. Existing DS
FFT arithmetic retains the limitations of its previous finite checks.

## B13 fused large-input boundary

`fndsa_ds_from_big_span` retains the B12 selector and encoder instruction
bodies in local macros. The archived standalone bodies remain byte-identical.
The new outer loop branches only on public remaining coefficient count;
the real-to-imaginary plane change is likewise at public n/2. There are no
inner calls, secret-indexed loads, zero-input shortcuts or secret precision
fallbacks. The public C wrapper uses len==0 and logn>=3 branches. Its scalar
small-size code is now a separate private function and is not part of a
claim that every compiler-generated path has been formally verified.

encoding/20260927T180800Z adds 32 input/scale classes at each of n=8/512,
len=8,20 trials,32 full conversion calls per trial. Class minima agree:
B13 31346/1773170, former B12 tiled interface 36142/2173102. Observed maxima
are B13 +1/+1 and B12 +0/+1. Results including all inactive array slots match
the reference. These fixed-public-size finite timings and linked-code review
are supporting evidence only, not a universal CT or physical-leakage proof.

## B14 encoder-only FastTwoSum

The five shortened sums have no magnitude test or data-dependent dispatch.
Their validity follows from the encoder's construction as analyzed in
../research/encoder_fastsum_design.md; this argument is not a machine-code
proof. Linked inspection confirms the standalone body has no conditional
branch and retains its fixed memory accesses. The fused input and point
loops retain their public-count branches; decoder/rounder general TwoSum
instructions are unchanged. No claim is made for secret-dependent total
duration of rejection-based whole key generation.

encoding/182456Z and 183231Z: all 20 classes x20 trials x128 four-lane
calls give 14728 cycles for the new encoder. Scalar observations across
these runs span 28809--28811. Full-input 32-call minima are 29426/1650290
at n=8/512,len=8 with occasional +1 at n=512. decoding/183257Z point-span
minima are 54464/3298208 with occasional +1. These small differences are
not discarded or assigned a proved cause. Numerical edge tests and full
current-source gates pass; finite timings do not prove all-input CT,
physical leakage security or universal KAT equivalence.

## A9 exact NTRU FFT

The twiddle multiplier dispatches among eight loops using only the public
root constant's high word and low-word top bit. For a given transform size
and layer, that sequence is fixed. Secret coefficients influence only
lane-local carry/borrow predicates, not addresses, loop lengths or branches.
The C loops select vector spans using public ht/count and original logn.
The public logn<7 wrapper tail-branches to the unchanged fixed kernel.
Linked bodies and the C/assembly call sites were inspected in audit/A_tw_bridge.txt.
These observations do not prove whole-program constant-time behavior.

Isolated twiddle/184341Z has identical minima across 16 input classes for
each fixed public constant/size; some maxima are +1 cycle. Different public
constants intentionally take different paths, so their times are not pooled
as evidence of secret-dependent timing. The production fixed_fft/185809Z
tests 16 timing classes x20 trials per direction/size; observed total ranges
are equal or differ by one cycle. Its 5120 raw-array/guard comparisons pass.
Stagewise rounded halves include overflow/wrap cases; no final-scaling
approximation is substituted. No universal leakage or formal CT claim follows
from this finite test. Whole keygen still has rejection-dependent duration.

## A10 fused exact Q32 butterfly

The directly written production helper has 18 public root-class/direction
loops. Its address table is selected only from the public twiddle words and
inverse flag. Each loop ends in BNE on public remaining coefficient count;
linked inspection finds no BL/BLX and no other conditional branch within
the helper. VPT carry/borrow predicates change arithmetic lanes, not memory
addresses or loop counts. The C wrappers dispatch only on public logn and
span length. Root cases outside the private helper's enumerated contract
trap; every used FFT root/conjugate is covered by the design/test enumeration.
The helper is not presented as a generic arbitrary-root multiplier.

The historical isolated fusion/194014Z trial checks all 511 roots in both
directions, 16576 butterfly cases and 3840 full-transform cases. The actual
A10 production fixed_fft/194449Z rechecks 5120 full-array/guard cases. For
16 timed input classes x20 trials per public size/direction, production
new-path maxima equal minima or exceed them by one cycle. Full-width raw
inputs include wrap/half edges; inverse stagewise rounding is preserved.
These observations do not establish universal machine-code CT or physical
leakage security. They do not make rejection-based whole keygen constant
time. Retained FP bridge paths have their separately documented limits.

All nine A10 main gates, including the unchanged input/division and depth0
paths, were rerun after crypto-source edits. Two whole runs with identical
ELF hashes differ by less than one cycle in per-key mean, but that is a
reproducibility observation, not an all-secret-input timing proof.

## A11 paired-limb input boundary

The production fndsa_fixed_input_mve helper selects the n=2 path only on
public degree. This path branches on public len/2, its loop counter and
len parity. The secret scale determines vector equality masks, not branch
targets or addresses. Two coefficients remain separate while adjacent limb
positions are merged. The final odd load and last-sign load stay within the
actual input, as inspected in the linked code in audit/A_tw_bridge.txt.
All remaining sizes retain the previous public-count loops and mask rules.

The test-only input_pair/200201Z gives identical 51345-cycle timings for
32 input/scale classes x20 trials x128 calls at n=2,len=32. The actual
production fixed_input/200512Z gives exactly 54290 cycles for every such
sample and passes 220672 output/guard cases. The difference is reported,
not hidden: the integrated path includes public dispatch and a shared
sign/store epilogue, and the test ELFs have different layouts. Neither
finite equality check is a universal machine-code CT or physical-leakage
proof. The untouched whole-keygen rejection loop is still variable-time.

## A12 four-coefficient predicate selector

For n>=4, linked fndsa_fixed_input_mve loads all four coefficients of every
limb unconditionally. Its equality predicates govern only VORR arithmetic,
never a load/store or branch. Public r3/len/count select the small/full paths
and loops. The n=1 path resets its original VCTP load mask, while n=2 retains
the A11 pair path; neither can be reached part-way through a full block loop
because the public degree is a power of two. Source and linked disassembly
are checked; this remains human inspection, not formal machine-code CT.

The isolated input_predicate/201720Z tests 32 coefficient/scale classes x20
trials x32 calls at n=4,len=32 and n=512,len=8. New times are 19987 exactly
and 740755--740756, respectively. The original/A11/new output/guard grid
passes 220672 comparisons, with small delegated paths distinguished from
the new scan. These are finite observations; the occasional one-cycle range
is retained and no all-input timing or physical-leakage guarantee follows.

Current-source input_predicate/202352Z repeats the comparisons after direct
integration. Production 32-call times are 19382 exactly at n=4,len=32 and
740918--740919 at n=512,len=8 across the same 32 classes x20 trials. Test
helper minima/maxima remain 19987 and 740755--740756. Full source-matched
KAT/sign/boundary/kernel gates pass. This is finite supporting evidence,
not a proof for all coefficients, all microarchitectural states or power/EM.

## B15 selector predicate rewrite

The linked production fndsa_ds_from_big_span retains unconditional reads
of every limb. Three VPT/OR arithmetic pairs replace the scalar-mask
construction; no memory operation is predicated and no scale-selected
address or conditional branch is introduced. The loop/plane counters use
public dimensions. The q5 scratch is overwritten before the common sign
tail. Standalone fndsa_ds_select4 uses the same locally expanded macro in
the encoding test ELF; it is discarded by the production keygen link.

Fresh encoding/203114Z uses 32 input/scale classes x20 trials. For 128 raw
selector calls every class minimum is 30347 cycles, with maxima equal or
+1. For 32 fused-input calls, minima are 20210 (n=8,len=8) and 1060466
(n=512,len=8), again with equal or +1 maxima. Public shapes are not pooled.
The finite grid, raw/encoded comparisons and human disassembly inspection
are supporting evidence, not universal machine-code CT, power/EM security
or constant-time whole rejection-based key generation.

## B16 decoder-specific shorter sums

Linked decoder and point-span inspection shows fixed instruction sequences
at all three changed sums, with no operand sorting, branch or table address.
Every original residual addition and integer tie/carry correction remains.
Point span's one loop branch depends only on public coefficient count.
The standalone decoder has no branch beyond its function return. Entry ABI,
scratch, coefficient load/store addresses and plane layout are unchanged.

Isolated decoding/204247Z: each of 24 input classes x20 trials takes exactly
40459 cycles for 128 four-value decodes (B15 was 42763). Point-span 32-call
minima are 52160 at n=8, and 3150751 or 3150752 at n=512; maxima are equal
or +1. The one-cycle spread is recorded, not hidden. Numerical raw outputs
agree in the separate 2,228,448-value grid. Tiny negative residuals remain;
only mathematically zero residual sign can differ, without changing raw
floor results. These finite observations and a local arithmetic argument
are not an all-input machine-code, full-keygen or physical-leakage proof.

## B17 decoder word extraction and carry updates

The new exponent extraction, scalar-operand vector subtractions and immediate
constant materialization contain no data-dependent control/address. Each
new VPST covers exactly one lane-local carry add; following loads/stores
are unconditional. The decoder still has only BX LR; the point span still
has only its public block-count BNE. r12 is initialized before each use.

Isolated decoding/205320Z has 24 decoder classes x20 trials, each exactly
37771 cycles for 128 four-value calls. Point-span 32-call minima are 49472
(n=8) and 2978720 (n=512) across all 24 classes, with equal or +1 maxima.
The 2,228,448 raw-word comparisons and complete product/inverse/division
grids pass. These are finite observations and human instruction review,
not formal CT, power/EM security or constant-time whole key generation.
Original rejection behavior and the inherited B16 signed-zero caveat remain.

## B18 immutable inverse cache

Preparation and cached-product loops have only their public count branches,
sequential addresses and no external calls. C wrappers are tail calls in
the linked keygen ELF. Q32 multiplication and codec operation order are
unchanged; source extraction confirms DSP_PRODUCT_ENCODE exactly matches
B17's product/encode body. No secret cache lookup or value-based reuse
decision exists. Cache lifetime is one original public solver level.

Decoder runs 210938Z and 211437Z test 560 cached products with exact scalar
source-word comparison, alias snapshots, full-object tails, guards and
immutability. For n=8/512, 24 operand classes x20 trials separately time
prepare, reused product, and prepare+one product. Across 32 calls the tested
interval spread is at most two aggregate cycles; it is not hidden or claimed
to be a full constant-time proof. The new cache lives in already allocated
secret scratch; no new global or retained cross-key cache is introduced.
Original rejection-based whole keygen remains variable-time.

## A13 packed short stages

`fndsa_ntru_q32_tail` branches only for public ht=1/2, forward/inverse and
the public count. Root addresses and gather/scatter offsets are fixed by
those values. Arithmetic signs, carries and borrows affect only vector
values/predicates, never addresses or scalar branches. The exact original
three products, truncations, wrap64 and inverse stagewise half remain.
Linked audit covers both wrappers and the new helper; no external calls
occur in the helper. No SLOTHY or secret-dependent precision switch.

Runs fixed_fft/212259Z and212406Z compare5120 raw transforms with original
fixed kernels, including edge/random words, four offsets and guards.
For the first16 input classes x20 trials per public size/direction,
all current minima/maxima are equal except one aggregate-cycle difference
at iFFT1024. This is finite kernel evidence, not formal CT or physical-leakage
resistance. The known rejection-based keygen behavior is unchanged.

## A14 packed root components / lifetimes

The bounded component product has no scalar branches. The verified PUBLIC
root high word 0/-1 selects a masked subtraction, not an indexed lookup or
secret-dependent precision path. q6/q7 are preserved by the component macro;
the generic summed-root macro retains its original signed corrections.
Reordering independent integer products changes no truncation/half rule.
Rootmul/213803Z passes 1,001,024 raw products and guard/immutable-root checks;
32 classes x20 trials all take 1888 cycles for 32 calls. This run is the
component-only source; its passes are not inherited. Final combined-source
rootmul/214540Z independently repeats all1,001,024 products and32 classes
x20 trials: guards/roots intact, zero failures, exactly1888 cycles per32
calls in every tested class/trial.
Combined fixed_fft/214004Z passes 5120 raw transforms with at most one cycle
of tested min/max spread for each public size/direction. Source-matched final
gates are listed in packed_root_lifetime_results.md. Finite observations are
not formal CT or physical-leakage evidence. Original keygen rejection remains.

## A15 live packed outputs and public n16 forward dispatch

The change removes final scratch round trips without changing arithmetic,
stagewise halves, operand-dependent selection or external addresses. In the
linked tail, forward q3 is used as an offset only before it is overwritten
by sum.high; q7 is reloaded as an offset only after real.high is dead.
Inverse q2 offsets remain live through both scatters. Neither new body
contains a call or secret branch/address. All stores remain unconditional.
The wrapper checks only public logn against3; n16 satisfies the hn>=8 full
block contract, and n<=8 retains the original fallback. No new precision
or coefficient-based fallback exists.

Isolated fixed_fft/215459Z and215556Z each pass5120 raw transforms, then
final-suite fixed_fft/215818Z independently passes. Tested class/trial spread
is at most one cycle in215556Z and two in215818Z (iFFT1024). These observed
spreads are reported, not treated as a universal CT or leakage guarantee.
The full-source gate status is in packed_finish_results.md. Rejection-based
whole keygen remains variable-time.

## A16 public ht=1 deinterleaving

Linked root/input VLD4 and forward-output VST4 sequences are complete,
unpredicated and address the same64-byte root/component blocks as the
original gathers/scatters. There is no coefficient-dependent address or
branch. Four assembly loop bodies dispatch only on public ht/direction,
once outside the block loop. ht=2 retains its original duplicated-root
map and never performs the four-root contiguous load. Coefficient blocks
are disjoint, and forward's independent difference-before-sum order retains
all wrap/carry results without overwriting an operand still needed later.

Root-only fixed_fft/220756Z, combined221008Z and final-source234418Z each
pass5120 exact raw transform cases with offsets/guards. The final source's
tested16-class x20-trial spread is at most one cycle per public size and
direction. A public-address model additionally checks254 coefficient and
127 root blocks across logn4..10. This is finite support plus source/linked
inspection, not an instruction-emulator proof, formal CT or power/EM claim.
Full current-source gate status is in packed_layout_results.md.

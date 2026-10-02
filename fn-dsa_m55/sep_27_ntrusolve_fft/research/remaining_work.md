# What is not claimed or completed

Latest feasibility audit (2026-09-28):
[scope_feasibility.md](../validation/scope_feasibility.md) rechecks frozen
baseline/A16 logs and 218 identical operation/call/success records. With all
other profiled work fixed, zero-cost target FFT scope gives only 1.2621x/1.1668x
versus the profiled M55_ref. Even also zeroing the separate integer update
gives 1.7793x/1.6234x, not 1.7x for 1024. These are conditional accounting
figures, NOT new speed measurements or universal impossibility bounds.
[An additional six-page primary paper](babai_scope_review.md) was read
fully; its arbitrary-precision/iteration approach is not a drop-in FFT
change and does not establish our KAT/CT requirements. No production change
or new permission assumption was made. The earlier scope question remains
unanswered. Do not present further tiny scheduling gains as a route to 1.7x.

1. The 1.7x whole-keygen target is NOT achieved. The current measurement
   supports a scope constraint, not a global impossibility proof. Under the
   current algorithm/work counts, even zero-cost target FFT arithmetic is
   insufficient. Widening scope or changing iteration policy requires a new
   design/validation decision; it has not been silently done here.
2. There is no claim to have exhausted all conceivable algorithms. The tested
   alternatives and rejected variants are in experiment_log.md. Relevant
   paper methods were assessed; modular/binary-field arithmetic and SLOTHY
   were deliberately not transplanted into real Q32 FFT operations.
3. B5–B18 optimize the continuous-DS input expansion, final rounding,
   point-product/inverse/division representation edges and the input limb
   scan and the original Q32 quotient recurrence. B11 fuses the point
   product's representation boundaries and exact vector integer arithmetic.
   B12 also improves small fixed-input boundaries, but still loses to ntt_opt
   by 0.85%/0.32%. B13 fuses the large input boundary and narrows the deficit
   to 0.57%/0.16%; B14 shortens encoder normalization and further narrows it
   to 0.38%/0.05%. B15 shortens the input selection further: versus ntt_opt
   it is 0.212% slower at 512 and 0.056% faster at 1024. B16 shortens three
   decoder sums under derived floor/fraction conditions, giving first means
   57.004M/242.854M cycles, -0.1196%/-0.0687% versus B15. B17 then shortens
   exact word/constant/carry setup, reaching repeated 56.886M/242.567M
   cycles, -0.2060%/-0.1183% versus B16. A12 still leads B17 in
   whole key generation. B18 caches the represented immutable inverse once
   in original rt3: first whole time falls .8608%/.5089% to 56.397M/241.332M,
   still behind A12. Further in-scope candidates include reducing
   private tile/call traffic, further specialization of the fixed input
   boundary, better bounded Q32 quotient estimation with exact residual
   correction, and fixed-surrounding boundaries around other transform sizes.
   These may improve marginal FFT speed, but do not remove the measured
   non-target time floor. A general 96/64 Q32 FP-assisted divider requires its
   own quotient, overflow and constant-time proof; the cited 64/64 algorithm
   is not that proof.
4. An algorithm-level Babai iteration-count change may affect integer update
   work, numerical bounds, failures and deterministic keys. Merely increasing
   reduce_bits is not a justified or adopted optimization. This was not used
   to inflate the claimed FFT improvement.
5. Universal original-KAT equivalence, formal CT, power/EM leakage and a
   worst-case stack proof remain beyond the finite tests recorded here.
6. Existing production reference folders were NOT replaced. A16 is the best
   tested experimental hybrid, not a blanket claim that all keygen FFTs now
   use floating point or that the whole research objective is finished.

## Completed input-boundary experiments and next candidates

B9 has implemented that four-coefficient scan. Its full-keygen gain over B8
is 0.79%/0.49%. B10 additionally vectorizes exact division: whole-keygen
time falls another 1.84%/0.88%, not the isolated helper's 3.2751x ratio.
Profile evidence now changes the next priority:

- B10 intermediate input conversion still costs 1.509M/4.717M cycles. Of that,
  public logn=1..3 consumes 0.742M/2.791M in the unchanged fixed path. No
  claim that B9 improved those small transforms or their fixed conversion.
- B11 has now fused the point-product decoder, original 3-product Q32 rule,
  and encoder in one assembly span. Its point interval falls from B10's
  2.221M/5.564M to 1.964M/4.924M. Whole time falls .4362%/.2558%, not the
  isolated point call's ~13.4%. It still exceeds A8's fixed point interval
  (0.451M/1.168M) substantially; exact DS normalization remains expensive.
  Further decoder specialization needs proven operand bounds, not a
  secret-dependent fast path or simply discarding low bits to pass KAT.
  Current reciprocal/depth0 division stay ~0.484M/0.960M and 0.467M/0.933M.
- A7 has independently implemented exact fixed-input selection in A's own
  integer MVE assembly. All intermediate input costs fall from A6's
  1.531M/4.799M to 0.667M/1.929M cycles; the other arithmetic costs stay nearly
  unchanged. Small n=1/2 uses masked reads and precise-length stores. This
  does not mean the FFT itself became floating point or vectorized. See
  fixed_input_results.md for the 220,672 original-bit comparisons and timings.
- The former n=2 input cost was 0.221M/0.769M. A11 has now implemented
  two coefficients times two adjacent limbs per vector instead of two idle
  lanes, including exact combination, odd-limb loads, sign extension and ABI.
  That interval falls to 0.164M/0.520M. Whole gains are only .095%/.099%.
  The implemented/validated result is in validation/paired_input_results.md.
- B13 implements the fused large-input selector/encoder, with no 32-byte
  word tile or per-block helper calls. Its private scalar fallback no longer
  inflates the hot wrapper frame (456 ->48 bytes); the new span uses 96
  bytes. Large-input profile costs fall from 0.767M/1.927M to 0.610M/1.535M.
  All current-source gates pass, including 63552 additional full-input cases.
  First whole-keygen time is 57.277M/243.545M, -.2718%/-.1590% vs B12.
  No change to normalization arithmetic itself was made by this fusion.
  B14 subsequently implements the bounded encoder-only FastTwoSum rewrite,
  with an analytical operand argument, 15.24M host intermediate-bit cases,
  5.24M new MVE edge words and all current-source gates. Encoder instructions
  fall 69->54; large-input time falls another 8.53%/8.42% and the point
  interval another 2.65%/2.63%. Whole time decreases only .1953%/.1126%,
  to 57.165M/243.271M. Its point interval remains 1.912M/4.795M versus
  A8's 0.451M/1.168M. The decoder and rounder still need their general
  TwoSum: deleting their residuals or using the encoder bounds for arbitrary
  DS values is NOT justified. Any further normalization specialization
  needs its own range/cancellation/subnormal argument and board tests.
- B12 now directly implements the exact integer-MVE input converter in B's
  own tree. Small-input cost falls from 0.742M/2.791M to 0.483M/1.562M;
  large DS input costs stay ~0.767M/1.927M. Its first whole measurement is
  57.433M/243.933M, .4519%/.5028% less time than B11, still behind A8.
  All current-source gates are rerun, including 220672 fixed-input calls.
  The remaining B12 n=2 input cost is 0.278M/0.994M. A two-coefficient,
  two-limb vector layout remains a hypothesis, not a measured successor;
  large-input fusion is now B13 above. See b12_fixed_input_results.md and
  input_fusion_results.md for separate evidence.
- A8 has now implemented the independent Q32-array divider in A's own .s.
  `vect_inv_mul2e_fft` remains NTRU-local; global `inner_fxr_div` and candidate
  invnorm are unchanged. Reciprocal cost falls from 0.933M/1.872M to
  0.304M/0.603M cycles; whole time falls 1.1354%/0.5310% vs A7. The repeated
  whole run is 54.766M/237.611M (M55_ref/A8 1.1456x/1.1015x). All gates are
  tied to current source hashes; see fixed_division_results.md.
- The remaining scalar logn=1/2 reciprocal work is only 13,648/18,888 cycles
  per key. Packing real/imaginary quotients into one four-lane call could be
  tested, but even zero cost for these paths is <0.03%/<0.01% of whole-keygen
  time. Do not prioritize it as a route to 1.7x. The input boundary and B's
  point-product representation traffic are larger remaining hypotheses.

The public n=2 input experiment has now completed as A11. Its standalone
trial passes 68608 cases, followed by all fresh production gates and a
same-ELF whole repeat. The original all-limb read rule, odd-length handling,
sign extension and exact stores remain intact. B14 has not received this
path; an independent B integration remains possible but has not been
measured or credited. A12 has now implemented the n>=4 vector-predicate
selector in A, preserving unconditional input loads and both small paths.
All main and two extra input gates pass. Input time falls another 23%/25%
for n>=4, but plain whole time only .185%/.121%; repeated means are
54.168M/235.700M cycles. See validation/predicate_input_results.md. An
independent change to B's DSS_SELECT_CORE has subsequently completed as
B15. Its own raw-selection/encoded-array/full gates pass; A's tests were
not inherited. Large DS input falls 16.65%/17.75%, but whole time only
.1623%/.1026% versus B14, to 57.072M/243.021M. The same-ELF repeat agrees
within 0.1 cycle per-key mean. A12 remains faster. See
validation/b15_predicate_input_results.md for independent/shared test-oracle
distinctions, CT limitations and archived-ELF placement caveats.

B still retains the earlier small fixed converter at logn=1..3. Applying
the paired-limb n=2 and exact n>=4 selection ideas to that local fallback
is a separate untested successor, not part of B15 and not credited here.
Its remaining small-input interval is about 0.483M/1.562M per key. Even
eliminating it entirely would be a small whole gain and would not reach
1.7x or address B's 1.912M/4.795M point-product normalization cost. Further
point-boundary specialization needs explicit bounds and fresh evidence.

B16 has now provided such an argument for three specific decoder sums,
without assuming all DS pairs are magnitude-ordered. The finite host and
M55 raw grids plus all eleven fresh gates pass. Its actual DS point interval
falls 3.64%/3.65% (all intermediate point time 3.27%/3.24%); reciprocal and
real division also gain slightly. Whole time falls only .12%/.07%, so this
does not remove the non-target floor or overtake A12. See
validation/b16_decoder_fastsum_results.md for zero-sign distinctions and
nonzero residual preservation. General FFT/rounder sums remain unchanged.
B17 has now also shortened exact integer exponent/word extraction, immediate
constants and lane-local carry updates. All eleven fresh gates and whole
repeat pass; 320 code bytes are removed with data/frames unchanged. Actual
DS point time falls another 6.50%/6.52%, but whole time only .206%/.118%.
No accuracy relaxation, arbitrary Fast2Sum substitution or work-count change
was introduced. See validation/b17_decoder_words_results.md.

B18 has implemented the immutable inverse cache outside the original loop.
The post-ENCODING raw-word rule and rt3 lifetime were audited; 560 cache
products/source words/guards and all eleven fresh board gates pass.
Including preparation, large point time falls 31.10%/31.65%; all intermediate
point time falls 27.57%/27.68%. Whole-keygen time falls only .86%/.51%.
Babai counts and other operation counts stay fixed; I_mul includes additional
once-per-inverse preparation calls. See inverse_cache_design.md and
validation/b18_inverse_cache_results.md. This hypothesis is now tested,
not a remaining unimplemented candidate. Further opportunities include
independently adapting the small-input two-limb scan to B, and reducing the
changing operand's point tile/normalization cost with exact arithmetic.
The user has also been asked whether Babai iteration-policy research may
be added to pursue 1.7x; without a reply, that expansion is not authorized
and no such algorithm change is made. Current in-scope progress continues.

A9 has since tested a larger FFT-core hypothesis: specialize exact Q32
products for the public twiddle's bounded high word. The multiplier alone
wins on long spans, but scalar surrounding operations erased the gain in
all nine complete-transform configurations. Vectorizing the surrounding
original add/sub/three-product combination/stagewise half made n>=128 win.
The adopted NTRU-only path preserves small original transforms and all
candidate-norm code; full current-source gates pass. Repeated whole time
is 54.621M/237.011M, 1.1486x/1.1042x versus M55_ref, still far from 1.7x.

Important open attribution issue: A9's standalone fixed FFT/iFFT gains
exceed its instrumented integration gains (logn7 iFFT even regresses in
the profile ELF). Calls/success counts are unchanged. A test-only same-ELF
data/stack-alignment sweep has completed 2048 exact array checks. Its at-most
0.15% forward spread and nine-cycle inverse spread cannot explain the gap;
data/stack alignment is not supported as the main cause. A separate identical-
instruction multiplier address sweep has also passed 2304 exact cases, with
identical minimum times at eight modulo-32 offsets and the production entry.
This multiplier's address offset is therefore not supported as the cause.
Neither diagnostic changes production. A wider absolute data/stack sweep
and paired DWT/k_cycle timer with IRQ allowed/masked passed another 1152
cases. Minimum times stay identical across nine placements and IRQ states;
the outer timer adds exactly 81 cycles to both original/new inner intervals.
Those tested factors do not explain the gap. Actual NTRU-input replay has
also completed 96 paired calls, with original/new/repeated raw outputs and
200 resulting KAT/equation checks passing. It recovers the fast isolated
timings. A combined profile+kernel-probe ELF passes 5120 raw cases and
200 keys, but still exhibits context-dependent timing differences. Its
addition moves some code, so it is NOT an all-address-pinned experiment.
Instruction/caller context needs tighter control before attributing a cause.
The source-matched plain-keygen repeat remains the production speed result;
these five supplementary diagnostics do not change or supersede A9.
Profile and plain whole-cycle totals must not be substituted for each other.

A10 has now removed A9's 3-KiB tile and repeated span calls by fusing the
exact butterfly. All nine main gates and a same-ELF whole repeat pass. The
new mean is 54.320M/236.220M cycles: .55%/.33% less time than A9 and
1.1550x/1.1079x versus M55_ref. The intermediate FFT/iFFT profile falls
12--13%/11--12%, with identical call counts and unchanged surrounding work.
The 64-byte scratch and 384/416-byte local stack chains are much smaller,
but do not prove a whole-program bound. See validation/fusion_results.md.
Further scratch/register scheduling may have marginal room; it has not
been implemented or projected as a route to 1.7x. A11's n=2 input change
is separately measured above. No scope expansion follows from
the fact that these remaining opportunities are smaller than the target.

Compare any next candidate only after raw-word/FP32/original KAT tests and
the full board gates. A16/B18 current completed tests are tied to source hashes
in current_validation.json; they do not transfer to an untested successor.
These directions stay within NTRU FFT arithmetic/boundaries; no NTT, CRT, Bezout,
reduce_bits or SLOTHY change is authorized or implied. These are hypotheses,
not achieved speedups or paths proven to reach 1.7x. The non-target time
floor remains even if they are successful.

## A13 packed short stages completed

A12 still executed ht=1/2 stages as scalar complex butterflies in every
large transform. A13 now packs four butterflies across roots with a public
gather/scatter map and exact integer-MVE Q32 operations. No layer is skipped
or merged algebraically, and all stagewise inverse halves remain. The
5120 raw full-transform cases and fresh main/input gates pass. First plain
whole means are53.947M/235.116M, only .4091%/.2476% below A12. Kernel512/1024
FFT improves16.96%/15.97% and iFFT12.91%/12.04%, but actual integration FFT
time falls9.01%/9.07% and iFFT5.69%/5.62%; small paths remain unchanged.
All218 profile operation/call counts match. Scope floor is still unchanged.
Remaining hypotheses include reducing the new private tile traffic and
comparing contiguous/deinterleaving short-stage layouts against gathers;
root-specific multiplication bounds could also shorten exact arithmetic.
Those are untested performance hypotheses, not promises of1.7x. Babai work
policy is still unchanged, with the earlier scope question pending.

## A14 bounded products and lifetime experiment

Actual-table bounds and an exact word identity now shorten two of the three
packed complex products (summed root remains general). The component-only
trial passes independent host/board arithmetic and raw transform checks.
The combined source additionally keeps z0 in registers and reuses temporary
slots; scratch shrinks 256->160 bytes. Large FFT/iFFT time falls another
roughly 3--4%, but first whole-keygen time only .143%/.082%. Its source-matched
gates and repeated timing are in validation/packed_root_lifetime_results.md.
All 218 profile operation/call counts match A13. No original integer-update
or Babai policy change, and no route to 1.7x is established by these gains.

The PUBLIC forward logn=4 cutoff and avoiding final product spills have
now been tested as A15 below. Remaining hypotheses include comparing
public contiguous/deinterleaving layouts with gathers. Smaller hn
would require correct predicated gathers/stores, not calling the current
full-block helper outside its hn>=8 contract. Those smaller-block/layout
variants are not yet implemented or credited. The earlier question about
Babai-policy scope remains unanswered;
it is not treated as permission to change iterations.

## A15 direct packed outputs and n16 forward path completed

Two independently measured changes remove final packed-result spills and
lower only the forward public cutoff5->4. Raw original-word comparisons
pass for both variants; the combined source passes all twelve fresh gates
and a same-ELF whole repeat. Current mean53.814M/234.793M is only
.1027%/.0553% below A14, despite about2% large-kernel savings and27.36%
isolated n16 FFT savings. The connected n16 gain is14.13%; all218 profile
call counts match, with no Babai/integer-update work change. Code is60B
smaller and stack/data peaks unchanged. See validation/packed_finish_results.md.

Public ht=1 layouts have since been tested as A16 below; further scratch
traffic or other public layouts are distinct hypotheses, and B's
small-input/point-codec candidates remain independent.
They are not promises of1.7x: the measured non-target floor still applies
under fixed work counts. No scope expansion or universal CT/equivalence
proof is inferred from the completed finite gates.

## A16 public ht=1 deinterleaving completed

The root-only VLD4 variant and combined inverse-input VLD4/forward-output
VST4 variant pass independent raw tests. The combined source passes all
twelve fresh gates and a same-ELF keygen repeat. Mean53.777M/234.700M is
only .0688%/.0395% below A15; all218 profile counts are unchanged. Code
grows1540 bytes, data and frames do not. A16 is the fastest measured A,
while A15 is retained as the smaller-code alternative. See
validation/packed_layout_results.md for the tradeoff and finite evidence.

ht=2 still uses its required duplicated-root/gather mapping; arbitrary
contiguous loads cannot replace it without a correct permutation. The
profile's unchanged point-multiply interval (about .451M/1.168M per key)
and private product scratch remain potential in-scope work. These are
bounded marginal opportunities, not an established route to1.7x. The
fixed-work non-target floor and unanswered Babai-scope question remain;
no iteration/integer-update policy change is silently authorized.

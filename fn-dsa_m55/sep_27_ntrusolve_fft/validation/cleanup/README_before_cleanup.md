# A17 — A16 plus native-FP64 candidate invnorm

2026-09-28 user-requested extension: `vect_invnorm_fft(e=0)` now uses the
earlier native FP64 four-square/normalized-reciprocal arithmetic. Its Q32
ABI is preserved through local scalar conversions, without full-size double
arrays or an external implementation link. Other public e modes and the
candidate FFT/iFFT remain fixed. All NTRU A16 code is unchanged.
This is not a raw-word equivalence claim for arbitrary inputs. See
[invnorm results](../validation/invnorm_results.md) for fresh accuracy, decision,
KAT and timing evidence. All thirteen current-source gates and a same-ELF
keygen repeat pass. Archived A16 passes are not inherited after this change.
A16 is preserved in `../validation/source_snapshots/A16_deinterleave_ht1.tar.gz`.

[Five-check assessment](../validation/security/README.md), 2026-09-28:
the requested speed, numerical-error, KAT, sign/verify and constant-time checks
are complete. Intermediate numerical differences and finite timing coverage are
reported, not hidden by a blanket PASS. Full security certification and deployment
entropy/key-lifecycle/physical-leakage work are outside the clarified request.
Crypto sources are unchanged by this validation and scope clarification.

## Historical NTRU implementation through A16

This folder name records the original TW + DS-bridge experiment. The CURRENT
NTRU intermediate function keeps the frozen ntt_opt algorithm and arithmetic
rules. A9/A10 change only two FFT calls and one iFFT call to NTRU-local entry
points; this exact call-only difference is checked by validation/check_scope.py.
The earlier full FP-surrounding intermediate trials lost after including
their surrounding work. Its called `poly_big_to_fixed` is implemented by
`fndsa_fixed_input_mve`: four-coefficient limb selection/sign extension/shifts
with exactly the original Q32 output and exact-size loads/stores. A11 uses
two coefficients x two adjacent limbs per vector for public n=2; the final
odd limb loads only its actual two words, then rejoins original sign/shift
rules. n=1 retains masked loads. A12 uses exact vector equality/OR in the
four-coefficient scan at n>=4. All loads in that path are unpredicated so
the secret comparison cannot affect input addresses or suppress a read.
There is no new FP conversion at this boundary. Only solve_NTRU_depth0 uses double preparation, the local
DS MVE FFT bridge, native FP64 division and checked integer rounding.
Division zero/range predicates use fixed-count inline assembly; the A4/A5
timing issue and A6 finite operand tests are documented in validation/ct_results.md.

A8 additionally batches `vect_inv_mul2e_fft`'s original Q32 divisions at
public logn>=3 through the locally written `fndsa_fxr_div4`. VLD2/VST2
deinterleave/interleave the existing fxr words; the four quotients retain
the original bit recurrence, rounding, signs and lane-local carries.
The array representation is unchanged, and the global scalar divider and
candidate-check invnorm are not replaced. logn=1/2 retains the scalar path.

A9 added `vect_FFT_ntru` / `vect_iFFT_ntru`. A10 replaces the five separate
span helpers and 3072-byte C tile with one directly written assembly loop.
It has 64 bytes of product scratch and a 176-byte total callee frame. Public
forward logn<5 and inverse logn<4 retain the unchanged fixed kernels. Larger
transforms vectorize spans of at least four coefficients in both directions.
The original three-product
complex formula and every stagewise iFFT rounded half are preserved.
The original GM_TAB is reused in this C file, not loaded from another tree.
All assembly bodies are directly present in kgen_fft_cm55.s. This is an
integer-MVE improvement of the fixed portion of the hybrid, not an FP64
arithmetic rewrite or a generic secret-dependent precision fallback.
Eighteen public root-class loop bodies cover all 511 forward/conjugate roots
without branches or addresses depending on coefficients. The case table is
written directly in the same assembly file, not generated during a build.
The previous A9 implementation is archived, not linked as a selectable backend.
See ../validation/fusion_results.md for A10 and ../validation/twiddle_results.md
for A9. Only source-matched completed gates apply; A9 tests are not inherited.
The A11 change is confined to this assembly file; its independent trial,
fresh production validation and whole effects are recorded separately in
../validation/paired_input_results.md. No old gate is inherited after a
source change. The A10 source snapshot is retained for reproducibility.
A12 likewise changes only this assembly file, retaining the original Q32
sign/shift/store tail and all NTRU iteration/update rules. Its isolated
predicate experiment and fresh production gates are documented separately
in ../validation/predicate_input_results.md; A11 is also archived.

A13 replaces the ht=1/2 scalar stage loops in the large transforms with
`fndsa_ntru_q32_tail`, directly written in this own assembly file. Four
different butterflies/roots are packed into integer-MVE lanes with public
gather/scatter offsets. Each original truncated product, wrap and rounded
inverse half is retained. This removes the last two forward /first two
inverse scalar stages, NOT the public small-transform fallback. Long-span
root-case loops and depth0's floating path are unchanged. New helper scratch
is 256 bytes (360-byte total frame); its immutable offset table is 64 bytes.
See ../research/packed_tail_design.md and ../validation/packed_tail_results.md.
A12 is archived; all current-source main/input gates are rerun. Kernel
improvement is not the whole-keygen ratio, and the 1.7x target is still unmet.

A14 changes only the same assembly file. Root real/imaginary high words are
0/-1 for every used original root and its inverse conjugate. The component
multiplier uses that PUBLIC bound while allowing any raw coefficient. The
summed-root product still uses the generic exact multiplier. Keeping z0 in
q6/q7 through z1 and computing independent z2 first reduces private scratch
to 160 bytes and the callee frame to 264 bytes. All truncation points and
the final three-product combination remain unchanged. The component-only
trial and final combined variant are separately recorded in
../validation/packed_root_lifetime_results.md; see the associated design for
the actual-table/model proof and supported internal helper contract. All
twelve fresh source-matched gates now pass, including board root-product,
full raw FFT, whole KAT and signature tests. A same-ELF repeat measures
53,869,412.69/234,922,906.90 cycles per key (512/1024). Finite passes do not
prove universal equivalence or formal constant-time behavior.

A15 removes the final real/imaginary product spills in the packed tail.
Inverse outputs scatter directly from their live registers. Forward uses
a temporary public gather-map register, then reuses the dead real-product
register for output offsets. Eight stack accesses disappear; forward needs
one additional map load. Arithmetic, stagewise halves and scratch peak stay
unchanged. A separate trial lowers ONLY the forward public cutoff from
logn5 to logn4, since the packed helper supports hn=8 exactly. Thus current
forward/inverse large paths both begin at n=16; n<=8 remains original.
Both isolated raw FFT tests, all twelve fresh A15 board gates and repeated
whole keygen now pass. Repeat means are53,814,104.34/234,793,059.77 cycles,
1.1658x/1.1147x versus M55_ref including prior NTT gains;1.7x is unmet. See
../research/packed_finish_design.md and ../validation/packed_finish_results.md.
A14's final source snapshot and its completed measurements are retained.

A16 changes only kgen_fft_cm55.s. Public ht=1 loads four contiguous roots
with VLD4; inverse preparation likewise deinterleaves adjacent coefficient
pairs, and forward stores complete sum/difference pairs with VST4. ht=2
retains its original gathers/duplication. Four public ht/direction loop
bodies move dispatch outside the loop; code-size cost must be measured.
All original arithmetic and private scratch/frame peaks stay unchanged.
Root-only and combined raw FFT experiments, all twelve fresh full gates
and a same-ELF keygen repeat pass. Repeated means are
53,777,061.10/234,700,263.98 cycles, .0688%/.0395% below A15. The linked
code grows1540 bytes, data/stack peaks unchanged. M55_ref ratios are
1.1666x/1.1151x including prior NTT gains;1.7x is still unmet. See
../research/packed_layout_design.md and ../validation/packed_layout_results.md.
The archived A15 and its passing gates are not inherited by A16.

No new optimization of candidate orthonorm/invnorm, NTT, CRT, Bezout, signing
or verification. No secret-dependent precision fallback, no SLOTHY. Everything
is implemented in this source tree, not selected from another tree by linker
or build backend flags. The generated instrumentation lives under validation.

A0 original bridge, A1 small fixed, A2 fused point multiply, and A3 direct
native FP64 control are archived under ../validation/source_snapshots. Public
support routines from those experiments remain here for reproducibility;
unused functions are NOT credited as executed optimizations. This is still
an experimental candidate, not a newly deployed production reference.

See ../result.md for actual measurements and validation limitations.
The independent fixed-input oracle, small-size guard tests, timing and
current-source KAT gates are in ../validation/fixed_input_results.md.
The new reciprocal's raw-word, paired performance and full-keygen evidence
is in ../validation/fixed_division_results.md. Only gates matching the
current source hashes in current_validation.json apply to this version.

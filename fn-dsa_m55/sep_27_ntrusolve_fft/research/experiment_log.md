# Experiment ledger

All entries are implemented directly in their own tree, no cross-tree crypto
linking and no SLOTHY. Version labels refer to archived source/ELF hashes, not
switches in the production code.

Post-A16 analysis: [scope_feasibility.md](../validation/scope_feasibility.md)
and [babai_scope_review.md](babai_scope_review.md) record a raw-log accounting
audit and new primary-literature review, not another implemented variant.
All 218 profile call/success records match between M55_ref, ntt_opt and A16.
No board rerun or production change was needed for this analysis.

| Version | Change | Board result / status |
| --- | --- | --- |
| A0 | TW double surroundings + local DS MVE bridge | upstream KAT pass; slower than ntt_opt |
| A1 | public logn<4 uses fixed approximation | keygen 200 match; reduces small-transform overhead |
| A2 | point complex product: decode four scalars once, original 3-product Q32 rule in integer registers, two encodes | upstream 300 pass; still ~0.5% slower than ntt_opt |
| A3 | native scalar FP64 FFT/iFFT without the DS bridge; same A2 boundaries | upstream 300 pass; 59.13M /249.54M, slower than A2; rejected |
| A4 | restore original fixed intermediate solve; keep double/DS FFT and FP64 division only at depth0 | 56.25M /241.72M, upstream 300 + extra 300 pass; later timing audit finds operand-dependent cases; superseded by A6 |
| A5 | opaque mask prevents GCC zero-case branches | numerical division test passes; 2 cycles/call variation remains; not selected |
| A6 | explicit fixed-count zero/range predicates also remove conditional execution | 16 classes ×20 trials have identical quotient-test timing; 56.256M /241.744M whole cycles; archived before A7 |
| A7 | exact Q32 FFT input conversion via four-coefficient integer MVE; masked n=1/2 loads and direct interleaved word stores | 220,672 boundary cases +upstream 300 pass; first whole run 55.395M /238.879M; current-source full gates tracked in current_validation.json |
| A8 | exact four-lane Q32 division directly on the fixed intermediate reciprocal arrays; VLD2/VST2 boundary, original norm/scale, scalar small sizes | 1,018,184 quotient outputs +320 reciprocal arrays match; helper 3.3152x; repeated whole 54.766M /237.611M, 1.1354% /.5310% less time vs A7; all current-source KAT/sign/profile/kernel/input gates pass |
| A9 trial-0 (rejected) | specialize exact MVE products for bounded public FFT roots/sums, but retain scalar surrounding combination | 1,228,864 product words and 2880 FFT array cases match; long multiplier 1.454--2.374x, but complete FFT/iFFT loses in all meaningful sizes across 9 configurations; not adopted |
| A9 | vectorize exact surrounding add/sub/three-product combination/stagewise half too; own-source NTRU-only kernels, batch128, forward cutoff4, inverse cutoff8, original logn<7 | trial 5760 +production 5120 raw arrays match; production FFT512/1024 1.1973x/1.2472x, iFFT 1.1328x/1.1667x; repeated whole 54.621M/237.011M, -.2649%/-.2524% vs A8; all current-source gates pass, integration-profile gains smaller so alignment diagnosis added |
| A10 | fuse all exact Q32 butterfly span operations in one assembly loop; original root table and stagewise half, 64-byte scratch, forward logn>=5 and inverse logn>=4 | 16576 trial butterfly +3840 trial transform +5120 production arrays match; all nine current-source gates pass; repeated whole 54.320M/236.220M, -.5500%/-.3339% versus A9; 1.1550x/1.1079x versus M55_ref including previous NTT gains |
| A11 | for public n=2 input, use two coefficients x two adjacent limbs per vector, merge positions and share original sign/shift/store tail | isolated 68608 cases pass; all nine production main gates +additional paired-input check pass; repeated whole 54.269M/235.985M, -.0950%/-.0995% versus A10; 1.1561x/1.1090x M55_ref; +184 ITCM bytes, unchanged data/frame |
| A12 | shorten n>=4 FFT input selection to vector equality/OR while reading every limb unconditionally; preserve n=1 and A11 n=2 paths | isolated/production boundary grids pass; all nine main gates +two extra input gates pass; repeated whole 54.168M/235.700M, -.1850%/-.1208% versus A11; +48 ITCM bytes, unchanged data/frame |
| A13 | pack ht=1/2 stages across roots using exact generic four-lane Q32 multiplication and public gather/scatter; keep 3-product rule and original stagewise halves | 5120 raw transforms pass; all nine main and both input gates pass; kernel512/1024 FFT time -16.96%/-15.97%, iFFT -12.91%/-12.04% versus A12; first whole 53.947M/235.116M (-.4091%/-.2476%); ITCM +1044B, DTCM +64B; 1.7x unmet |
| A14 component trial | specialize only two packed root-component products using high-word0/-1; retain generic summed-root product | host 1,024,528 cases; board 1,001,024 products and 5120 transforms pass; isolated FFT512/1024 time -1.83%/-1.70%, iFFT -1.44%/-1.32% versus A13; isolated trial, not final full-gate evidence |
| A14 combined | additionally compute independent z2 first, keep z0 live through z1, reuse slots; scratch256->160, same original products/half | all twelve fresh gates and same-ELF repeat pass; repeated whole 53.869M/234.923M (-.1430%/-.0821% vs A13); kernel FFT512/1024 -4.03%/-3.73%, iFFT -3.16%/-2.90%; ITCM -112B, helper frame -96B; final gates recorded in packed_root_lifetime_results.md; 1.7x unmet |
| A15 direct finish trial | keep final packed real/imaginary results live; reuse dead vectors for public offsets, no arithmetic/cutoff change | 5120 raw transforms pass; FFT512/1024 -2.29%/-2.11%, iFFT -2.11%/-1.93% versus A14; isolated variant archived, not independently full-gated |
| A15 combined | additionally lower public forward cutoff to logn4 after independently validating hn=8/full-block contract | all twelve fresh gates and same-ELF repeat pass; n16 FFT -27.36% isolated; repeated whole53.814M/234.793M (-.1027%/-.0553% vs A14); all218 profile counts match; ITCM -60B, DTCM/frames unchanged; M55_ref ratios1.1658x/1.1147x, target unmet |
| A16 root layout trial | ht=1 roots VLD4; public ht/direction bodies; ht=2 unchanged | 5120 raw transforms pass; isolated large FFT/iFFT improve about.6%; own snapshot retained, not independently full-gated |
| A16 combined | additionally ht=1 inverse coefficient VLD4 and forward paired-output VST4, all original arithmetic preserved | all twelve fresh gates and same-ELF repeat pass; repeated whole53.777M/234.700M (-.0688%/-.0395% vs A15); all218 profile counts match; code +1540B, data/frames unchanged; M55_ref ratios1.1666x/1.1151x, target unmet |
| B0 | continuous DS arrays + initial Q32 compatibility | upstream KAT pass; 75.58M /288.64M keygen cycles |
| B1 | remove redundant FP-estimate product; use already computed exact Q32 product | upstream KAT pass; 73.20M /282.79M |
| B2 | direct fixed-count ARM exponent/word decoder | 261120 decoder +1M boundary +1M product tests pass; 69.71M /274.23M |
| B3 | fuse full pointwise complex product between DS boundaries | upstream KAT pass; 61.92M /254.87M |
| B4 | fuse squared norm/scale/division boundaries per coefficient | upstream KAT pass; 60.93M /252.67M |
| B5 | MVE 4-lane direct input expansion; original scalar limb extraction and TwoSum order retained | 1M raw +2070 from_big comparisons pass; upstream 300 pass; 60.20M /250.92M |
| B6 | MVE 4-lane final rounding with both range checks, negative-epsilon tie correction and genuine 64-bit overflow checks | 1,273,664 values match B4 oracle; 32 operand classes equal tested timing; upstream 300 pass; 59.83M /250.00M |
| B7 | MVE four-lane DS decoder + bounded point-product tile; exact integer products retained; subnormal scaling corrected after a failing diagnostic | decoder 2,228,448 values +640 products pass; upstream 300 pass; 59.531M /249.262M |
| B8 | reuse vector representation edges around unchanged integer squared-norm/reciprocal and real division | decoder +640 products +320 inverses +640 divisions pass; upstream 300 pass; 59.501M /249.201M; final gates tied to current_validation.json |
| B9 | four-coefficient MVE scan of all input limbs, same selection/sign/shift masks; remove unused q7 save | 67,840 raw-selection cases +272 extra full conversions pass; upstream 300 pass; 59.033M /247.984M; independent full gates tracked by hash |
| B10 | directly written four-lane exact Q32 restoring division; then split quotient-half accumulation; integrate into inverse/real-division tiles | 1,018,184 isolated quotients match; helper 3.2751× over scalar; whole 57.946M /245.794M (1.84% /.88% time reduction vs B9); current-source KAT/sign/profile/boundary gates pass, A7 still faster |
| B11 | one assembly span fuses DS decode, exact four-lane Q32 3-product complex multiply, and encode; no per-block helper calls/C tile | 1,000,484 raw products +640 complex products match, point call ~13.4% faster vs B10; repeated whole 57.694M /245.165M, .4362% /.2558% less time vs B10; all current-source gates pass, A8 still best |
| B12 | own integer-MVE poly_big_to_fixed boundary for public logn=1..3; large DS transforms unchanged | 220,672 raw input calls match; small input -34.97%/-44.04%, first whole 57.433M/243.933M, -.4519%/-.5028% vs B11; all source-specific gates pass, still slower than ntt_opt and A8 |
| B13 | fuse large-input limb selection and exact FP32 expansion into one assembly loop; isolate scalar fallback to shrink hot wrapper frame | 63,552 extra full input cases pass; large-input profile -20.52%/-20.31%, first whole 57.277M/243.545M, -.2718%/-.1590% vs B12; all source-specific gates pass, A8 remains best |
| B14 | shorten five encoder-only TwoSum pairs to FastTwoSum using derived operand bounds; preserve all residual rounding points and general decoder/rounder sums | host 15,242,880 +new MVE 5,242,880 edge cases pass; encoder 69->54 instructions, archived micro time -20.68%; repeated whole 57.165M/243.271M, -.1953%/-.1126% vs B13; all current-source gates pass, still slower than ntt_opt and A8 |
| B15 | replace the large-input selector mask materialization with three exact vector predicate/OR pairs; preserve unconditional reads and encoding | all eleven fresh gates pass; large-input interval -16.65%/-17.75%, repeated whole 57.072M/243.021M, -.1623%/-.1026% vs B14; A12 still faster, 1.7x unmet; production ITCM -48 bytes, data/frame unchanged |
| B16 | specialize two floor-fraction extractions and final fraction normalization with proven Fast2Sum conditions; keep all nonzero residuals and raw tie/carry rules | 13.65M host pairs and 2.23M board decoded values pass; all eleven fresh gates and same-ELF whole repeat pass; point calls -4.47%, actual DS point intervals -3.64%/-3.65%, whole 57.004M/242.854M (-.1196%/-.0687% vs B15); ITCM -180B, unchanged frames/data; A12 still faster, 1.7x unmet |
| B17 | shorten exact exponent extraction, constant setup and lane carries in the same decoder; preserve FP operation order and subnormal handling | 2.23M raw decodes and full point grids pass; all eleven fresh gates and same-ELF repeat pass; point calls -5.46%, real DS point interval -6.50%/-6.52%, whole 56.886M/242.567M (-.2060%/-.1183% vs B16); ITCM -320B, data/frame unchanged; A12 still faster, 1.7x unmet |
| Rejected encoder | normalize raw Q32 through a double residual and two floats | host random tests find low-component double-rounding differences; never put in candidate source |
| B18 | cache the represented immutable inverse once in existing rt3; same exact product/encoder macro, changing DS work and Babai policy unchanged | 560 cached products/source words/guards pass; all eleven fresh gates and same-ELF repeat pass; preparation-inclusive large point -31.10%/-31.65%, repeated whole 56.397M/241.332M (-.8608%/-.5089% vs B17); ITCM -652B, DTCM unchanged; A12 still faster, 1.7x unmet |
| Rejected initial decoder | ordinary MVE multiply for subnormal input scaling | fails frozen scalar comparison; diagnostic separates scalar/vector semantics; retained invalid logs, replaced by fixed-count exponent/mantissa handling |

The arithmetic combination is explicitly HYBRID, not a claim that every
operation uses floating point. Avoiding array conversions does not remove
the cost of coefficient-wise Q32 normalization.

Kernel arithmetic order is not changed by hiding work outside the timing
interval: the paired kernel test reports both native transform and inclusive
Q32 input/output cost. Integration keygen includes ALL surrounding work.

All 11 local PDF texts/OCR were read; `reading_log.md` distinguishes inspected
image pages and unreliable OCR. Plantard/modular and binary-field products do
not implement real Q32 arithmetic and are not transplanted. M55 FP add/mul
pipe sharing and the eight-vector-register constraint limit benefits from
larger register tiles. Native FP64 and hybrid public-size cutoffs are tested
as alternatives, not assumed winners.
# A9 supplementary diagnostics (no production changes)

After the A9 source-matched full gates and whole repeat, five diagnostics
were completed: data/stack modulo32 sweep (2048 exact cases), identical
multiplier code at eight modulo32 offsets plus the production symbol
(2304 exact cases, identical minima), paired timers/IRQ and wider memory
placements (1152 exact cases), actual NTRU input replay (96 paired calls,
200 KAT/equation checks), and a combined profile/kernel-probe ELF (5120
raw cases, 200 KAT/equation checks). They narrow hypotheses but do not yet
establish the cause of the profile-versus-kernel timing discrepancy.
The diagnostics did not change A9/B14 sources. See validation/twiddle_results.md
for raw-run links, numbers, and why diagnostic totals are not speed claims.

## A10 direct butterfly fusion

The separate-call/tile hypothesis was subsequently implemented independently
of those attribution diagnostics. A10 removes the 3072-byte C tile and five
separate span operations in favor of one directly written butterfly loop;
its arithmetic scratch is 64 bytes. All original three-product truncations,
wraps and inverse stagewise halves remain intact. Full gates and the
same-ELF whole repeat pass. Changes from archived A9 are two implementation
files (kgen_fxp.c and kgen_fft_cm55.s) and one header comment; kgen_ntru.c,
candidate norm, NTT/CRT/Bezout, signing and B14 are unchanged.

Profile operation/call counts are identical. Intermediate FFT/iFFT time
falls 12.32%/11.21% for key512 and 13.19%/11.94% for key1024, but whole
keygen time falls only .55%/.33%. This is a real scoped improvement, not
evidence of reaching the 1.7x objective. Full results and provenance are in
validation/fusion_results.md. No build-selectable backend or SLOTHY was used.

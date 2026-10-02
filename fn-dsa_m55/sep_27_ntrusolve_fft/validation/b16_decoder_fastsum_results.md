# B16 decoder-specific shorter error-free sums

Status: direct implementation, isolated M55 decoder/point tests and all
eleven fresh full board gates pass. B15 is archived in source_snapshots.
Its KAT/performance evidence is not inherited. External references and A12
are untouched. No SLOTHY, cross-candidate crypto linking or backend switch.

## Change and correctness boundary

Only B's kgen_fft_cm55.s changes: three proven sites in DSD_DECODE_CORE
use shorter error-free sums. This affects its standalone decoder and four
inline instances in the point-product span, hence also reciprocal/real
division callers. The middle unordered sum and both residual additions
remain, as do subnormal scaling, raw integer extraction, carries and tie
correction. See [site-specific derivation and primary source](../research/decoder_fastsum_design.md).

The host grid checks 13,653,956 pairs with zero raw-result mismatches.
Fractional zero residual signs can differ; no nonzero intermediate value
or final raw output difference was observed. This is explicitly not a
claim that every intermediate bit stays identical. FFT precision, DS
storage and original work counts are unchanged.

## Isolated board evidence

Run [decoding/204247Z](results/B_continuous_ds/decoding/20260927T204247Z/manifest.json),
UTC 2026-09-27, compares the new macro against the frozen scalar oracle:

- 2,228,448 decoded values; 1,000,484 original raw Q32 products.
- 640 complex-product arrays including d==b; 320 inverses and 640 divisions.
- 48 point-span input-class checks, with untouched slots/guards included.
- All pass; zero fault registers and expected TCM/ECC state.

The 24 decoder input classes each have exactly 40459 cycles for 128 calls
in all 20 tested trials. Point-span timing maxima are equal to minima or
+1. Linked inspection has no data-dependent branch or indexed address in
the decoder; the point span branches only on public block count. Finite
tests and human inspection are NOT a full CT or physical-leakage proof.

## Micro performance vs archived B15

Compare decoding/203502Z (B15) and decoding/204247Z (B16). Same harness,
data and placement policy, but not all function addresses pinned. Calls,
representation boundaries and stores remain timed. Per-call minima below
include timer overhead, except the separately labeled 128-call row.

| Operation | n | B15 cycles | B16 cycles | time change |
| --- | ---: | ---: | ---: | ---: |
| decoder, 128 four-value calls | 4 | 42763 | 40459 | -5.3878% |
| complete point multiplication | 512 | 103015 | 98407 | -4.4731% |
| complete point multiplication | 1024 | 205927 | 196711 | -4.4754% |
| inverse norm/reciprocal | 512 | 354892 | 352588 | -0.6492% |
| inverse norm/reciprocal | 1024 | 709708 | 705100 | -0.6493% |
| real division | 512 | 354825 | 351369 | -0.9740% |
| real division | 1024 | 709577 | 702665 | -0.9741% |

This is not a whole-keygen speedup. B15 remains the archived comparator,
not the unchanged scalar oracle or the external M55_ref.

## Code and memory

Signature-test ELF: decoder size 682 ->646 bytes; point span 3640 ->3496.
Together this removes 180 ITCM bytes (end 0x1001e9c8 ->0x1001e914).
DTCM end stays 0x3003d428 including the 64-KiB reserved stack. Decoder
128-byte total frame and point 336-byte total frame are unchanged. No
new global workspace or table. Link fit/local frames are not a full
program worst-case stack or memory-safety proof.

## Full-source gates and whole measurements

First keygen run [204502Z](results/B_continuous_ds/keygen/20260927T204502Z/manifest.json)
passes all 200 keys/KAT/equations. Mean cycles are 57,003,810.45 /242,854,316.22
for 512/1024, down 0.11961%/0.06865% versus B15. M55_ref ratios are
1.10060x/1.07767x, including earlier NTT gains. Versus ntt_opt, 512 is still
0.09228% slower and 1024 is 0.12466% faster. A12 still leads both.
The 1.7x objective remains unmet. Do not treat the point kernel's ~4.5%
time reduction as a whole-keygen improvement of that size.

All run dates are UTC 2026-09-27. Every listed manifest is valid with zero
faults and expected TCM/ECC state. Gates match the edited source hashes.

| Gate | Run | Result |
| --- | --- | --- |
| encoding | [204354Z](results/B_continuous_ds/encoding/20260927T204354Z/manifest.json) | encoder/selector/full-input grids pass, including 5242880 fastsum edge words |
| fixed_input | [204408Z](results/B_continuous_ds/fixed_input/20260927T204408Z/manifest.json) | 220672 cases match |
| kat | [204415Z](results/B_continuous_ds/kat/20260927T204415Z/manifest.json) | 300 original KAT/NTRU equations pass |
| keygen | [204502Z](results/B_continuous_ds/keygen/20260927T204502Z/manifest.json) | 200 keys/KAT/equations pass |
| extra | [204547Z](results/B_continuous_ds/extra/20260927T204547Z/manifest.json) | 300 independent-seed KAT/equations pass |
| sigkat | [204632Z](results/B_continuous_ds/sigkat/20260927T204632Z/manifest.json) | 90 sign/verify/tamper cases pass |
| profile | [204642Z](results/B_continuous_ds/profile/20260927T204642Z/manifest.json) | 200 keys, consistent totals |
| kernel | [204728Z](results/B_continuous_ds/kernel/20260927T204728Z/manifest.json) | 640 bounded transform comparisons, zero rounded differences |
| rounding | [204731Z](results/B_continuous_ds/rounding/20260927T204731Z/manifest.json) | 1273664 values match |
| decoding | [204742Z](results/B_continuous_ds/decoding/20260927T204742Z/manifest.json) | repeats all isolated decoder/product/inverse/division grids |
| division | [204750Z](results/B_continuous_ds/division/20260927T204750Z/manifest.json) | 1018184 quotients match |

The unchanged DS FFT still has finite raw-Q32 error despite zero tested
rounded differences; this decoder change does not establish universal FFT
bit identity. Encoding tests' independent-versus-shared oracle distinction
remains as documented for B15. Finite CT, guards, KAT and equation checks
are not formal all-input equivalence, physical security or stack proofs.

## Actual integration profile

B15 profile/203402Z and B16 profile/204642Z have exactly the same operation
keys and call counts. Per-key cycles below include instrumentation.

| Interval | 512 B15 ->B16 | time change | 1024 B15 ->B16 | time change |
| --- | ---: | ---: | ---: | ---: |
| DS point products, logn>=4 | 1716126.45 ->1653650.05 | -3.6406% | 4252909.85 ->4097738.98 | -3.6486% |
| all intermediate point products | 1911619.80 ->1849143.42 | -3.2682% | 4794644.70 ->4639495.63 | -3.2359% |
| intermediate reciprocal | 480272.28 ->478039.39 | -0.4649% | 952533.91 ->947889.88 | -0.4875% |
| depth0 real division | 462792.07 ->459277.77 | -0.7594% | 925387.99 ->918315.93 | -0.7642% |
| all NTRU | 46326225.68 ->46257957.76 | -0.1474% | 190674497.42 ->190507785.57 | -0.0874% |

The other FFT/input/round/update intervals are nearly stable. The point,
reciprocal and depth0 division savings account for essentially all of the
whole-keygen change. Weighted real calls include smaller shapes and their
overheads, not just the synthetic n=512/1024 micro call. Profile totals do
not replace the plain whole-keygen means or prove the exact cause of every
small code-layout variation. B's point interval still greatly exceeds A's.

Same-ELF repeat [204831Z](results/B_continuous_ds/keygen/20260927T204831Z/manifest.json)
passes another 200 keys/KAT/equations. Means are **57,003,810.54 /242,854,316.45**
cycles: 0.09/0.23 cycles per key from the first run. This supports repeatability
on the common seeds, not an all-input CT or universal speed guarantee.
The current-source evidence checker verifies eleven A and eleven B gate
manifests, archived ELF/raw hashes and 63 unchanged external reference files.

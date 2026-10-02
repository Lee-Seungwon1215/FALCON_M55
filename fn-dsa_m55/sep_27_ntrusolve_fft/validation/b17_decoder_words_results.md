# B17 exact decoder word/constant/carry shortening

Status: implementation, isolated board tests and all eleven fresh source-matched
gates pass. B16 is archived; its passes were not inherited. A12 and
external reference trees remain unchanged. No production ref replacement.

## Change

Only B_continuous_ds/kgen_fft_cm55.s changes. Shorten exact exponent
extraction, use scalar-operand vector subtraction, materialize two identical
constant bit patterns directly and predicate two lane-local carry adds.
Sixteen instructions per decoder are removed. FP operation order, gradual
subnormal handling, floor/residual tie rule, output representation and
NTRU work counts remain. [Derivation](../research/decoder_words_design.md).

## Isolated source-matched M55 checks

[decoding/205320Z](results/B_continuous_ds/decoding/20260927T205320Z/manifest.json),
UTC 2026-09-27: 2,228,448 decoded values; 1,000,484 raw products; 640 complex
products including d==b; 320 inverses; 640 divisions; 48 span-class checks
all pass. Faults are zero and expected TCM/ECC state is confirmed.

Across 24 decoder classes x20 trials, 128 calls take exactly 37771 cycles.
At 32 point-span calls, minima are 49472 (n=8) and 2978720 (n=512), with
equal or +1 maxima. No data-dependent branch is introduced: standalone
decoder only returns, and the span retains its public block-count loop.
Human disassembly inspection and finite timing are not formal CT/security.

## Micro comparison with B16

Compare archived B16 decoding/204742Z against B17 decoding/205320Z. Same
harness, inputs and placement policy; not all function addresses pinned.
Each complete operation includes calls, conversions and stores. Per-call
minimum cycles include timer overhead, except the labeled 128-call row.

| Operation | n | B16 cycles | B17 cycles | time change |
| --- | ---: | ---: | ---: | ---: |
| decoder, 128 four-value calls | 4 | 40459 | 37771 | -6.6438% |
| point multiplication | 512 | 98407 | 93031 | -5.4630% |
| point multiplication | 1024 | 196711 | 185959 | -5.4659% |
| reciprocal/inverse norm | 512 | 352588 | 349900 | -0.7624% |
| reciprocal/inverse norm | 1024 | 705100 | 699724 | -0.7624% |
| real division | 512 | 351369 | 347337 | -1.1475% |
| real division | 1024 | 702665 | 694601 | -1.1476% |

These are not whole-keygen speedups and do not establish the 1.7x target.

## Linked code and memory

Signature-test decoder is 646 ->582 bytes; point span 3496 ->3240 bytes.
ITCM end 0x1001e914 ->0x1001e7d4 (-320 bytes). DTCM end stays 0x3003d428
including the 64-KiB stack reservation. Decoder/point total frames remain
128/336 bytes. No extra global table or workspace. Link fit and local
frames are not whole-program worst-case stack or memory-safety proofs.

## Full gates / whole performance

Original KAT [205449Z](results/B_continuous_ds/kat/20260927T205449Z/manifest.json)
passes 300 cases. First whole run
[205536Z](results/B_continuous_ds/keygen/20260927T205536Z/manifest.json)
passes 200 keys/KAT/equations; mean cycles are 56,886,404.81 /242,566,913.19
for 512/1024. Time decreases 0.20596%/0.11834% versus B16. M55_ref ratios
are 1.10287x/1.07895x, including prior NTT gains. Versus ntt_opt, time is
0.11387%/0.24285% lower. A12 remains faster at both sizes; 1.7x is unmet.

All run dates below are UTC 2026-09-27. Each manifest is valid with zero
faults, required TCM/ECC state and matching current-source hashes.

| Gate | Run | Result |
| --- | --- | --- |
| encoding | [205428Z](results/B_continuous_ds/encoding/20260927T205428Z/manifest.json) | original encoder/selector/full-input grids pass |
| fixed_input | [205442Z](results/B_continuous_ds/fixed_input/20260927T205442Z/manifest.json) | 220672 raw input cases match |
| kat | [205449Z](results/B_continuous_ds/kat/20260927T205449Z/manifest.json) | 300 original KAT/equations pass |
| keygen | [205536Z](results/B_continuous_ds/keygen/20260927T205536Z/manifest.json) | 200 keys/KAT/equations pass |
| extra | [205621Z](results/B_continuous_ds/extra/20260927T205621Z/manifest.json) | 300 independent-seed KAT/equations pass |
| sigkat | [205706Z](results/B_continuous_ds/sigkat/20260927T205706Z/manifest.json) | 90 sign/verify/tamper cases pass |
| profile | [205716Z](results/B_continuous_ds/profile/20260927T205716Z/manifest.json) | 200 keys, consistent interval totals |
| kernel | [205802Z](results/B_continuous_ds/kernel/20260927T205802Z/manifest.json) | 640 bounded transform comparisons, zero rounded differences |
| rounding | [205805Z](results/B_continuous_ds/rounding/20260927T205805Z/manifest.json) | 1273664 values match |
| decoding | [205816Z](results/B_continuous_ds/decoding/20260927T205816Z/manifest.json) | repeats raw decoder/product/inverse/division grids |
| division | [205824Z](results/B_continuous_ds/division/20260927T205824Z/manifest.json) | 1018184 quotients match |

Same-ELF whole repeat [205914Z](results/B_continuous_ds/keygen/20260927T205914Z/manifest.json)
passes another 200 KAT/equations and gives **56,886,405.00 /242,566,913.16**
mean cycles. The first/repeat means differ by 0.19/0.03 cycles per key.
This is repeatability on common inputs, not universal speed/CT proof.

The unchanged DS FFT can still differ in raw Q32 units while its tested
rounded values agree; decoder output equality is not misrepresented as
universal FFT bit identity. The encoding harness's independent/shared-oracle
distinction remains as documented for B15. All finite-test/CT/stack limits
from validation_limits.md remain. Evidence checking covers eleven A and
eleven B current gates plus 63 unchanged external reference files.

## Real NTRU profile attribution

B16 profile/204642Z and B17 profile/205716Z have identical operation keys
and call counts. Per-key cycles below include hooks, unlike plain keygen.

| Interval | 512 B16 ->B17 | time change | 1024 B16 ->B17 | time change |
| --- | ---: | ---: | ---: | ---: |
| DS point products, logn>=4 | 1653650.05 ->1546149.02 | -6.5008% | 4097738.98 ->3830453.51 | -6.5228% |
| all intermediate point products | 1849143.42 ->1741642.37 | -5.8136% | 4639495.63 ->4372188.33 | -5.7616% |
| intermediate reciprocal | 478039.39 ->474078.06 | -0.8287% | 947889.88 ->939924.58 | -0.8403% |
| depth0 real division | 459277.77 ->453174.12 | -1.3290% | 918315.93 ->906206.51 | -1.3187% |
| NTRU total | 46257957.76 ->46140457.02 | -0.2540% | 190507785.57 ->190220381.00 | -0.1509% |

Input/FFT/iFFT/round/update costs are nearly unchanged. The three affected
intervals account for essentially all of the whole-keygen decrease.
The weighted real interval covers different public sizes/caller contexts
than the n=512/1024 isolated calls; do not replace either measurement by
the other or claim all code addresses are pinned. A12 is still the best
tested whole implementation, and the target remains incomplete.

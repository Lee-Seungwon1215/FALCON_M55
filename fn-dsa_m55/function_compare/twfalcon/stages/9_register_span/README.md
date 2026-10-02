# Stage 9: register-result double-single spans

Complete independent assembly snapshot matching `tw32_mve/` and the local
`integration_candidate/`. No precision reduction or new approximation was
introduced in this stage. The non-span tail functions are unchanged.

## Register/data flow

- q0..q3: arithmetic workspace.
- q4/q5: only the current twiddle hi/lo, reloaded for each real product.
- q6/q7: preceding real product or the complex component being consumed.
- r0..r3 and r4..r7: high/low coefficient plane pointers.
- r8/r10: public twiddle addresses; r9: public block count.

`DS_MUL_REG` returns hi/lo in q0/q3. `DS_COMBINE_PRODUCTS` consumes these
and the preceding q6/q7 product without a stack round trip. The leading
TwoSum, FMA residual and low-component accumulation order remain unchanged.

Forward retains only its real component on the private stack while computing
the imaginary component. Both components are written directly to the arrays
after all old y values have been consumed. Inverse saves both differences
before overwriting x with sums, then immediately consumes each product pair.

| Per four-butterfly block | Stage 7 | Stage 8 | Stage 9 FFT | Stage 9 iFFT |
| --- | ---: | ---: | ---: | ---: |
| Vector load/store | 84 | 52 | 36 | 44 |
| Private scratch accesses | 68 | 28 | 4 | 12 |
| Twiddle accesses inside loop | 0 | 0 | 8 | 8 |
| Coefficient accesses | 16 | 24 | 24 | 24 |
| Private scratch frame, bytes | 320 | 128 | 32 | 64 |

Twiddles are on the caller stack in the current C control, so actual
stack-addressed vector accesses inside the loop are 12/20, not just 4/12.
All columns exclude the ABI save/restore; stages 7/8 also preload four
twiddle vectors once per span outside the loop. FP arithmetic instruction
counts are unchanged. `tools/audit_span.py` checks the linked instructions.

Final same-image comparison: `results/20260924T141800Z/raw.log` and
`kernel_summary.json` (relative to the experiment root). Stage 9 reduces
complete core cycles by 13.03--15.25% versus the stage-7 baseline, and by
1.45--2.98% versus stage 8 in this layout. A 64-block inverse span is 0.51%
slower than stage 8, so fewer memory instructions are not a universal
speedup guarantee. No per-size dispatch was introduced for that tiny case.

This is an improved experimental candidate, not a replacement for M55_ref:
the Q32 core is still faster. See the root `result.md` for validation and
the exact boundary of the timing and constant-time claims.

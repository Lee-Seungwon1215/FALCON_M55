# Stage 8: direct-array double-single spans

Preserved first experiment for the 84-vector-access butterfly loop.
`tw32_primitives_cm55.s` is a complete independent assembly snapshot; the
FFT C control is unchanged from stage 7. There is no production build switch
or link-time redirection to this directory.

- `ds32_bfly_fwd4_span` and `ds32_bfly_inv4_span` read/write the SoA planes
  directly, with the original FP32 arithmetic and normalization order.
- Per four-butterfly block: 84 -> 52 vector memory instructions;
  private scratch accesses: 68 -> 28. Coefficient accesses: 16 -> 24.
- Scratch frame: 320 -> 128 bytes, excluding 96 bytes of ABI saves.
- The non-span small-layer functions remain unchanged.

The first board run passed 1,408 bitwise span comparisons and retained the
stage-7 error maxima: `results/20260924T141000Z/raw.log` (relative to the
experiment root). The final side-by-side run also benchmarks this candidate:
`results/20260924T141800Z/raw.log`, fields `direct_sum` and `ds_stage8`.

Stage 9 is faster for complete 512/1024 transforms in that comparison and is
the current experimental implementation. Stage 8 is retained as a readable
intermediate result, not claimed as a full-KAT-tested integration candidate.

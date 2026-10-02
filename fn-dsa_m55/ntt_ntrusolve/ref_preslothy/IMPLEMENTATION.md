# D1 implementation and review

## 1. Source and scope

Only `kgen_mp31_cm55.s` differs among the 31 top-level C/H/S files.
The reduction, add/subtract, CT, GS, inverse-root restoration and final-root
macros are byte-for-byte identical to D0. Arithmetic remains exact modulo
each 31-bit RNS prime, using four 32-bit MVE lanes. There is no FP64 conversion.

D0 already contained final VLD4 loads. D1 therefore implements the complementary
producer-store transpose for forward NTT; folder names are retained, not used as
an implementation specification. See the parent README for citations.

## 2. Four-by-four identity

For four vectors Q[i][j], with i,j in 0..3:

- plain store: memory[4*i+j] = Q[i][j].
- VST4 store: memory[4*j+i] = Q[i][j].
- plain load and VLD4 load are the corresponding row and column reads.

Consequently:

```text
VLD4(plain_store(Q)) == plain_load(VST4(Q))
plain_load(VST4(Q)) == VLD4(plain_store(Q))
```

The first identity moves the forward transpose to the previous store.
The second moves the inverse transpose to the following load. Both are local
16-word tile identities; no global or externally visible permutation changes.
Host tests check these identities on 2,000 random 31-bit tiles in total,
plus the external ordering and full-array tile partitions.

## 3. Forward NTT

- `.Lntt_two_check` selects the t=16 penultimate CT2 using a public stride.
- `.Lntt_penultimate` uses `MP31_CT2_TRANSPOSE_STORE`: four ordinary loads,
  the unchanged CT2 arithmetic, then four VST4 instructions.
- Each group is exactly one 64-byte tile. No inner loop/end-pointer setup is
  needed. The loop then advances the data pointer by 64 and the root pointer by 4.
- `.Lntt_last_loop` uses four plain vector loads. Its arithmetic and final
  VST4 stores retain the original output order.
- The small logn=4/6 path uses `.Lsmall_penultimate` and
  `.Lsmall_last_loop` with the same mapping. logn=5 rejoins the regular path.
- Larger-stride CT2 passes are unchanged; odd-size first single CT layer remains.

This experiment measures the complete boundary implementation, including its
specialized loop control; it is NOT an isolated latency comparison of one
VST4 instruction against one VLD4 instruction.

## 4. Inverse NTT

- `.Lintt_first_loop` keeps its VLD4 input and arithmetic; four plain stores
  leave the result locally transposed.
- At public t=4 coefficients (16 bytes), `.Lintt_second` reads each tile with
  VLD4, performs the unchanged GS2 arithmetic and stores ordinary order.
- logn=4 has no intermediate GS2: `.Lintt_final_two` performs its one VLD4
  tile load and joins the unchanged final-scaling arithmetic.
- All later GS2 layers and the final odd single layer retain ordinary ordering.
- No additional 1/n pass or half-scaled table is created; H1 scaling is preserved.

## 5. Safety and constant-time review

- Every branch depends only on public logn, layer/stride, or a public loop count.
  Coefficients never determine a scalar branch or a load/store address.
- Gather offsets still use the fixed table {0,8,16,24}; roots depend on public indices.
- Coefficient-dependent VPT/VADDT predicates are inherited unchanged. No early
  termination or data-dependent table addressing has been introduced.
- The regular prologue still saves 112 bytes; the small path saves 104 bytes.
  No new coefficient stack spills, heap objects, scratch buffers or tables.
- The explicit r6/logn=4 inverse dispatch is required because that tile goes
  directly into the scaled final-two kernel.
- The old small-helper padding was removed from D1; it did not execute.
- Disassembly checks cover all three kernel symbols, reject new division/FP
  instructions and BL/BLX calls, and record every branch for manual inspection.

This is a source/disassembly review of the changed kernels, not a proof that the
entire FN-DSA implementation is constant-time. No dudect/TVLA or power/EM leakage
experiment was performed. Board coefficient equality is finite test coverage,
not an exhaustive proof over every possible polynomial.

## 6. Measurement controls

D1 builds only its own complete source tree with the pinned common board harness.
D0's control is a complete copy with unreachable post-return padding. Every
allocated section has the same address and size; all bytes outside the three
kernel slots match. In particular signing, verification, q-NTT, constants,
data and stacks are held in place. The original D0 source is not modified.

API timing is separate from audit firmware: audit enables the C oracle and
Montgomery probe, while perf disables both. Both use GCC 15.2.1, -O3,
the same Nucleo configuration and identical deterministic inputs.
Raw logs, 31 source files, ELF/map/config and build manifests are archived
per validated run. See result.md for the actual measured outcome.

# A14: bounded root components and shorter packed-stage lifetimes

This succeeds A13 in A's own `kgen_fft_cm55.s`. The C stage loops, numerical
representation, fixed/FP thresholds, original roots and NTRU work policy
are unchanged. It is an integer-MVE optimization of the fixed part of A's
hybrid, not a native-FP64 rewrite. B18 is untouched. No SLOTHY or build/backend
selector is introduced.

## Two separately tested changes

1. Use the actual root-component bound to shorten ONLY z0 and z1 products.
   Leave summed-root z2 on the original general signed Q32 multiplier.
2. Compute independent z2 first, reuse its temporary slot, and keep z0 in
   q6/q7 while z1 is computed. Every product still truncates separately;
   the output remains z0-z1 and z2-(z0+z1), with original wrap semantics.

The component-only source/ELF is archived as A14_component_trial and was
tested before the lifetime change. It has isolated evidence, not the full
final-source KAT/performance suite. Both variants directly edit own assembly;
they are not runtime-selected or selected by production build definitions.

## Bound checked against the actual table

For every GM_TAB root used at logn<=10, each real/imaginary component (also
after conjugation) has high32 exactly 0 or 0xffffffff. The table contains
special unused indices0/1 outside the component contract; they must NOT be
passed to this private helper. The host check parses the CURRENT production
table, verifies exact equality to the frozen test fixture, and enumerates
all511 used roots, both directions and components. No secret coefficient
range assumption is needed: x may be ANY signed64 raw value.

## Exact component identity

Let root = root.low + root.high*2^32, with signed root.high in {0,-1}.
Then, modulo the original64-bit Q32 result:

    floor(x*root/2^32) = floor(x*unsigned(root.low)/2^32) + x*root.high

Write x=x.low+signed(x.high)*2^32. The first term is the unsigned high32
product x.low*root.low plus the signed64 cross-product x.high*root.low.
To use signed VMULH on the unsigned root.low, add x.high to its high result
when root.low's top bit is set. Add the low cross-product, propagating the
per-lane carry. Finally subtract the pair x & root.high: high0 subtracts
zero, high-1 subtracts x. Original borrow/wrap behavior is retained.

`NQT_MUL_COMPONENT` needs17 instructions including predicate setup versus22
for the general macro. It consumes input q2/q3 and preserves q6/q7, enabling
the second change. It has no data-dependent branch. Summed roots may have
high values outside {0,-1}; their multiplication is deliberately NOT replaced.
This bound/identity comes from the source, not a borrowed FP approximation
or modular-reduction formula. Prior reading/design motivation is recorded
in packed_tail_design.md and twiddle_multiply_design.md.

## Lifetime layout

| Private bytes | Lifetime |
| --- | --- |
| 0..63 | Prepared y.real/y.imag, then final complex result |
| 64..127 | Original component root words |
| 128..159 | y.real+y.imag, then z2 |
| q6/q7 | z0 while z1 is computed, then real=z0-z1 |

The root sum is consumed directly by the generic multiplication rather than
stored. Computing z2 before z0/z1 changes only order among independent exact
integer products, not their operands/truncation points. The former z0/z1
stack slots are gone. The frame shrinks from360 to264 bytes:36 GPR saves,
64 extended saves,160 scratch and4 padding. The input/output gather mapping
and inverse stagewise rounded half remain A13's exact rule.

## Required evidence

- Host word model versus arbitrary-precision signed product: all table-root
  edge cases and1M random full-width coefficient/bounded-root cases.
- Board instance of the EXACT production macro:1,001,024 products against
  original fxr_mul, output guards/unused slots and immutable roots;32 operand
  timing classes x20 trials. The helper is unused/GC'd in whole-keygen links.
- Unchanged complete fixed_fft harness:5120 original raw-word transforms,
  logn1..10, both directions, all used roots and four offsets/guards.
- Fresh full KAT, independent seeds, equations, sign/verify/tamper, inputs,
  division, floating bridge kernels, profile and repeated whole keygen.
- Recheck linked controls, memory fit, source/ELF hashes and untouched refs.

Finite tests and algebraic source reasoning are not a formal machine-code
equivalence/CT proof or a worst-case stack/physical-leakage guarantee. The
1.7x whole-keygen requirement remains independent of these local gains.

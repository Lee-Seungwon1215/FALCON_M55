# A15 trial: keep packed butterfly outputs in registers

The first isolated variant directly edits A's own kgen_fft_cm55.s after the
archived A14. It changes no C wrapper, threshold, root table, multiplication,
half, NTRU work count, build/backend selection or B source. No SLOTHY.
It is separately archived as A15_direct_finish_trial after a passing
5120-case raw FFT run215459Z, before the additional public cutoff experiment.

At the end of the A14 three-product combination, q6/q7 already contain
the real output and q4/q5 the imaginary output. A14 stored these four
vectors to scratch, then reloaded them in NQT_FINISH. A15 removes those
eight stack accesses, without modifying arithmetic or external addresses.

Inverse: load the public offset map into now-dead q2, scatter q6/q7 to
y.real and q4/q5 to y.imag. The preceding inverse preparation has already
stored x=(x+y)/2, and the multiplied difference retains the original half.

Forward: q3 holds the public map only until the x.real gather. That gather
loads q0/q1; q2/q3 then receive x.real+product.real while q0/q1 receive
the difference. The old real product in q6/q7 is now dead, so q7 can be
reloaded with the map. Store sum/difference and repeat for x.imag using
the still-live imaginary product q4/q5. Carries/borrows stay lane-local.
NBF_ADD's carry operand is never aliased with its low destination.

The inverse removes eight vector memory instructions per four butterflies;
forward removes seven net (one extra map load). The scratch/frame maxima
remain160/264 bytes because earlier products still need all five slots.
The map is selected only by public ht=1/2; no predicated memory or secret
index/control is introduced. Rootmul's production multiplier is unchanged.

This is local register-lifetime analysis inspired by the prior scheduling
and fusion work documented in packed_root_lifetime_design.md, not a new
FP approximation or a borrowed modular arithmetic identity.

Before adoption: unchanged raw fixed_fft test for all logn1..10, both
directions and offsets/guards, full fresh KAT/equations/signatures/input
and arithmetic gates, linked instruction/memory audit, profile call-count
comparison, plain whole keygen and same-ELF repeat. A14's passes cannot
be inherited. Neither a local cycle reduction nor finite test success
proves the1.7x whole-keygen goal or universal CT/equivalence.

## Separate public cutoff experiment

The original forward fallback threshold logn<5 predates packed short stages.
For n=16, hn=8: the long stage has ht=4 and the two short stages ht=2/1.
Each short stage contains exactly four butterflies, satisfying the helper's
no-partial-block contract. Existing inverse n=16 already uses that path.
The second variant changes only the forward threshold to logn<4, on top of
the direct finish. It never dispatches by coefficient/secret data; n<=8 is
unchanged. This must be measured independently from the first change.

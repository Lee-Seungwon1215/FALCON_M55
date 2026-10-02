# A16 experiments: public short-stage memory layout

Base: archived A15_live_outputs_n16, with all original Q32 products/halves.
Only own kgen_fft_cm55.s is edited. No SLOTHY, external source linking,
precision change, NTRU policy change or secret-dependent dispatch.

## First isolated variant: ht=1 root deinterleaving

The four roots for ht=1 are contiguous fxc objects, each containing
real.low, real.high, imag.low, imag.high. A complete VLD40/41/42/43.32
sequence yields those four fields in q0/q1/q2/q3. This reads exactly the
same64 bytes as the original four gathers, without the map load and
four scalar base-address additions. Inverse negation retains the exact
per-lane64-bit borrow and wrap. The same four root vectors are then saved
to the original scratch slots; complex multiplication is unchanged.

For ht=2, only two roots are read and duplicated into lanes by the original
gather map. Reading four roots there would broaden memory access and does
not implement the required duplication, so it is NOT done.

Public ht dispatch is moved outside the block loop. Each direction gets
separate ht=1 and ht=2 assembly macro instances; no per-block branch or
build flag selects a backend. This increases code size, so benefit must
be assessed together with linked ITCM fit, not only instruction counts.
Root increment remains64/32 bytes for ht=1/2. All coefficient access,
private scratch/frame peak, root constants and C thresholds remain A15.

This applies the public deinterleaving-layout idea already used in own
mq_cm55.s to 32-bit Q32 fields, not its q=12289 modular arithmetic. Earlier
paper coverage/motivation is recorded in packed_tail_design.md and the
research reading log. Arithmetic correctness follows the source layout;
new board raw/KAT/timing evidence is still required.

## Second isolated variant: ht=1 coefficient access

At ht=1, adjacent coefficient pairs likewise form x.low,x.high,y.low,y.high
groups. A complete VLD4 loads x/y for inverse preparation. Original sum,
difference, rounded halves and scatter of the sum remain unchanged.
Forward keeps its x gathers, but computes independent difference into
q2/q3 first, then sum in-place into q0/q1. A complete VST4 stores the whole
eight-coefficient block. The imaginary component repeats the same operation
after the real product dies. Both original expressions keep wrap semantics.
ht=2 has a different required lane order and keeps its existing gather map.
No store occurs before both operands are loaded, and no next-block value
is overwritten. All64 bytes of each component block are valid at hn>=8.

The first/root-only variant was independently tested with5120 raw transform
cases in run220756Z and archived as A16_root_layout_trial. The second adds
only these coefficient-access changes; no broader correctness or speed
claim is inherited. Avoid assuming all memory instructions have equal cost
or that fewer source instructions necessarily win on the board.

Every adopted variant needs complete raw transforms at all logn1..10,
offset/guard tests, current-source original/extra KAT, equations, signatures,
boundaries, division, linked control/memory review, connected profiles and
plain/repeated whole keygen. Finite tests are not universal CT/equivalence.

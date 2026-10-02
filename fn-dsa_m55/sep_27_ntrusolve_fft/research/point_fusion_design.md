# B11: fused DS boundaries and exact Q32 point product

## Evidence selecting this work

B10's intermediate point-product interval is 2.221M/5.564M cycles per
whole key (512/1024), versus A8's fixed-array 0.451M/1.168M. These are
profile intervals, not identical isolated inputs; the gap motivates studying
B's representation/call costs, not assuming an achievable speed ratio.
The existing B10 wrapper decodes four operands, computes three scalar Q32
products per complex coefficient, then encodes two results. Its four-lane
tile lives in a C stack array and crosses six helper calls per block.

## Implementation, not an approximate algebraic rewrite

The new `fndsa_ds_mul_span` owns a single assembly frame and public-count
loop. It preserves original scalar fallback for logn<3. For each four
complex coefficients, all four inputs are decoded before any destination
store, supporting d==b. The existing exact decoder/encoder instruction
bodies are factored into local assembler macros and used both by their
public entry points and this span. No external candidate source or backend
build switch is used; no SLOTHY.

Decode -> raw Q32 words -> original three products -> encode stays inside
the block. Polynomials remain two-FP32 components per real/imaginary scalar.
The transient integer arithmetic is deliberate; it is NOT a native-FP32
complex multiply claim or an assertion that all integer work vanished.

Let B=2^32, x=xL+B*xH and y=yL+B*yH with signed upper words. The exact Q32
product modulo B^2 is

    floor(xL*yL/B) + xH*yL + xL*yH + B*xH*yH (mod B^2).

`DSP_Q32_MUL` first uses unsigned VMUL/VMULH to accumulate the middle and
upper 32-bit words. Each middle-word addition has its own lane-local carry.
For signed upper words, subtract yL from the result's high word if xH is
negative, and subtract xL if yH is negative. Predicates/masks, not branches,
perform these corrections. No saturating/rounded multiplication and no
cross-coefficient carry chain is used.

For the complex operation, keep the exact existing `fxc_mul` sequence:
z0=ar*br, z1=ai*bi, z2=(ar+ai)*(br+bi), result=(z0-z1,z2-(z0+z1)). The sums
wrap as original uint64 and each product truncates separately. Replacing
the imaginary expression by ar*bi+ai*br would not preserve Q32 semantics.

## Register/memory plan

- Product inputs: q0/q1 x low/high, q2/q3 y low/high.
- Product outputs: q4/q5 low/high; q6 temporary; r12=1 for lane carries.
- 256-byte private scratch: 64 decoder, 128 four decoded operands, 64 z2/z0.
- Reuse decoded input slots for the two result-word pairs before encoding.
- Save r4-r6/lr (16 bytes), d8-d15 (64 bytes): total span frame 336 bytes.
- Linked C wrapper has a 128-byte frame but restores it before tail-jumping
  to the span, so these two frames are not simultaneously live on that path.
- Layout assertions bind 2048-byte component stride and 4096-byte imaginary
  offset to fndsa_ds_poly. Public hn is divisible by four on the vector path.

The span has only its public block loop branch; addresses depend on public
strides and block counts. This source/assembly review and finite timings
are not a formal CT, all-input FP error or worst-case full-stack proof.

## Sources and scope of their support

- Frozen `baseline_ntt/kgen_inner.h`, fxr_mul/fxc_mul: authoritative arithmetic
  contract and scalar inline-assembly comparison, including truncation order.
- [Arm MVE ACLE](https://arm-software.github.io/acle/mve_intrinsics/mve.html):
  unsigned high-product VMULH.U32, vector add/sub, compare/predication and
  load/store instruction forms. This documents available operations; the
  multiword formula/register allocation above is our derived implementation.
- `REFERENCE/TWfalcon.pdf` p.18 and `m55_ntt-ftt_opt.pdf` pp.13–22, already
  read in this project's reading log: combining caller interfaces and
  controlling register/stack pressure motivates fusion. Neither paper proves
  this two-component keygen Q32 implementation or its KAT equivalence.

Raw product tests, complete point-function tests, KAT and paired board
cycles decide adoption. A local improvement does not establish the 1.7x
whole-keygen target or authorize NTT/CRT/Bezout/iteration-policy changes.

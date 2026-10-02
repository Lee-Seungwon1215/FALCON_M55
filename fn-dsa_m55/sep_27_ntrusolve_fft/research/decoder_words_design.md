# B17: exact decoder instruction shortening

Previous goal turn: progress, B16 fully validated. This successor stays
inside B's existing DS-to-Q32 boundary. It does not change NTRU iterations,
integer updates, FFT precision, the DS polynomial layout or the 1.7x goal.
No SLOTHY, cross-candidate linking or production backend selection.

## Exact substitutions in own kgen_fft_cm55.s

1. Exponent extraction. For a 32-bit word u,

       (u >> 23) & 255 == ((u << 1) mod 2^32) >> 24.

   Two logical vector shifts replace shift/mask-constant/broadcast/AND.
   The original subtract-150 and subtract-32 are unchanged modulo-32-bit
   arithmetic; MVE's scalar-operand vector subtraction replaces broadcasting
   those constants. The sign mask, mantissa, VSHL counts and two's-complement
   carry are unchanged. Each integral-word conversion loses four instructions.
2. Scaling setup. Immediate VMOV bit patterns 0x05000000 and 0x10000000
   replace MOVW/MOVT/VDUP sequences. The former is the same normal FP32
   2^-117 used for an exact converted subnormal mantissa; the latter is the
   same exponent-field increment. VMUL, selection and sign restoration
   are unchanged. Each scale helper loses three instructions. This is NOT
   the rejected direct MVE multiply on a subnormal operand.
3. Final carries. Original compare -> select all-ones/zero -> right-shift
   -> add is replaced by the same comparison -> predicate -> add scalar 1.
   No cross-lane carry instruction is used. True lanes add one, false lanes
   retain their original upper word. The sign extension of the fractional
   correction is retained. The two carries lose two instructions together.

There are two scales and two integral conversions per decoder, for sixteen
removed instructions. All substitutions are integer/bit identities, not a
new approximation from a paper. B16's separately documented error-free FP
sums remain unchanged. The only changed cryptographic source relative to
the archived B16 snapshot is kgen_fft_cm55.s.

## Register/control constraints

r12 is already volatile scratch, assigned before each scalar vector use.
Removed q6 broadcasts are dead before the remaining q6 uses. Each VPST block
contains only the carry add; the following load/store is unconditional.
Standalone output remains q2 high/q0 low; the fused point caller still
explicitly initializes its own scalar carry constant after decoding.
Entry ABI, stack frames, plane offsets, memory addresses and public-count
loops are unchanged. No key-dependent dispatch/table/index is introduced.

## Required evidence

The assembler and linked disassembly must confirm intended instructions;
the frozen scalar decoder checks raw words, including signed zero,
subnormal, integer-boundary, wide-exponent and carry cases. Full point,
inverse/division, aliasing, original/independent KAT, signature/tamper,
kernel and operand-class timing gates follow. Whole keygen includes actual
boundaries/calls/retries on common seeds, with a same-ELF repeat.

Instruction identities plus finite grids are not a formal all-input ARM
equivalence/constant-time proof, physical-leakage proof or worst-case stack
analysis. No target performance is claimed from instruction count alone.

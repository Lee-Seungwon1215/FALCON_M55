# A13: pack short Q32 FFT stages across roots

## Why this candidate

After A12, the intermediate forward FFT and iFFT still cost respectively
1.320M/1.449M cycles per key512 and 3.428M/3.847M per key1024 in the profile
build. A10's long-span butterfly handles ht>=4. The final two forward stages
and first two inverse stages (ht=2/1) still execute one scalar butterfly at
a time. Those stages exist at EVERY vectorized transform size; they are not
the same as the small transform fallback, which remains unchanged here.

`m55_ntt-ftt_opt.pdf` pp.18–19 were revisited for packing several short
butterflies and managing eight vector registers. `ARMv8_falcon.pdf` p.10
was revisited for final-subtransform memory layout. These are organizational
inspirations: their modular reduction or ARMv8-A FP64/32-register methods do
NOT establish Q32 equivalence or M55 performance. All 11 papers' earlier
full-reading record remains in reading_log.md; no claim they were all newly
reread for this change. This implementation is handwritten, no SLOTHY.

## Exact lane mapping

Each lane is one original complex butterfly, not one real/imaginary limb.
Original arrays retain interleaved 64-bit Q32 words per real or imaginary
coefficient; the real and imaginary arrays remain separate halves.

| Public stage | Four x indices within an 8-complex block | y offset | Root indices |
| --- | --- | --- | --- |
| ht=1 | 0,2,4,6 | +1 | 0,1,2,3 |
| ht=2 | 0,1,4,5 | +2 | 0,0,1,1 |

Gather/scatter byte offsets are index*8; high words use base+4. Root complex
constants occupy 16 bytes, so the root offsets are 0/16/32/48 or 0/0/16/16.
After four butterflies, both component pointers advance 64 bytes; root
pointer advances 64 or 32 bytes. The fixed table is 64 immutable bytes.
All indices, direction selection and loop bounds depend only on public size.
The helper requires hn>=8, a power of two, ht in {1,2}; no masked tail is
needed. Production forward logn>=5 and inverse logn>=4 satisfy that contract.

## Arithmetic preserved

For raw 64-bit X,Y with unsigned halves xL,xH,yL,yH, unsigned product bits
32..95 are accumulated from high32(xL*yL), xH*yL, xL*yH and low32(xH*yH)
in the high result word. Each middle-word addition propagates its lane-local
carry. Subtracting yL from the high result if X is signed-negative, and xL
if Y is signed-negative, yields bits 32..95 of the SIGNED 128-bit product.
Those sign corrections are masks, not data-dependent branches. This generic
four-lane primitive is written in A's own assembly and linked only from A.

The complex multiplication still has THREE separately truncated products:
z0=re*root.re, z1=im*root.im, z2=wrap(re+im)*wrap(root.re+root.im);
real=wrap(z0-z1), imag=wrap(z2-wrap(z0+z1)). No four-product or FMA substitute.
Inverse retains wrap64(x+1) then signed right shift at EACH original stage,
on both sum and difference BEFORE the complex product. Conjugation uses
exact 64-bit wrapping negation of the original root's imaginary component.

All coefficient arithmetic remains exact original fixed-point integer MVE
in this portion of A's hybrid. This is NOT a native-FP64 FFT claim. Depth0's
floating path, candidate norm and B's continuous-DS path are untouched.

## Scratch and alias lifetimes

The helper's fixed scratch layout, in bytes, is:

| Range | Value |
| --- | --- |
| 0..63 | prepared y.re/y.im; later final real/imag products |
| 64..127 | root real/imaginary lane words |
| 128..191 | wrapped y sum / root sum |
| 192..255 | z0 / z1 |

All scratch is private to one call; no full-array conversion or global mutable
work buffer. Real/imaginary input regions and x/y addresses are disjoint at
these public mappings. Inverse writes half(x+y) only after both corresponding
inputs are loaded; the stored y difference remains private until multiplied.
Later blocks do not overlap earlier output. Forward delays x loads until
the product exists, but no y store can affect another lane's x address.
The callee frame is 360 bytes: 36 GPR saves +64 extended saves +260 local
bytes (256 scratch and alignment padding). Full-program stack safety is not
proved by this local accounting.

## Verification and measurement

Frozen A12 source archive exists before edits. `fixed_fft` compares current
production wrappers against the unchanged original kernels for logn1..10,
both directions, 256 classes with four offsets/guards. Raw 64-bit words are
compared across entire output/unused buffers; not merely final rounded k.
Each of the first 16 classes has 20 timed repeats per transform/direction.
All original root indices are exercised by full transforms through logn10.
Fresh KAT/equations/independent seeds/signatures, full profile/whole timing,
existing input/division checks and linked control-flow review are required.
Finite raw tests and timing do not prove universal equivalence, formal CT,
power/EM security or worst-case memory safety. Same placement policy is not
all-address-pinned attribution. Target 1.7x remains a separate whole-keygen
criterion, never inferred directly from this kernel improvement.

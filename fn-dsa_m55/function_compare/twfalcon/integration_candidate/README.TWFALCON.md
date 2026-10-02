# TWFalcon key-generation integration candidate

This isolated tree tests the two-word FP32 (double-single) MVE FFT candidate.
Each real and imaginary component is represented as `hi + lo`; complete
four-lane butterflies are implemented directly in `tw32_primitives_cm55.s`.
The public `vect_FFT[_fp64]()` and `vect_iFFT[_fp64]()` symbols call
`tw32_bridge.c` directly.  The adopted native-FP64 invnorm and the surrounding
NTRU pipeline remain unchanged.

No linker redirection or build-option symbol substitution is used.  This tree
does not replace `ntt_opt`, `fft_keygen`, or `M55_ref`.

The assembly currently matches stage 10: stage-9 spans plus packed ht=1/2
gather/scatter kernels. Each small layer uses all four lanes across groups.
Stage 11 now reads checked-in preconverted roots from `tw32_gm_ds32.c`.
This removes the on-demand Q32 conversions and the 6 KiB temporary root array.
Public adapters still convert double arrays to/from two-word FP32 planes.
The table preserves the existing 12-byte assembly stride with a zero third
float; the arithmetic remains two-word FP32. No runtime table initialization.

The 2026-09-26 KST rerun passes keygen KAT 300/300 and signature/verify/tamper
90/90. Whole public functions now use 8.98--16.66% fewer cycles than the
preserved M55_ref-body fixed baseline, and 30.32--34.45% fewer than stage 10.
Integrated DTCM grows by 8 KiB net (the unused 16 KiB Q32 table is discarded),
leaving 15,320 bytes in the signature test image including its reserved stack.
See `../stages/11_precomputed_roots/README.md` for measurements and limits;
earlier Q32 intermediate differences are not erased by this change.

# F3u: unscheduled assembly control (not another algorithm)

The same independent sources and C/ASM boundaries as `fp64_loop_schedule`,
but `kgen_fp64_cm55.s` is the original GCC instruction order extracted from F3a.
This isolates Slothy reordering from the effect of moving C functions into an
assembly translation unit. It is a measurement control, not a new optimization.
The candidate build never imports another folder's implementation.

The original two-layer C implementation is validated in F3a; this control gets
full keygen+sign+verify+tamper and key/signature digest comparison on the board.
No separate 300-vector KAT is claimed for this control unless recorded.

Completed: 200-key whole-keygen run, signatures, verification, tamper rejection
and cross-candidate digest comparison passed. Actual helper/FFT/iFFT addresses
and sizes match F3b. See [result.md](result.md).

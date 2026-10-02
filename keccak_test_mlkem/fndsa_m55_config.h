#ifndef FNDSA_M55_CONFIG_H__
#define FNDSA_M55_CONFIG_H__

/* This final source tree has one backend: Cortex-M55, K4C RNS NTT,
 * S1B/S2B/S3A q-NTT and A17 FFT. No SLOTHY or candidate selection.
 * Keep these settings in the source, not in downstream build flags.
 * The CM4 name enables the upstream scalar assembly routines retained
 * on M55; it does not select a different CPU or q-NTT implementation.
 */
#if !defined(__ARM_ARCH_8M_MAIN__) || !defined(__ARM_FEATURE_MVE) \
    || ((__ARM_FEATURE_MVE & 3) != 3) || !defined(__ARM_FP) \
    || ((__ARM_FP & 8) == 0)
#error "This source tree requires Cortex-M55 with MVE-F and FP64 enabled"
#endif

#if defined(FNDSA_ASM_CORTEXM4) && FNDSA_ASM_CORTEXM4 != 1
#error "The retained scalar assembly is required by this M55 source tree"
#endif
#if defined(FNDSA_ASM_CORTEXM55) && FNDSA_ASM_CORTEXM55 != 1
#error "The M55 assembly backend is required"
#endif
#if defined(FNDSA_MVE_MP31) && FNDSA_MVE_MP31 != 1
#error "K4C requires full inverse roots and the MVE MP31 backend"
#endif
#ifndef FNDSA_ASM_CORTEXM4
#define FNDSA_ASM_CORTEXM4 1
#endif
#ifndef FNDSA_ASM_CORTEXM55
#define FNDSA_ASM_CORTEXM55 1
#endif
#ifndef FNDSA_MVE_MP31
#define FNDSA_MVE_MP31 1
#endif

#endif

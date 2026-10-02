/* Reuse established TEST helpers, not a cryptographic implementation.
 * The four functions under test and their tables are linked exclusively
 * from Final_code/Before_slothy. The C RNS oracle is its own fallback.
 */
#define FNDSA_MP31_SELFTEST 1
#define FNDSA_MP31_SIGNED_SELFTEST 1
#define mlk_test_main unused_original_benchmark_main
#include "../../fn-dsa_m55/ntt_ntrusolve/5th_slothy/measurement/app/benchmark.c"
#undef mlk_test_main

int mlk_test_main(int argc, char **argv)
{
    (void)argc; (void)argv;
    if (hardware_audit()) return 1;
    /* mq_cm55.s requires logn >= 2 (also true before this cleanup). */
    for (unsigned logn = 2; logn <= 10; logn++) {
        if (!ntt_exactness_test(logn)) return 2;
    }
    if (!mp31_exactness_test()) return 3;
    if (!mp31_boundary_test()) return 4;
    mp31_cycle_test();
    printf("FINAL_NTT_DONE failures=0 logn_mq=2..10 logn_mp31=4..10\n");
    return 0;
}

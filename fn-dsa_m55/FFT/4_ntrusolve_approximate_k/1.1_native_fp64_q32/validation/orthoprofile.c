/* Seeded whole-keygen and orthogonal-norm candidate-check profile. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "inner.h"
#include "kgen_inner.h"
#include "upstream_kat.h"
#include "ortho_profile.h"
#include <stm32n6xx.h>
static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)], pk[FNDSA_VRFY_KEY_SIZE(10)];
static uint8_t tmp[22*1024+31] __attribute__((aligned(32)));
static int8_t polys[4*1024];
static uint16_t h[1024], t[1024];
static int check_key(unsigned logn, unsigned index)
{
    size_t n = (size_t)1 << logn, off = 1;
    int8_t *f = polys, *g = f+n, *F = g+n, *G = F+n;
    unsigned bits = logn == 10 ? 5 : 6;
    off += trim_i8_decode(logn, sk+off, f, bits);
    off += trim_i8_decode(logn, sk+off, g, bits);
    off += trim_i8_decode(logn, sk+off, F, 8);
    if (off+64 != FNDSA_SIGN_KEY_SIZE(logn)) return 1;
    if (1+mqpoly_decode(logn, pk+1, h) != FNDSA_VRFY_KEY_SIZE(logn)) return 2;
    mqpoly_ext_to_int(logn, h);
    mqpoly_small_to_int(logn, F, t); mqpoly_int_to_ntt(logn, t);
    mqpoly_mul_ntt(logn, t, h); mqpoly_ntt_to_int(logn, t);
    if (!mqpoly_int_to_small(logn, t, G)) return 3;
    for (size_t u = 0; u < n; u ++) {
        int32_t s = 0;
        for (size_t j = 0; j <= u; j ++) s += f[j]*G[u-j]-g[j]*F[u-j];
        for (size_t j = u+1; j < n; j ++) s -= f[j]*G[n+u-j]-g[j]*F[n+u-j];
        if (s != (u == 0 ? 12289 : 0)) return 4;
    }
    sha256_context ctx;
    uint8_t actual[32], expected[32];
    sha256_init(&ctx); sha256_update(&ctx, polys, 4*n); sha256_close(&ctx, actual);
    hextobin(expected, 32, (logn == 9 ? KAT_KG512 : KAT_KG1024)[index]);
    unsigned match = memcmp(actual, expected, 32) == 0;
    printf("OPRO_KEY degree=%u index=%u match=%u equation=PASS actual=", 1u<<logn, index, match);
    for (unsigned j = 0; j < 32; j ++) printf("%02x", actual[j]);
    printf("\n");
    return match ? 0 : 5;
}
int mlk_test_main(int argc, char **argv)
{
    (void)argc; (void)argv;
    printf("OPRO_HW cpu=%u fpscr=%08x ccr=%08x tcm=%08x\n",
        (unsigned)SystemCoreClock, (unsigned)__get_FPSCR(), (unsigned)SCB->CCR,
        *(volatile unsigned *)0x56008008);
    if (SystemCoreClock != 800000000u || (SCB->CCR & 0x30000u)
        || *(volatile unsigned *)0x56008008 != 0x99u || (__get_FPSCR() & 0x1C00000u)) return 10;
    selftest_sha256();
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    __disable_irq();
    op_calibrate();
    for (unsigned logn = 9; logn <= 10; logn ++) {
        size_t tmplen = ((size_t)22 << logn)+31;
        if (!fndsa_keygen_seeded_temp(logn, "warmup-fp64", 11, sk, pk, tmp, tmplen)) return 11;
        op_reset();
        for (unsigned i = 0; i < 100; i ++) {
            char seed[32]; sprintf(seed, "test%u", i);
            size_t seed_len = strlen(seed);
            op_key_enter();
            int ok = fndsa_keygen_seeded_temp(logn, seed, seed_len, sk, pk, tmp, tmplen);
            op_key_leave();
            if (!ok) return 12;
            int error = check_key(logn, i);
            if (error) { printf("OPRO_ERROR degree=%u index=%u error=%d\n", 1u<<logn, i, error); return error; }
        }
        if (op_report(logn)) return 13;
    }
    printf("OPRO_DONE count=200 mismatches=0\n");
    __enable_irq();
    return 0;
}

// SPDX-License-Identifier: Apache-2.0 or CC0-1.0
#include "api.h"
#include "hal.h"
#include "randombytes.h"
#include "sendfn.h"

#include "sign_inner.h"
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define MLEN 59

// https://stackoverflow.com/a/1489985/1711232
#define PASTER(x, y) x##y
#define EVALUATOR(x, y) PASTER(x, y)
#define NAMESPACE(fun) EVALUATOR(MUPQ_NAMESPACE, fun)

// use different names so we can have empty namespaces
#define MUPQ_CRYPTO_PUBLICKEYBYTES NAMESPACE(CRYPTO_PUBLICKEYBYTES)
#define MUPQ_CRYPTO_SECRETKEYBYTES NAMESPACE(CRYPTO_SECRETKEYBYTES)
#define MUPQ_CRYPTO_BYTES NAMESPACE(CRYPTO_BYTES)
#define MUPQ_CRYPTO_ALGNAME NAMESPACE(CRYPTO_ALGNAME)

#define MUPQ_crypto_sign_keypair NAMESPACE(crypto_sign_keypair)
#define MUPQ_crypto_sign NAMESPACE(crypto_sign)
#define MUPQ_crypto_sign_open NAMESPACE(crypto_sign_open)
#define MUPQ_crypto_sign_signature NAMESPACE(crypto_sign_signature)
#define MUPQ_crypto_sign_verify NAMESPACE(crypto_sign_verify)

#define printcycles(S, U) send_unsignedll((S), (U))

#if FNDSA_SPEED
// algorithms so they can be called in assembly, because the actual algorithms are inlined
int64_t fpr_rint_speed(fpr x) {
    return fpr_rint(x);
}

int64_t fpr_floor_speed(fpr x) {
    return fpr_floor(x);
}

int64_t fpr_trunc_speed(fpr x) {
    return fpr_trunc(x);
}
#endif

/* Enable the cycle counter. */
static void
enable_cyccnt(void)
{
	volatile uint32_t *DWT_CONTROL = (volatile uint32_t *)0xE0001000;
	volatile uint32_t *DWT_CYCCNT = (volatile uint32_t *)0xE0001004;
	volatile uint32_t *DEMCR = (volatile uint32_t *)0xE000EDFC;
	volatile uint32_t *LAR  = (volatile uint32_t *)0xE0001FB0;

	*DEMCR = *DEMCR | 0x01000000;
	*LAR = 0xC5ACCE55;
	*DWT_CYCCNT = 0;
	*DWT_CONTROL = *DWT_CONTROL | 1;
}

#if FNDSA_SPEED
void bench_assembly() {
    hal_send_str("bench assembly functions:\n");
    enable_cyccnt();


    extern uint32_t bench_none(void);
    extern uint32_t bench_add(void);
    extern uint32_t bench_add_sub(void);
    extern uint32_t bench_mul(void);
    extern uint32_t bench_div(void);
    extern uint32_t bench_sqrt(void);

    extern uint32_t bench_scaled(void);
    extern uint32_t bench_rint(void);
    extern uint32_t bench_floor(void);
    extern uint32_t bench_trunc(void);

    extern uint32_t bench_tw_add(void);
    extern uint32_t bench_tw_prod(void);
    extern uint32_t bench_tw_div(void);
    extern uint32_t bench_tw_reci(void);
    extern uint32_t bench_tw_sqrt(void);

    extern uint32_t bench_tw_add_ct(void);
    extern uint32_t bench_tw_add_f_ct(void);
    extern uint32_t bench_tw_add_sub_ct(void);
    extern uint32_t bench_tw_prod_ct(void);
    extern uint32_t bench_tw_prod_f_ct(void);
    extern uint32_t bench_tw_div_ct(void);
    extern uint32_t bench_tw_reci_ct(void);
    extern uint32_t bench_tw_sqrt_ct(void);

    extern uint32_t bench_tw_fpr_of(void);
    extern uint32_t bench_tw_rint_ct(void);
    extern uint32_t bench_tw_floor_ct(void);
    extern uint32_t bench_tw_trunc_ct(void);
    extern uint32_t bench_tw_trunc_full_ct(void);


        /* bench_none() measures a function with inherent cost 2 cycles. */
    uint32_t cal = bench_none() - 2;
    char item[100];
    sprintf(item, "cal: %lu\n", cal);
    hal_send_str(item);

    sprintf(item, "fpr_add:      %5lu\n", bench_add() - cal);
    hal_send_str(item);
    sprintf(item, "fpr_add_sub:      %5lu\n", bench_add_sub() - cal);
    hal_send_str(item);
    sprintf(item, "fpr_mul:      %5lu\n", bench_mul() - cal);
    hal_send_str(item);
    sprintf(item, "fpr_div:      %5lu\n", bench_div() - cal);
    hal_send_str(item);
    sprintf(item, "fpr_sqrt:     %5lu\n", bench_sqrt() - cal);
    hal_send_str(item);

    sprintf(item, "fpr_of:       %5lu\n", bench_scaled() - cal);
    hal_send_str(item);
    sprintf(item, "rint:       %5lu\n", bench_rint() - cal);
    hal_send_str(item);
    sprintf(item, "floor:       %5lu\n", bench_floor() - cal);
    hal_send_str(item);
    sprintf(item, "trunc:       %5lu\n", bench_trunc() - cal);
    hal_send_str(item);

    sprintf(item, "tw_add:       %5lu\n", bench_tw_add() - cal);
    hal_send_str(item);
    sprintf(item, "tw_prod:      %5lu\n", bench_tw_prod() - cal);
    hal_send_str(item);
    sprintf(item, "tw_reci:       %5lu\n", bench_tw_reci() - cal);
    hal_send_str(item);
    sprintf(item, "tw_div:       %5lu\n", bench_tw_div() - cal);
    hal_send_str(item);
    sprintf(item, "tw_sqrt:      %5lu\n", bench_tw_sqrt() - cal);
    hal_send_str(item);

    sprintf(item, "tw_add_ct:       %5lu\n", bench_tw_add_ct() - cal);
    hal_send_str(item);
    sprintf(item, "tw_add_f_ct:       %5lu\n", bench_tw_add_f_ct() - cal);
    hal_send_str(item);
    sprintf(item, "tw_add_sub_ct:       %5lu\n", bench_tw_add_sub_ct() - cal);
    hal_send_str(item);
    sprintf(item, "tw_prod_ct:      %5lu\n", bench_tw_prod_ct() - cal);
    hal_send_str(item);
    sprintf(item, "tw_prod_f_ct:      %5lu\n", bench_tw_prod_f_ct() - cal);
    hal_send_str(item);
    sprintf(item, "tw_reci_ct:       %5lu\n", bench_tw_reci_ct() - cal);
    hal_send_str(item);
    sprintf(item, "tw_div_ct:       %5lu\n", bench_tw_div_ct() - cal);
    hal_send_str(item);
    sprintf(item, "tw_sqrt_ct:      %5lu\n", bench_tw_sqrt_ct() - cal);
    hal_send_str(item);

    sprintf(item, "tw_fpr_of:       %5lu\n", bench_tw_fpr_of() - cal);
    hal_send_str(item);
    sprintf(item, "tw_rint_ct:       %5lu\n", bench_tw_rint_ct() - cal);
    hal_send_str(item);
    sprintf(item, "tw_floor_ct:       %5lu\n", bench_tw_floor_ct() - cal);
    hal_send_str(item);
    sprintf(item, "tw_trunc_ct:       %5lu\n", bench_tw_trunc_ct() - cal);
    hal_send_str(item);
    sprintf(item, "tw_trunc_full_ct:       %5lu\n", bench_tw_trunc_full_ct() - cal);
    hal_send_str(item);
}
#endif


int main(void) {
    unsigned char sk[MUPQ_CRYPTO_SECRETKEYBYTES];
    unsigned char pk[MUPQ_CRYPTO_PUBLICKEYBYTES];
    unsigned char sm[MLEN + MUPQ_CRYPTO_BYTES];
    size_t smlen;
    unsigned int rc;
    unsigned long long t0, t1;
    int i;

    hal_setup(CLOCK_BENCHMARK);

    hal_send_str("==========================");

    uint64_t count_sum = 0;
    for (i = 0; i < 100; i++) {

        t0 = hal_get_time();
        MUPQ_crypto_sign_keypair(pk, sk);
        t1 = hal_get_time();
        // printcycles("keypair cycles:", t1 /* - */ t0);

        // Signing
        randombytes(sm, MLEN);
        t0 = hal_get_time();
        MUPQ_crypto_sign(sm, &smlen, sm, MLEN, sk);
        t1 = hal_get_time();
        count_sum += t1 - t0;
        // printcycles("sign cycles:", t1-t0);

        // Verification
        t0 = hal_get_time();
        rc = MUPQ_crypto_sign_open(sm, &smlen, sm, smlen, pk);
        t1 = hal_get_time();
        // printcycles("verify cycles:", t1-t0);

        if (rc) {
          hal_send_str("ERROR Signature did not verify correctly!\n");
        }
        hal_send_str("+");
    }
    printcycles("sign cycles avg", count_sum / 100);

#if FNDSA_SPEED
    bench_assembly();
#endif

    hal_send_str("#");
    return 0;
}

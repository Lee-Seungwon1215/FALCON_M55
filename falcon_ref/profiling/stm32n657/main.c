#include <stddef.h>
#include <stdint.h>

#include "main.h"
#include "api.h"
#include "falcon_profile.h"

#ifndef FALCON_PROFILE_KEYGEN_RUNS
#define FALCON_PROFILE_KEYGEN_RUNS 10
#endif
#ifndef FALCON_PROFILE_SIGN_RUNS
#define FALCON_PROFILE_SIGN_RUNS 100
#endif
#ifndef FALCON_PROFILE_VERIFY_RUNS
#define FALCON_PROFILE_VERIFY_RUNS 100
#endif

#define BENCH_STATE_WARMUP  UINT32_C(0x10000001)
#define BENCH_STATE_RUNNING UINT32_C(0x10000002)
#define BENCH_STATE_DONE    UINT32_C(0x600D0000)
#define BENCH_STATE_FAILED  UINT32_C(0xBAD00000)

volatile uint32_t falcon_bench_state;
volatile uint32_t falcon_bench_error;
volatile uint32_t falcon_bench_checksum;
volatile uint32_t falcon_bench_core_clock_hz;
volatile uint32_t falcon_bench_runs[3];

static uint8_t pk[PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES];
static uint8_t sk[PQCLEAN_FALCON512_CLEAN_CRYPTO_SECRETKEYBYTES];
static uint8_t sig[PQCLEAN_FALCON512_CLEAN_CRYPTO_BYTES];
static size_t sig_len;

void SystemClock_Config(void);

static int
sign_message(void) {
    static const uint8_t message[] = "Falcon STM32N657 profiling message";

    return PQCLEAN_FALCON512_CLEAN_crypto_sign_signature(
        sig, &sig_len, message, sizeof message - 1, sk);
}

static int
verify_message(void) {
    static const uint8_t message[] = "Falcon STM32N657 profiling message";

    return PQCLEAN_FALCON512_CLEAN_crypto_sign_verify(
        sig, sig_len, message, sizeof message - 1, pk);
}

static void
finish(uint32_t state, uint32_t error) {
    falcon_bench_error = error;
    falcon_bench_state = state;
    SCB_CleanDCache();
    __DSB();
    __ISB();
    __BKPT(0);
    for (;;) {
    }
}

int
main(void) {
    uint32_t checksum = 0;
    unsigned i;

    SCB_EnableICache();
    SCB_EnableDCache();
    HAL_Init();
    SystemClock_Config();

    falcon_bench_core_clock_hz = SystemCoreClock;
    falcon_bench_runs[0] = FALCON_PROFILE_KEYGEN_RUNS;
    falcon_bench_runs[1] = FALCON_PROFILE_SIGN_RUNS;
    falcon_bench_runs[2] = FALCON_PROFILE_VERIFY_RUNS;
    falcon_profile_clock_init();

    falcon_bench_state = BENCH_STATE_WARMUP;
    if (PQCLEAN_FALCON512_CLEAN_crypto_sign_keypair(pk, sk) != 0) {
        finish(BENCH_STATE_FAILED | 1u, 1u);
    }
    if (sign_message() != 0) {
        finish(BENCH_STATE_FAILED | 2u, 2u);
    }
    if (verify_message() != 0) {
        finish(BENCH_STATE_FAILED | 3u, 3u);
    }

    falcon_profile_reset();
    falcon_bench_state = BENCH_STATE_RUNNING;
    __disable_irq();

    for (i = 0; i < FALCON_PROFILE_KEYGEN_RUNS; i ++) {
        if (PQCLEAN_FALCON512_CLEAN_crypto_sign_keypair(pk, sk) != 0) {
            finish(BENCH_STATE_FAILED | 4u, 4u);
        }
        checksum ^= pk[i % sizeof pk];
    }
    for (i = 0; i < FALCON_PROFILE_SIGN_RUNS; i ++) {
        if (sign_message() != 0) {
            finish(BENCH_STATE_FAILED | 5u, 5u);
        }
        checksum ^= sig[(i + 1u) % sig_len];
    }
    for (i = 0; i < FALCON_PROFILE_VERIFY_RUNS; i ++) {
        if (verify_message() != 0) {
            finish(BENCH_STATE_FAILED | 6u, 6u);
        }
        checksum ^= (uint32_t)sig_len + i;
    }

    falcon_bench_checksum = checksum;
    finish(BENCH_STATE_DONE, 0);
}

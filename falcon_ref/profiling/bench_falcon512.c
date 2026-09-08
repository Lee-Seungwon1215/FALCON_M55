#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

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

static uint32_t checksum;

static int
make_signature(uint8_t *sig, size_t *sig_len, const uint8_t *sk) {
    static const uint8_t message[] = "Falcon profiling message";

    return PQCLEAN_FALCON512_CLEAN_crypto_sign_signature(
        sig, sig_len, message, sizeof message - 1, sk);
}

static int
verify_signature(const uint8_t *sig, size_t sig_len, const uint8_t *pk) {
    static const uint8_t message[] = "Falcon profiling message";

    return PQCLEAN_FALCON512_CLEAN_crypto_sign_verify(
        sig, sig_len, message, sizeof message - 1, pk);
}

int
main(void) {
    uint8_t pk[PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES];
    uint8_t sk[PQCLEAN_FALCON512_CLEAN_CRYPTO_SECRETKEYBYTES];
    uint8_t sig[PQCLEAN_FALCON512_CLEAN_CRYPTO_BYTES];
    size_t sig_len = 0;
    unsigned i;

    falcon_profile_clock_init();

    /* Warm up code and data paths; these samples are discarded. */
    for (i = 0; i < 2; i ++) {
        if (PQCLEAN_FALCON512_CLEAN_crypto_sign_keypair(pk, sk) != 0
                || make_signature(sig, &sig_len, sk) != 0
                || verify_signature(sig, sig_len, pk) != 0) {
            fprintf(stderr, "Falcon warmup failed\n");
            return 1;
        }
    }
    falcon_profile_reset();

    for (i = 0; i < FALCON_PROFILE_KEYGEN_RUNS; i ++) {
        if (PQCLEAN_FALCON512_CLEAN_crypto_sign_keypair(pk, sk) != 0) {
            fprintf(stderr, "Falcon keygen failed\n");
            return 1;
        }
        checksum ^= pk[i % sizeof pk];
    }
    for (i = 0; i < FALCON_PROFILE_SIGN_RUNS; i ++) {
        if (make_signature(sig, &sig_len, sk) != 0) {
            fprintf(stderr, "Falcon signing failed\n");
            return 1;
        }
        checksum ^= sig[(i + 1) % sig_len];
    }
    for (i = 0; i < FALCON_PROFILE_VERIFY_RUNS; i ++) {
        if (verify_signature(sig, sig_len, pk) != 0) {
            fprintf(stderr, "Falcon verification failed\n");
            return 1;
        }
        checksum ^= (uint32_t)sig_len + i;
    }

    falcon_profile_report();
    printf("\nchecksum: %08x\n", checksum);
    return 0;
}

/*
 * Copyright 2025 NXP
 * SPDX-License-Identifier: MIT
 */

#include "fndsa.h"
#include "print_error.h"
#include "init_gc.h"
#include <stdio.h>
#include <sys/random.h>

#define LOG FNDSA_LOGN_1024
#define FALCON_RUNS 1000

int main(void) {
    init_gc();

    if (LOG == 10) {
        init_print_errors(1024, FALCON_RUNS);
    } else {
        init_print_errors(512, FALCON_RUNS);
    }

    for (int i = 0; i < FALCON_RUNS; i++) {
        if (i % 100 == 0) {
            printf("i: %d\n", i);
        }

        int sign_key_size = FNDSA_SIGN_KEY_SIZE(LOG);
        uint8_t sign_key[sign_key_size];
        int vrfy_key_size = FNDSA_VRFY_KEY_SIZE(LOG);
        uint8_t vrfy_key[vrfy_key_size];
        int sig_size = FNDSA_SIGNATURE_SIZE(LOG);
        uint8_t sig[sig_size];

        unsigned char m[100];
        getrandom(m, 100, 0);
        fndsa_keygen(LOG, sign_key, vrfy_key);
        fndsa_sign(sign_key, sign_key_size, NULL, 0, FNDSA_HASH_ID_RAW, m, 100,
                   sig, sig_size);
    }

    print_errors_values();

    return 0;
}

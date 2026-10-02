/*
 * Copyright 2025 NXP
 * SPDX-License-Identifier: MIT
 */

#include "fndsa.h"
#include "print_to_file.h"
#include <pthread.h>
#include <stdio.h>
#include <string.h>
#include <sys/random.h>

#define LOG FNDSA_LOGN_512

#define SIG_RUNS 100##000##U
#define NUM_THREADS 24

#define PRINT_FREQ 1000
#define PRINT_AFTER_AMOUNT (uint32_t)(SIG_RUNS / PRINT_FREQ)

#define LOOP_AMOUNT (uint32_t) (SIG_RUNS / NUM_THREADS)

#define LOOP_AMOUNT_LAST LOOP_AMOUNT + SIG_RUNS - (LOOP_AMOUNT * NUM_THREADS)
#define LOOP_MAX_VALUE(id)                                                     \
    id == NUM_THREADS - 1 ? LOOP_AMOUNT_LAST : LOOP_AMOUNT

#define PRINT 1

void *perform_signature(void *arg) {
    int *id = (int *)arg;
    int max_value = *id == NUM_THREADS - 1 ? LOOP_AMOUNT_LAST : LOOP_AMOUNT;

    for (int i = 0; i < max_value; i++) {
        if (i % 10000 == 0) {
            printf("thread %d i: %d\n", *id, i);
        }
        // if(i == LOOP_AMOUNT - 1)

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

#if PRINT
        combine();
#endif

    // int verify = fndsa_verify(sig, sig_size, vrfy_key, vrfy_key_size,
    // NULL, 0,
    //                           FNDSA_HASH_ID_RAW, m, 100);
    // printf("verify success: %d\n", verify);
    return NULL;
}

int main(void) {
    int rc;

    pthread_mutex_init(&old_lock, NULL);
    // for(int i = 0; i < SIG_RUNS; i++){
    //       if (i % 1000 == 0) {
    //           printf("%d\n", i);
    //       }
    //   perform_signature(NULL);
    // }
    pthread_t threads[NUM_THREADS];

    int *ids[NUM_THREADS];
    for (int j = 0; j < NUM_THREADS; j++) {
        int *id = malloc(sizeof(int));
        *id = j;
        ids[j] = id;
        rc = pthread_create(&threads[j], NULL, perform_signature, id);
        if (rc) {
            // Print error message if thread creation failed
            printf("Error: unable to create thread, %d\n", rc);
        }
    }
    // wait for all threads to finish
    for (int j = 0; j < NUM_THREADS; j++) {
        pthread_join(threads[j], NULL);
        free(ids[j]);
    }

#if PRINT
    printf(
        "num_thread %d, loop_amount %d, loop_amount_last %d, total_amount %d\n",
        NUM_THREADS, LOOP_AMOUNT, LOOP_AMOUNT_LAST, SIG_RUNS);
    printf("did %d runs of Falcon", (NUM_THREADS - 1) * LOOP_AMOUNT + LOOP_AMOUNT_LAST);
    char name[30];
    get_file_name(name);
    write_to_file(name);

    char name2[40];
    sprintf(name2, "%s.metadata", name);

    int n;
    if (LOG == 9) {
        n = 512;
    } else if (LOG == 10) {
        n = 1024;
    } else {
        n = -1;
    }

    FILE *fptr = fopen(name2, "w");
    fprintf(fptr, "The data in %s, is from %d runs of Falcon-%d\n", name,
            (NUM_THREADS - 1) * LOOP_AMOUNT + LOOP_AMOUNT_LAST, n);

    fclose(fptr);
#endif
    return 0;
}

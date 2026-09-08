/*
 * Deterministic benchmark-only randombytes implementation.
 *
 * This is deliberately reproducible so that profile runs exercise the same
 * Falcon paths.  It is not cryptographically secure and must never be used in
 * production firmware.
 */
#include <stddef.h>
#include <stdint.h>

#include "randombytes.h"

static uint64_t profile_rng_state = UINT64_C(0x243F6A8885A308D3);

static uint64_t
next_word(void) {
    uint64_t z;

    profile_rng_state += UINT64_C(0x9E3779B97F4A7C15);
    z = profile_rng_state;
    z = (z ^ (z >> 30)) * UINT64_C(0xBF58476D1CE4E5B9);
    z = (z ^ (z >> 27)) * UINT64_C(0x94D049BB133111EB);
    return z ^ (z >> 31);
}

int
PQCLEAN_randombytes(uint8_t *output, size_t n) {
    while (n > 0) {
        uint64_t x = next_word();
        unsigned u;

        for (u = 0; u < 8 && n > 0; u ++, n --) {
            *output ++ = (uint8_t)x;
            x >>= 8;
        }
    }
    return 0;
}

/* SPDX-License-Identifier: MIT
 * Cache prefixes of FOUR ORIGINAL SHAKE streams, never interleave their bytes.
 * Counter zero only is precomputed; subsequent signing attempts use the
 * original seed||counter construction directly in sign_core.c.
 */
#include "shake_batch4.h"

/* Cortex-M4 SHAKE ABI: lanes 21..24 use even/odd bit interleaving.
 * All rate lanes 0..16 are canonical. Only the continuation state needs this
 * conversion, once per batch (not once per permutation).
 */
static uint32_t compact(uint32_t x)
{
    x &= 0x55555555;
    x = (x | (x >> 1)) & 0x33333333;
    x = (x | (x >> 2)) & 0x0f0f0f0f;
    x = (x | (x >> 4)) & 0x00ff00ff;
    return (x | (x >> 8)) & 0xffff;
}
static uint64_t split(uint32_t lo, uint32_t hi)
{
    uint32_t even = compact(lo) | (compact(hi) << 16);
    uint32_t odd = compact(lo >> 1) | (compact(hi >> 1) << 16);
    return even | ((uint64_t)odd << 32);
}

void fndsa_shake_batch4_prepare(fndsa_sampler_prng p[4],
    const uint8_t seed[4][40], unsigned blocks, uint8_t *buffer)
{
    uint32_t a[2][25][4] __attribute__((aligned(16)));
    memset(a, 0, sizeof a);
    for (unsigned s = 0; s < 4; s++) {
        /* Exactly SHAKE256(original derived 40-byte seed || counter=0).
         * No lane ID, subseed, or extra domain separator is injected.
         */
        for (unsigned j = 0; j < 5; j++) {
            memcpy(&a[0][j][s], seed[s] + 8*j, 4);
            memcpy(&a[1][j][s], seed[s] + 8*j + 4, 4);
        }
        a[0][5][s] = 0x1f00;  /* byte 40: counter 0; byte 41: SHAKE padding */
        a[1][16][s] = 0x80000000;
        p[s].next = p[s].end = buffer + (size_t)s * blocks * 136;
        p[s].end += (size_t)blocks * 136;
    }
    for (unsigned b = 0; b < blocks; b++) {
        fndsa_keccakx4_permute(a);
        fndsa_keccakx4_squeeze_separate(buffer + (size_t)b * 136,
            a, blocks * 136);
    }
    for (unsigned s = 0; s < 4; s++) {
        for (unsigned j = 0; j < 25; j++) {
            uint32_t lo = a[0][j][s], hi = a[1][j][s];
            p[s].sc.A[j] = j < 21 ? lo | ((uint64_t)hi << 32) : split(lo, hi);
        }
        /* Last prefetched block is completely consumed when the queue ends.
         * For blocks=0, this is the original padded, unpermuted state.
         */
        p[s].sc.rate = p[s].sc.dptr = 136;
    }
}

void fndsa_sampler_extract(fndsa_sampler_prng *p, void *out, size_t len)
{
    uint8_t *dst = out;
    size_t available = p->next == p->end ? 0 : (size_t)(p->end - p->next);
    size_t take = len < available ? len : available;
    if (take) {
        memcpy(dst, p->next, take);
        p->next += take; dst += take; len -= take;
    }
    /* Never discard a partial word at a block or cached-prefix boundary. */
    if (len) shake_extract(&p->sc, dst, len);
}

void fndsa_sign_batch4_clear(void *work, size_t len)
{
    volatile uint8_t *p = work;
    while (len--) *p++ = 0;
}

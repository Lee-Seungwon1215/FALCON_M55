/* SPDX-License-Identifier: MIT */
#include "shake_independent4.h"
#include "fndsa_batch4.h"

static void permute_mask(fndsa_shake4_state *s, unsigned mask)
{
    if (mask == 15) {
        fndsa_keccakx4_permute(s->a);
    } else if (mask != 0) {
        /* Unequal PUBLIC input lengths: preserve already padded lanes.
         * Never feed one stream's bytes into another stream. */
        fndsa_shake4_state keep = *s;
        fndsa_keccakx4_permute(s->a);
        for (unsigned lane = 0; lane < 4; lane++) {
            if ((mask & (1u << lane)) == 0) {
                for (unsigned p = 0; p < 2; p++)
                    for (unsigned j = 0; j < 25; j++)
                        s->a[p][j][lane] = keep.a[p][j][lane];
            }
        }
    }
}

void fndsa_shake4_absorb(fndsa_shake4_state *s,
    const fndsa_shake_iov *iov[4], const size_t count[4])
{
    size_t part[4] = {0}, offset[4] = {0};
    unsigned active = 15;
    memset(s, 0, sizeof *s);
    while (active != 0) {
        unsigned full = 0;
        for (unsigned lane = 0; lane < 4; lane++) {
            if ((active & (1u << lane)) == 0) continue;
            uint8_t block[136] = {0};
            size_t used = 0;
            while (used < sizeof block && part[lane] < count[lane]) {
                const fndsa_shake_iov *v = &iov[lane][part[lane]];
                size_t len = v->len - offset[lane];
                if (len > sizeof block - used) len = sizeof block - used;
                if (len) memcpy(block + used,
                    (const uint8_t *)v->data + offset[lane], len);
                used += len;
                offset[lane] += len;
                if (offset[lane] == v->len) {
                    part[lane]++;
                    offset[lane] = 0;
                }
            }
            if (used == sizeof block) {
                full |= 1u << lane;
            } else {
                block[used] ^= 0x1f;
                block[135] ^= 0x80;
                active &= ~(1u << lane);
            }
            for (unsigned j = 0; j < 17; j++) {
                uint32_t lo, hi;
                memcpy(&lo, block + 8*j, 4);
                memcpy(&hi, block + 8*j + 4, 4);
                s->a[0][j][lane] ^= lo;
                s->a[1][j][lane] ^= hi;
            }
        }
        permute_mask(s, full);
    }
}

void fndsa_shake4_block(fndsa_shake4_state *s, uint8_t out[4][136])
{
    fndsa_keccakx4_permute(s->a);
    fndsa_keccakx4_squeeze_separate(&out[0][0], s->a, 136);
}

static uint32_t compact(uint32_t x)
{
    x &= 0x55555555;
    x = (x | (x >> 1)) & 0x33333333;
    x = (x | (x >> 2)) & 0x0f0f0f0f;
    x = (x | (x >> 4)) & 0x00ff00ff;
    return (x | (x >> 8)) & 0xffff;
}

void fndsa_shake4_export_lane(const fndsa_shake4_state *s, unsigned lane,
    shake_context *sc)
{
    for (unsigned j = 0; j < 25; j++) {
        uint32_t lo = s->a[0][j][lane], hi = s->a[1][j][lane];
        if (j >= 21) {
            /* Retained CM4 Keccak stores ONLY lanes 21..24 bit-interleaved. */
            uint32_t even = compact(lo) | (compact(hi) << 16);
            uint32_t odd = compact(lo >> 1) | (compact(hi >> 1) << 16);
            lo = even;
            hi = odd;
        }
        sc->A[j] = lo | ((uint64_t)hi << 32);
    }
    sc->rate = sc->dptr = 136;
}

void fndsa_batch4_clear(void *work, size_t len)
{
    volatile uint8_t *p = work;
    while (len--) *p++ = 0;
}

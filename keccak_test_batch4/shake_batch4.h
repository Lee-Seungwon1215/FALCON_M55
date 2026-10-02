/* SPDX-License-Identifier: MIT -- internal independent-stream buffering. */
#ifndef FNDSA_SHAKE_BATCH4_H
#define FNDSA_SHAKE_BATCH4_H
#include "inner.h"
#include "shake_independent4.h"

typedef struct {
    shake_context sc;          /* SHAKE continuation after the cached prefix. */
    const uint8_t *next, *end;
    fndsa_shake4_stream *x4;
    unsigned lane;
} fndsa_sampler_prng;

typedef struct {
    uint8_t mu[4][64], seed[4][40];
    int8_t G[4][1024];
    fndsa_sampler_prng streams[4];
    fndsa_shake4_stream rolling;
    uint8_t nonce[4][40];
    uint16_t hm[4][1024];
    uint8_t tmp[59 * 1024 + 31] __attribute__((aligned(32)));
} __attribute__((aligned(32))) fndsa_batch4_work;

void fndsa_keccakx4_permute(uint32_t a[2][25][4]);
void fndsa_keccakx4_squeeze_separate(uint8_t *dst,
    const uint32_t a[2][25][4], unsigned stride);
void fndsa_shake_batch4_prepare(fndsa_sampler_prng streams[4],
    const uint8_t seed[4][40], unsigned blocks, uint8_t *buffer);
void fndsa_sampler_extract(fndsa_sampler_prng *p, void *out, size_t len);

static inline void
fndsa_sampler_init(fndsa_sampler_prng *p, const void *seed,
    size_t seed_len, uint8_t counter)
{
    p->next = p->end = NULL;
    p->x4 = NULL;
    p->lane = 0;
    shake_init(&p->sc, 256);
    shake_inject(&p->sc, seed, seed_len);
    shake_inject(&p->sc, &counter, 1);
    shake_flip(&p->sc);
}
static inline unsigned fndsa_sampler_u8(fndsa_sampler_prng *p)
{
    if (p->x4 != NULL) {
        fndsa_shake4_stream *s = p->x4;
        if (s->pos[p->lane] != s->end[p->lane])
            return s->buffer[p->lane*s->capacity + s->pos[p->lane]++];
        uint8_t v;
        fndsa_shake4_stream_read(s, p->lane, &v, 1);
        return v;
    }
    if (p->next != p->end) return *p->next++;
    return shake_next_u8(&p->sc);
}
static inline unsigned fndsa_sampler_u16(fndsa_sampler_prng *p)
{
    if (p->x4 != NULL) return fndsa_shake4_stream_u16(p->x4, p->lane);
    if (p->next != p->end) {
        uint16_t v;
        if ((size_t)(p->end - p->next) >= 2) {
            memcpy(&v, p->next, 2); p->next += 2;
        } else {
            fndsa_sampler_extract(p, &v, 2);
        }
        return v;
    }
    return shake_next_u16(&p->sc);
}
static inline uint64_t fndsa_sampler_u64(fndsa_sampler_prng *p)
{
    if (p->x4 != NULL) {
        fndsa_shake4_stream *s = p->x4;
        uint64_t v;
        if (s->end[p->lane] - s->pos[p->lane] >= 8) {
            memcpy(&v, s->buffer + p->lane*s->capacity + s->pos[p->lane], 8);
            s->pos[p->lane] += 8;
        } else {
            fndsa_shake4_stream_read(s, p->lane, &v, 8);
        }
        return v;
    }
    if (p->next != p->end) {
        uint64_t v;
        if ((size_t)(p->end - p->next) >= 8) {
            memcpy(&v, p->next, 8); p->next += 8;
        } else {
            fndsa_sampler_extract(p, &v, 8);
        }
        return v;
    }
    return shake_next_u64(&p->sc);
}
#endif

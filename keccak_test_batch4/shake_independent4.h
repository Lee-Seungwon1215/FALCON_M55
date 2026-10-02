/* SPDX-License-Identifier: MIT -- internal, original independent SHAKEs */
#ifndef FNDSA_SHAKE_INDEPENDENT4_H
#define FNDSA_SHAKE_INDEPENDENT4_H
#include "inner.h"
/* Shared MVE x4 engine; no changed-PRNG sampler is imported. */
void fndsa_keccakx4_permute(uint32_t a[2][25][4]);
typedef struct { const void *data; size_t len; } fndsa_shake_iov;
typedef struct {
    uint32_t a[2][25][4];
} __attribute__((aligned(16))) fndsa_shake4_state;
typedef struct {
    const uint8_t *next, *end;
} fndsa_shake_prefix;
/* Absorb per-lane concatenated iov, append SHAKE padding. First squeeze
 * permutation has NOT yet occurred. No stream ID is appended. */
void fndsa_shake4_absorb(fndsa_shake4_state *s,
    const fndsa_shake_iov *iov[4], const size_t count[4]);
void fndsa_shake4_block(fndsa_shake4_state *s, uint8_t out[4][136]);
void fndsa_shake4_export_lane(const fndsa_shake4_state *s, unsigned lane,
    shake_context *sc);
void fndsa_keccakx4_squeeze_separate(uint8_t *out,
    const uint32_t a[2][25][4], unsigned stride);
void fndsa_sample_f_prefetched(unsigned logn, shake_context *sc,
    fndsa_shake_prefix *prefix, int8_t *f);

/* Bounded queues for four original streams. A refill always uses the MVE
 * permutation; lanes with full queues retain their exact state. No scalar
 * Keccak fallback, global scheduler, or hidden allocation is involved. */
typedef struct {
    fndsa_shake4_state state;
    uint8_t *buffer;
    size_t capacity, pos[4], end[4];
    unsigned live;
} fndsa_shake4_stream;
void fndsa_shake4_permute_mask(fndsa_shake4_state *s, unsigned mask);
void fndsa_shake4_stream_init(fndsa_shake4_stream *s,
    const fndsa_shake_iov *iov[4], const size_t count[4],
    uint8_t *buffer, unsigned blocks);
void fndsa_shake4_stream_read(fndsa_shake4_stream *s, unsigned lane,
    void *out, size_t len);
void fndsa_shake4_stream_reset_lane(fndsa_shake4_stream *s, unsigned lane,
    const fndsa_shake_iov *iov, size_t count);
void fndsa_shake4_hash_to_point(fndsa_shake4_state *s,
    const unsigned logn[4], const uint8_t nonce[4][40],
    const uint8_t mu[4][64], uint16_t *out[4], unsigned mask);
static inline unsigned
fndsa_shake4_stream_u16(fndsa_shake4_stream *s, unsigned lane)
{
    if (s->end[lane] - s->pos[lane] >= 2) {
        const uint8_t *p = s->buffer + lane*s->capacity + s->pos[lane];
        s->pos[lane] += 2;
        return p[0] | ((unsigned)p[1] << 8);
    }
    uint8_t b[2];
    fndsa_shake4_stream_read(s, lane, b, sizeof b);
    return b[0] | ((unsigned)b[1] << 8);
}
void fndsa_sample_f_x4(const unsigned logn[4], fndsa_shake4_stream *s,
    int8_t *out[4], unsigned mask);
#endif

/* SPDX-License-Identifier: MIT */
#include "shake_independent4.h"
#include "fndsa_batch4.h"

/* Convert one canonical x4 lane to the retained CM4 permutation ABI and
 * back. This pinned ASM stores words 21..24 as even/odd bit-interleaved
 * values (not just the SHAKE256 capacity words 17..24). The differential
 * tests compare ALL 25 words after repeated scalar/x4 transitions. */
void fndsa_sha3_process_block(uint64_t *a, unsigned rate_words);

static uint32_t spread16(uint32_t x)
{
    x &= 0xffff;
    x = (x | (x << 8)) & 0x00ff00ff;
    x = (x | (x << 4)) & 0x0f0f0f0f;
    x = (x | (x << 2)) & 0x33333333;
    return (x | (x << 1)) & 0x55555555;
}

void fndsa_shake4_scalar_lane(fndsa_shake4_state *s, unsigned lane)
{
    shake_context sc;
    fndsa_shake4_export_lane(s, lane, &sc);
    fndsa_sha3_process_block(sc.A, 17);
    for (unsigned j = 0; j < 25; j++) {
        uint32_t lo = (uint32_t)sc.A[j], hi = (uint32_t)(sc.A[j] >> 32);
        if (j >= 21) {
            uint32_t even = lo, odd = hi;
            lo = spread16(even) | (spread16(odd) << 1);
            hi = spread16(even >> 16) | (spread16(odd >> 16) << 1);
        }
        s->a[0][j][lane] = lo;
        s->a[1][j][lane] = hi;
    }
    fndsa_batch4_clear(&sc, sizeof sc);
}

void fndsa_shake4_permute_mask(fndsa_shake4_state *s, unsigned mask)
{
    if (mask == 0) return;
    unsigned active = (mask & 1) + ((mask >> 1) & 1)
        + ((mask >> 2) & 1) + ((mask >> 3) & 1);
    /* C_two_plus: fixed source-level policy, no build-selected backend. */
    if (active < 2) {
        for (unsigned lane = 0; lane < 4; lane++)
            if (mask & (1u << lane)) fndsa_shake4_scalar_lane(s, lane);
        return;
    }
    if (mask == 15) {
        fndsa_keccakx4_permute(s->a);
    } else if (mask != 0) {
        /* Preserve inactive streams. A partial mask still costs a full x4
         * permutation; it is NOT four useful permutations. */
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
        fndsa_shake4_permute_mask(s, full);
    }
}

void fndsa_shake4_block(fndsa_shake4_state *s, uint8_t out[4][136])
{
    fndsa_shake4_permute_mask(s, 15);
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

void fndsa_shake4_stream_init(fndsa_shake4_stream *s,
    const fndsa_shake_iov *iov[4], const size_t count[4],
    uint8_t *buffer, unsigned blocks)
{
    memset(s, 0, sizeof *s);
    s->buffer = buffer;
    s->capacity = (size_t)(blocks ? blocks : 1)*136;
    s->live = 15;
    fndsa_shake4_absorb(&s->state, iov, count);
}

static void stream_refill(fndsa_shake4_stream *s, unsigned requested)
{
    /* Compact unread tails before refilling. Different rejection counts can
     * leave another lane just two bytes behind; without compaction that lane
     * would appear full and virtually every refill would have one useful lane.
     * Readers retain offsets, never pointers across calls. */
    for (unsigned lane = 0; lane < 4; lane++) {
        size_t left = s->end[lane] - s->pos[lane];
        if (left && s->pos[lane])
            memmove(s->buffer + lane*s->capacity,
                s->buffer + lane*s->capacity + s->pos[lane], left);
        s->pos[lane] = 0;
        s->end[lane] = left;
    }
    while (s->end[requested] < s->capacity) {
        unsigned mask = 0;
        for (unsigned lane = 0; lane < 4; lane++) {
            if ((s->live & (1u << lane))
                && s->capacity - s->end[lane] >= 136) mask |= 1u << lane;
        }
        fndsa_shake4_permute_mask(&s->state, mask);
        uint8_t block[4][136] __attribute__((aligned(16)));
        fndsa_keccakx4_squeeze_separate(&block[0][0], s->state.a, 136);
        for (unsigned lane = 0; lane < 4; lane++) {
            if (!(mask & (1u << lane))) continue;
            memcpy(s->buffer + lane*s->capacity + s->end[lane], block[lane], 136);
            s->end[lane] += 136;
        }
        /* Do not reserve another entire prefix for a lone/partial tail.
         * Produce just one block then; otherwise a request needing one extra
         * byte could trigger hundreds of unused permutations. */
        if (mask != 15) break;
    }
}

void fndsa_shake4_stream_read(fndsa_shake4_stream *s, unsigned lane,
    void *out, size_t len)
{
    uint8_t *p = out;
    while (len) {
        if (s->pos[lane] == s->end[lane]) stream_refill(s, lane);
        size_t take = s->end[lane] - s->pos[lane];
        if (take > len) take = len;
        memcpy(p, s->buffer + lane*s->capacity + s->pos[lane], take);
        s->pos[lane] += take;
        p += take;
        len -= take;
    }
}

void fndsa_shake4_stream_reset_lane(fndsa_shake4_stream *s, unsigned lane,
    const fndsa_shake_iov *iov, size_t count)
{
    /* Rejection retry: new seed||counter, never reuse the old stream.
     * The temporary x4 absorb uses empty dummy streams in the other lanes;
     * the other real requests and their unread bytes are untouched. */
    fndsa_shake4_state fresh;
    const fndsa_shake_iov *v[4] = {NULL,NULL,NULL,NULL};
    size_t counts[4] = {0};
    v[lane] = iov;
    counts[lane] = count;
    fndsa_shake4_absorb(&fresh, v, counts);
    for (unsigned p = 0; p < 2; p++)
        for (unsigned j = 0; j < 25; j++)
            s->state.a[p][j][lane] = fresh.a[p][j][lane];
    s->pos[lane] = s->end[lane] = 0;
    s->live |= 1u << lane;
    fndsa_batch4_clear(&fresh, sizeof fresh);
}

void fndsa_shake4_hash_to_point(fndsa_shake4_state *s,
    const unsigned logn[4], const uint8_t nonce[4][40],
    const uint8_t mu[4][64], uint16_t *out[4], unsigned mask)
{
    fndsa_shake_iov v[4][2];
    const fndsa_shake_iov *vp[4];
    size_t count[4], pos[4] = {0};
    for (unsigned lane = 0; lane < 4; lane++) {
        vp[lane] = v[lane];
        v[lane][0] = (fndsa_shake_iov){nonce[lane],40};
        v[lane][1] = (fndsa_shake_iov){mu[lane],64};
        count[lane] = (mask & (1u << lane)) ? 2 : 0;
    }
    fndsa_shake4_absorb(s, vp, count);
    while (mask) {
        uint8_t block[4][136];
        fndsa_shake4_permute_mask(s, mask);
        fndsa_keccakx4_squeeze_separate(&block[0][0], s->a, 136);
        for (unsigned lane = 0; lane < 4; lane++) {
            if (!(mask & (1u << lane))) continue;
            size_t n = (size_t)1 << logn[lane];
            for (unsigned j = 0; j < 136 && pos[lane] < n; j += 2) {
                unsigned x = block[lane][j] | ((unsigned)block[lane][j+1] << 8);
                if (x < 61445) {
                    while (x >= 12289) x -= 12289;
                    out[lane][pos[lane]++] = (uint16_t)x;
                }
            }
            if (pos[lane] == n) mask &= ~(1u << lane);
        }
    }
}

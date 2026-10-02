/* SPDX-License-Identifier: MIT
 * Four SHAKE256 streams for the signing sampler. Not a standard single SHAKE.
 * VecFalcon ordering: eight bytes from streams 0,1,2,3, then next words.
 */
#ifndef FNDSA_SHAKE256X4_H
#define FNDSA_SHAKE256X4_H
#include <stdint.h>
#include <stddef.h>
#include <string.h>
typedef struct {
    uint32_t a[2][25][4];
    uint8_t buf[544];
    unsigned ptr;
} __attribute__((aligned(16))) fndsa_shake256x4_context;
void fndsa_keccakx4_permute(uint32_t a[2][25][4]);
void fndsa_keccakx4_squeeze256(uint8_t dst[544], const uint32_t a[2][25][4]);
void fndsa_keccakx4_import(uint32_t a[2][25][4], const uint64_t src[4][25]);
void fndsa_keccakx4_export(uint64_t dst[4][25], const uint32_t a[2][25][4]);
/* Fixed 56-byte subseed, as in VecFalcon's sampler initialization. */
void fndsa_shake256x4_init(fndsa_shake256x4_context *, const uint8_t seed[56]);
void fndsa_shake256x4_refill(fndsa_shake256x4_context *);
static inline unsigned fndsa_shake256x4_next_u8(fndsa_shake256x4_context *c)
{
    if (c->ptr >= 544) fndsa_shake256x4_refill(c);
    return c->buf[c->ptr++];
}
static inline unsigned fndsa_shake256x4_next_u16(fndsa_shake256x4_context *c)
{
    uint16_t v;
    if (c->ptr >= 543) fndsa_shake256x4_refill(c);
    memcpy(&v, c->buf + c->ptr, 2); c->ptr += 2; return v;
}
static inline uint64_t fndsa_shake256x4_next_u64(fndsa_shake256x4_context *c)
{
    uint64_t v;
    if (c->ptr >= 537) fndsa_shake256x4_refill(c);
    memcpy(&v, c->buf + c->ptr, 8); c->ptr += 8; return v;
}
#endif

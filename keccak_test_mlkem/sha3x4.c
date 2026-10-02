/* SPDX-License-Identifier: MIT */
#include "sha3x4.h"
/* Compact alternate bits: the other plane uses x >> 1. */
static uint32_t compact(uint32_t x)
{
    x &= 0x55555555;
    x = (x | (x >> 1)) & 0x33333333;
    x = (x | (x >> 2)) & 0x0f0f0f0f;
    x = (x | (x >> 4)) & 0x00ff00ff;
    return (x | (x >> 8)) & 0x0000ffff;
}
static uint32_t spread(uint32_t x)
{
    x &= 0xffff;
    x = (x | (x << 8)) & 0x00ff00ff;
    x = (x | (x << 4)) & 0x0f0f0f0f;
    x = (x | (x << 2)) & 0x33333333;
    return (x | (x << 1)) & 0x55555555;
}
static void encode(uint64_t x, uint32_t *e, uint32_t *o)
{
    uint32_t l=(uint32_t)x, h=(uint32_t)(x>>32);
    *e=compact(l)|(compact(h)<<16);
    *o=compact(l>>1)|(compact(h>>1)<<16);
}
static uint64_t decode(uint32_t e, uint32_t o)
{
    uint32_t l=spread(e)|(spread(o)<<1);
    uint32_t h=spread(e>>16)|(spread(o>>16)<<1);
    return (uint64_t)l|((uint64_t)h<<32);
}

void fndsa_keccakx4_import(uint32_t a[2][25][4], const uint64_t src[4][25])
{
    for (unsigned j=0;j<25;j++) for (unsigned s=0;s<4;s++)
        encode(src[s][j], &a[0][j][s], &a[1][j][s]);
}
void fndsa_keccakx4_export(uint64_t dst[4][25], const uint32_t a[2][25][4])
{
    for (unsigned j=0;j<25;j++) for (unsigned s=0;s<4;s++)
        dst[s][j]=decode(a[0][j][s], a[1][j][s]);
}
void fndsa_shake256x4_init(fndsa_shake256x4_context *c, const uint8_t seed[56])
{
    memset(c->a, 0, sizeof c->a);
    for (unsigned j=0;j<7;j++) {
        uint64_t v; uint32_t p,q;
        memcpy(&v, seed+8*j, 8); encode(v,&p,&q);
        for(unsigned s=0;s<4;s++) { c->a[0][j][s]=p; c->a[1][j][s]=q; }
    }
    for (unsigned s=0;s<4;s++) {
        encode((uint64_t)s|UINT64_C(0x1f00), &c->a[0][7][s], &c->a[1][7][s]);
        encode(UINT64_C(0x8000000000000000), &c->a[0][16][s], &c->a[1][16][s]);
    }
    c->ptr=544;
}
void fndsa_shake256x4_refill(fndsa_shake256x4_context *c)
{
    fndsa_keccakx4_permute(c->a);
    for(unsigned j=0;j<17;j++) for(unsigned s=0;s<4;s++) {
        uint64_t v=decode(c->a[0][j][s],c->a[1][j][s]);
        memcpy(c->buf+32*j+8*s,&v,8);
    }
    c->ptr=0;
}


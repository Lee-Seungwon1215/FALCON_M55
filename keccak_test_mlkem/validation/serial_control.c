/* Test-only control: identical x4 PRNG, four original CM4 permutations.
 * The original ABI stores its last four 64-bit lanes in even/odd format. */
#include "sha3x4.h"
extern void fndsa_sha3_process_block(uint64_t *, unsigned);
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
static uint64_t split(uint64_t x) {
 uint32_t e,o;encode(x,&e,&o);return e|((uint64_t)o<<32);
}
static uint64_t merge(uint64_t x) {
 return decode((uint32_t)x,(uint32_t)(x>>32));
}
void fndsa_keccakx4_permute(uint32_t a[2][25][4]) {
 uint64_t state[25];
 for(unsigned s=0;s<4;s++) {
  for(unsigned j=0;j<25;j++) { uint64_t v=a[0][j][s]|((uint64_t)a[1][j][s]<<32); state[j]=j<21?v:split(v); }
  fndsa_sha3_process_block(state,17);
  for(unsigned j=0;j<25;j++) { uint64_t v=j<21?state[j]:merge(state[j]); a[0][j][s]=(uint32_t)v; a[1][j][s]=(uint32_t)(v>>32); }
 }
}

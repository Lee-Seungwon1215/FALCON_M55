#ifndef LOCAL_BRIDGE_PROFILE_H
#define LOCAL_BRIDGE_PROFILE_H
#include <stdint.h>
#include <cmsis_core.h>
#include "tw32_api.h"

/* Measurement-only copies. The normal public functions are unchanged. */
void bp_tw32_bridge_fft(unsigned logn, double *f);
void bp_tw32_bridge_ifft(unsigned logn, double *f);
void bc_tw32_bridge_fft(unsigned logn, double *f);
void bc_tw32_bridge_ifft(unsigned logn, double *f);
void bp_ds32_fft_mve(unsigned logn, tw32_fft *f);
void bp_ds32_ifft_mve(unsigned logn, tw32_fft *f);
void bc_ds32_fft_mve(unsigned logn, tw32_fft *f);
void bc_ds32_ifft_mve(unsigned logn, tw32_fft *f);
enum { BP_INPUT, BP_CORE, BP_ROOTS, BP_OUTPUT, BP_COUNT };
struct bp_stat { uint64_t cycles; uint32_t calls; };
extern struct bp_stat bp_stats[BP_COUNT];

static inline uint32_t bp_tick(void)
{
    __asm__ volatile ("" ::: "memory");
    uint32_t t = DWT->CYCCNT;
    __asm__ volatile ("" ::: "memory");
    return t;
}
static inline void bp_end(unsigned region, uint32_t start)
{
    uint32_t elapsed = bp_tick() - start;
    bp_stats[region].cycles += elapsed;
    bp_stats[region].calls ++;
}
#endif

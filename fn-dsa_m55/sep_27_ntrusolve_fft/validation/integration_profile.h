#ifndef INTEGRATION_PROFILE_H
#define INTEGRATION_PROFILE_H
#include <stdint.h>
#include <cmsis_core.h>
#include <zephyr/kernel.h>
enum {
    IP_SAMPLE, IP_INVERT, IP_ORTHO, IP_NTRU, IP_FINISH,
    IP_I_INPUT, IP_I_FFT, IP_I_RECIP, IP_I_MUL, IP_I_IFFT, IP_I_ROUND, IP_I_UPDATE,
    IP_D_INPUT, IP_D_FFT, IP_D_DIV, IP_D_IFFT, IP_D_ROUND,
    IP_O_INPUT, IP_O_FFT, IP_O_INV, IP_O_ADJ, IP_O_REAL, IP_O_SELFADJ,
    IP_O_IFFT, IP_O_NORM, IP_DEEPEST, IP_INTERMEDIATE, IP_DEPTH0,
    IP_FG_DEEP, IP_CRT_DEEP, IP_BEZ_DEEP, IP_CRT_FG, IP_CRT_I, IP_COUNT
};
static inline uint64_t ip_now(void)
{
    __DSB(); __ISB();
    return k_cycle_get_64();
}
void ip_end(unsigned op, unsigned logn, uint64_t start);
void ip_result(unsigned op, unsigned logn, int result);
void ip_reset(void);
void ip_calibrate(void);
int ip_report(unsigned logn, uint64_t total);
#endif

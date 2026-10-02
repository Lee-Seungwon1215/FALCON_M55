#ifndef LOCAL_NTRU_PROFILE_H
#define LOCAL_NTRU_PROFILE_H
#include <stdint.h>
#include <cmsis_core.h>
enum {
    NP_FFT4, NP_INV4, NP_MUL4, NP_IFFT4,
    NP_FFT5, NP_DIV5, NP_IFFT5,
    NP_INPUT4, NP_ROUND4, NP_INPUT5, NP_ROUND5, NP_COUNT
};
static inline uint32_t np_start(void)
{
    __DSB(); __ISB();
    return DWT->CYCCNT;
}
void np_enter(void);
void np_leave(unsigned success);
void np_end(unsigned op, uint32_t start);
void np_reset(void);
void np_calibrate(void);
int np_report(unsigned key_logn);
#endif

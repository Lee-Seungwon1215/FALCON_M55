#ifndef AUDIT_APPROX_PROFILE_H
#define AUDIT_APPROX_PROFILE_H
#include <stdint.h>
#include <cmsis_core.h>
enum { AP_INPUT_F, AP_FFT_F, AP_INVERSE, AP_INPUT_BIG_F, AP_FFT_BIG_F,
       AP_POINTWISE, AP_IFFT, AP_ROUND, AP_GUARD, AP_COUNT };
static inline uint32_t ap_start(void)
{
    __DSB(); __ISB();
    return DWT->CYCCNT;
}
void ap_end(unsigned op, unsigned logn, uint32_t start);
void ap_reset(void);
void ap_report(unsigned key_logn);
void ap_calibrate(void);
#endif

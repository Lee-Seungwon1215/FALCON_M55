#ifndef LOCAL_ORTHO_PROFILE_H
#define LOCAL_ORTHO_PROFILE_H
#include <stdint.h>
#include <cmsis_core.h>
enum {
    OP_INPUT, OP_FFT, OP_INVNORM, OP_ADJ, OP_REALCONST,
    OP_SELFADJ, OP_IFFT, OP_NORM, OP_COUNT
};
static inline uint32_t op_start(void)
{
    __DSB(); __ISB();
    return DWT->CYCCNT;
}
void op_enter(void);
void op_leave(void);
void op_end(unsigned op, uint32_t start);
void op_key_enter(void);
void op_key_leave(void);
void op_reset(void);
void op_calibrate(void);
int op_report(unsigned logn);
#endif

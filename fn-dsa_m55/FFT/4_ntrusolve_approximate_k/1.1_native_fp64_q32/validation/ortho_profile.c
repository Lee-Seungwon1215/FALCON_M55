/* Profiling only: no arithmetic, key-selection or KAT changes. */
#include "ortho_profile.h"
#include "ortho_profile_mode.h"
#include <stdio.h>
#include <string.h>
static uint64_t cycles[OP_COUNT], ortho_total, key_total;
static uint32_t calls[OP_COUNT], attempts, keys, max_ortho, max_key;
static uint32_t ortho_start, key_start, active, key_active, errors;
static const char *names[OP_COUNT] = {
    "vect_set", "vect_FFT", "vect_invnorm_fft", "vect_adj_fft",
    "vect_mul_realconst", "vect_mul_selfadj_fft", "vect_iFFT", "norm_sum"
};
void op_enter(void)
{
    errors += active != 0;
    active = 1;
    ortho_start = op_start();
}
void op_leave(void)
{
    uint32_t elapsed = op_start() - ortho_start;
    errors += active != 1;
    active = 0;
    ortho_total += elapsed;
    attempts ++;
    if (elapsed > max_ortho) max_ortho = elapsed;
}
void op_end(unsigned op, uint32_t start)
{
    uint32_t elapsed = op_start() - start;
    if (!active || op >= OP_COUNT) { errors ++; return; }
    cycles[op] += elapsed;
    calls[op] ++;
}
void op_key_enter(void)
{
    errors += key_active != 0 || active != 0;
    key_active = 1;
    key_start = op_start();
}
void op_key_leave(void)
{
    uint32_t elapsed = op_start() - key_start;
    errors += key_active != 1 || active != 0;
    key_active = 0;
    key_total += elapsed;
    keys ++;
    if (elapsed > max_key) max_key = elapsed;
}
void op_reset(void)
{
    memset(cycles, 0, sizeof cycles);
    memset(calls, 0, sizeof calls);
    ortho_total = key_total = 0;
    attempts = keys = max_ortho = max_key = 0;
    ortho_start = key_start = active = key_active = errors = 0;
}
void op_calibrate(void)
{
    op_reset();
    op_enter();
    for (unsigned i = 0; i < 1000; i ++) {
        uint32_t start = op_start();
        op_end(OP_INPUT, start);
    }
    op_leave();
    printf("OPRO_EMPTY calls=%u cycles=%llu\n", calls[OP_INPUT],
        (unsigned long long)cycles[OP_INPUT]);
    op_reset();
}
int op_report(unsigned logn)
{
    uint64_t accounted = 0;
    for (unsigned op = 0; op < OP_COUNT; op ++) accounted += cycles[op];
    errors += active != 0 || key_active != 0 || keys != 100;
    errors += accounted > ortho_total || ortho_total > key_total;
    errors += max_key >= 2000000000u || max_ortho >= 2000000000u;
    printf("OPRO_TOTAL degree=%u mode=%s keys=%u attempts=%u key_cycles=%llu ortho_cycles=%llu max_key=%u max_ortho=%u errors=%u\n",
        1u << logn, OP_MODE, keys, attempts,
        (unsigned long long)key_total, (unsigned long long)ortho_total,
        max_key, max_ortho, errors);
    for (unsigned op = 0; op < OP_COUNT; op ++) {
        printf("OPRO degree=%u op=%s calls=%u cycles=%llu\n", 1u << logn,
            names[op], calls[op], (unsigned long long)cycles[op]);
    }
    printf("OPRO degree=%u op=ortho_other calls=0 cycles=%llu\n", 1u << logn,
        (unsigned long long)(ortho_total-accounted));
    printf("OPRO degree=%u op=key_other calls=0 cycles=%llu\n", 1u << logn,
        (unsigned long long)(key_total-ortho_total));
    return errors ? 1 : 0;
}

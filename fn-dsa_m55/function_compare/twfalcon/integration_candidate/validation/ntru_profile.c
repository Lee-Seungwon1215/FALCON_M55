/* Timing support only; no arithmetic or key-selection changes. */
#include "ntru_profile.h"
#include "ntru_profile_mode.h"
#include <stdio.h>
#include <string.h>
static uint64_t cycles[NP_COUNT], total;
static uint32_t calls[NP_COUNT], attempts, accepted, max_call;
static uint32_t start_call, active, errors;
static const char *names[NP_COUNT] = {
    "FFT_fp64", "inv_mul2e_fft_fp64", "mul_fft_fp64", "iFFT_fp64",
    "FFT_fixed", "div_selfadj_fft_fixed", "iFFT_fixed",
    "input_intermediate", "round_guard_intermediate",
    "input_depth0", "round_rns_depth0"
};
void np_enter(void)
{
    errors += active != 0;
    active = 1;
    start_call = np_start();
}
void np_leave(unsigned success)
{
    uint32_t elapsed = np_start() - start_call;
    errors += active != 1;
    active = 0;
    total += elapsed;
    attempts ++;
    accepted += success;
    if (elapsed > max_call) max_call = elapsed;
}
void np_end(unsigned op, uint32_t start)
{
    uint32_t elapsed = np_start() - start;
    if (!active || op >= NP_COUNT) { errors ++; return; }
    cycles[op] += elapsed;
    calls[op] ++;
}
void np_reset(void)
{
    memset(cycles, 0, sizeof cycles);
    memset(calls, 0, sizeof calls);
    total = 0;
    attempts = accepted = max_call = start_call = active = errors = 0;
}
void np_calibrate(void)
{
    np_reset();
    np_enter();
    for (unsigned i = 0; i < 1000; i ++) {
        uint32_t t = np_start();
        np_end(NP_INPUT4, t);
    }
    np_leave(1);
    printf("NPRO_EMPTY calls=%u cycles=%llu\n", calls[NP_INPUT4],
        (unsigned long long)cycles[NP_INPUT4]);
    np_reset();
}
int np_report(unsigned key_logn)
{
    uint64_t accounted = 0;
    for (unsigned op = 0; op < NP_COUNT; op ++) accounted += cycles[op];
    errors += active != 0 || accounted > total || accepted != 100;
    printf("NPRO_TOTAL degree=%u mode=%s keys=100 attempts=%u accepted=%u failed=%u cycles=%llu max_call=%u errors=%u\n",
        1u << key_logn, NP_MODE, attempts, accepted, attempts-accepted,
        (unsigned long long)total, max_call, errors);
    for (unsigned op = 0; op < NP_COUNT; op ++) {
        printf("NPRO degree=%u op=%s calls=%u cycles=%llu\n",
            1u << key_logn, names[op], calls[op], (unsigned long long)cycles[op]);
    }
    printf("NPRO degree=%u op=other calls=0 cycles=%llu\n", 1u << key_logn,
        (unsigned long long)(total-accounted));
    return errors ? 1 : 0;
}

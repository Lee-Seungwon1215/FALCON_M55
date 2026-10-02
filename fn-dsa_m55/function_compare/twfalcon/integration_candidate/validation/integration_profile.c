/* Measurement only. Inclusive parents and disjoint leaves are printed
 * separately; never add a parent to its own children. No timer subtraction. */
#include "integration_profile.h"
#include <stdio.h>
#include <string.h>
static uint64_t cycles[IP_COUNT][11];
static uint32_t calls[IP_COUNT][11], success[IP_COUNT][11];
static const char *names[IP_COUNT] = {
    "sample", "invert", "ortho", "ntru", "finish",
    "I_input", "I_fft", "I_recip", "I_mul", "I_ifft", "I_round", "I_update",
    "D_input", "D_fft", "D_div", "D_ifft", "D_round",
    "O_input", "O_fft", "O_invnorm", "O_adj", "O_real", "O_selfadj",
    "O_ifft", "O_norm", "deepest", "intermediate", "depth0",
    "fg_deep", "crt_deep", "bezout_deep", "crt_fg", "crt_intermediate"
};
static unsigned errors;
void ip_end(unsigned op, unsigned logn, uint64_t start)
{
    uint64_t elapsed = ip_now() - start;
    if (op >= IP_COUNT || logn > 10) { errors++; return; }
    cycles[op][logn] += elapsed;
    calls[op][logn]++;
}
void ip_result(unsigned op, unsigned logn, int result)
{
    if (op >= IP_COUNT || logn > 10) { errors++; return; }
    success[op][logn] += result == ((op == IP_ORTHO || op == IP_NTRU || op == IP_INVERT || op == IP_BEZ_DEEP) ? 1 : 0);
}
void ip_reset(void)
{
    memset(cycles, 0, sizeof cycles);
    memset(calls, 0, sizeof calls);
    memset(success, 0, sizeof success);
    errors = 0;
}
void ip_calibrate(void)
{
    ip_reset();
    uint64_t a = ip_now();
    for (unsigned i = 0; i < 1000; i++) {
        uint64_t t = ip_now();
        ip_end(IP_I_INPUT, 0, t);
    }
    uint64_t full = ip_now() - a;
    printf("IPRO_EMPTY calls=1000 measured=%llu total=%llu\n",
        (unsigned long long)cycles[IP_I_INPUT][0], (unsigned long long)full);
    ip_reset();
}
int ip_report(unsigned logn, uint64_t total)
{
    uint64_t top = 0, ortho_leaves = 0, ntru_leaves = 0;
    for (unsigned op = 0; op < IP_COUNT; op++) {
        for (unsigned l = 0; l <= 10; l++) {
            uint64_t c = cycles[op][l];
            if (op <= IP_FINISH) top += c;
            if (op >= IP_O_INPUT && op <= IP_O_NORM) ortho_leaves += c;
            if (op >= IP_I_INPUT && op <= IP_D_ROUND) ntru_leaves += c;
            if (calls[op][l]) printf("IPRO degree=%u op=%s logn=%u calls=%u cycles=%llu success=%u\n",
                1u<<logn, names[op], l, calls[op][l],
                (unsigned long long)c, success[op][l]);
        }
    }
    errors += top > total || ortho_leaves > cycles[IP_ORTHO][logn]
        || ntru_leaves > cycles[IP_NTRU][logn] || success[IP_NTRU][logn] != 100;
    printf("IPRO_TOTAL degree=%u cycles=%llu top=%llu ortho_leaves=%llu ntru_leaves=%llu errors=%u\n",
        1u<<logn, (unsigned long long)total, (unsigned long long)top,
        (unsigned long long)ortho_leaves, (unsigned long long)ntru_leaves, errors);
    return errors != 0;
}

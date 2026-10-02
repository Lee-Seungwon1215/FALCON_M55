#ifndef DS32_LAYER_PROFILE_H
#define DS32_LAYER_PROFILE_H
#include "api.h"

typedef struct {
    uint32_t cycles[10]; /* lm index, 1..logn-1; zero slot is unused */
    uint32_t scaling;
} ds32_layer_trace;

void ds32_layer_init(void);
void ds32_layer_control_fft(unsigned logn, tw32_fft *f);
void ds32_layer_control_ifft(unsigned logn, tw32_fft *f);
void ds32_layer_profile_fft(unsigned logn, tw32_fft *f, ds32_layer_trace *trace);
void ds32_layer_profile_ifft(unsigned logn, tw32_fft *f, ds32_layer_trace *trace);
unsigned ds32_layer_measure(tw32_fft *work, tw32_fft *expected, uint64_t *input);
#endif

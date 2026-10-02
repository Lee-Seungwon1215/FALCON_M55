#ifndef LOCAL_TWIDDLE_BASELINE_H
#define LOCAL_TWIDDLE_BASELINE_H
#include "tw32_api.h"
void old10_ds32_fft_mve(unsigned logn, tw32_fft *f);
void old10_ds32_ifft_mve(unsigned logn, tw32_fft *f);
void old10_tw32_bridge_fft(unsigned logn, double *f);
void old10_tw32_bridge_ifft(unsigned logn, double *f);
#endif

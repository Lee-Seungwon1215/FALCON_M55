#ifndef APPROX_MEASURE_H
#define APPROX_MEASURE_H
#include <stdint.h>
void approx_begin(unsigned kind, unsigned logn);
void approx_end(unsigned kind, unsigned logn);
void approx_reset(void);
void approx_report(unsigned logn);
#endif

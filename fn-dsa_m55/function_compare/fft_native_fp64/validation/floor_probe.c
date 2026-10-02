#include "kgen_inner.h"
double audit_floor(double x) { return fp64q_floor(x); }
double audit_divzero(double x) { return fp64q_div(x,0.0); }

/* Separate TU: test the ACTUAL candidate helper against the frozen initial. */
#include "../../B_continuous_ds/kgen_ds_q32.h"
q32ds test_candidate_qd_mul(q32ds a, q32ds b) { return qd_mul(a,b); }

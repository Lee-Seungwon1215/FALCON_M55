/* Pre-change hypothesis check. Test-only: no timing claim about host CPU. */
#include "initial_q32_rules.h"
#include <stdio.h>
#include <inttypes.h>
#include <string.h>

static uint64_t rng = UINT64_C(0x73657032376d756c);
static uint64_t next(void) {
    rng ^= rng >> 12; rng ^= rng << 25; rng ^= rng >> 27;
    return rng * UINT64_C(0x2545F4914F6CDD1D);
}
extern q32ds test_candidate_qd_mul(q32ds a, q32ds b);
static int compare(uint64_t x, uint64_t y) {
    q32ds a = qd_from_raw(x), b = qd_from_raw(y);
    q32ds old = qd_mul(a, b), candidate = test_candidate_qd_mul(a, b);
    if (memcmp(&old, &candidate, sizeof old)) {
        printf("MISMATCH x=%016" PRIx64 " y=%016" PRIx64
            " old=%a,%a new=%a,%a\n", x,y,old.h,old.l,candidate.h,candidate.l);
        return 1;
    }
    return 0;
}
int main(void) {
    unsigned failures = 0;
    const uint64_t edge[] = {0,1,UINT64_MAX,UINT64_C(0x100000000),
        UINT64_C(0xffffffff00000000),UINT64_C(0x7fffffffffffffff),
        UINT64_C(0x8000000000000000),UINT64_C(0x8000000000000001)};
    for (unsigned i=0;i<sizeof edge/sizeof *edge;i++)
        for (unsigned j=0;j<sizeof edge/sizeof *edge;j++)
            failures += compare(edge[i],edge[j]);
    for (unsigned i=0;i<1000000;i++) {
        uint64_t x = next(), y = next();
        /* Signed arithmetic scaling covers Q32 small and large operands. */
        x = (uint64_t)((int64_t)x >> (i % 33));
        y = (uint64_t)((int64_t)y >> ((i / 33) % 33));
        failures += compare(x,y);
        if (failures > 12) break;
    }
    printf("DS_MULTIPLY initial_vs_integer_assisted failures=%u\n",failures);
    return failures != 0;
}

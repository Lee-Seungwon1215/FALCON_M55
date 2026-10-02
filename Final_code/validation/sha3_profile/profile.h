#ifndef SHA3_FUNCTION_PROFILE_H
#define SHA3_FUNCTION_PROFILE_H
#include <stdint.h>
enum { OP_KEYGEN, OP_SIGN, OP_VERIFY, OP_COUNT };
enum { CAT_COUNT = 20 };
extern volatile uint32_t profile_error;
void profile_clock_init(void);
void profile_reset(void);
void profile_calibrate(void);
void profile_begin(unsigned degree, unsigned operation);
void profile_end(void);
void profile_enter(unsigned category);
void profile_leave(unsigned category);
void profile_report(void);
#endif

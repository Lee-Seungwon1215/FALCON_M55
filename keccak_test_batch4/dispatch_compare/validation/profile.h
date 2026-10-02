#ifndef BATCH4_PROFILE_H
#define BATCH4_PROFILE_H
#include <stdint.h>
enum { P_OTHER, P_SINGLE_KECCAK, P_INIT, P_INJECT, P_FLIP, P_EXTRACT,
    P_INJECT_CHUNK, P_X4, P_SQUEEZE, P_PREPARE, P_ABSORB, P_EXPORT,
    P_BLOCK, P_READ, P_CLEAR, P_BRIDGE, P_COUNT };
extern volatile uint32_t profile_error;
void profile_reset(void);
void profile_calibrate(void);
void profile_begin(unsigned degree, unsigned op, unsigned variant);
uint64_t profile_end(void);
void profile_enter(unsigned category);
void profile_leave(unsigned category);
void profile_report(void);
void profile_mask(unsigned mask);
void profile_watch_begin(void);
unsigned profile_watch_end(void);
#endif

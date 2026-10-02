/* Measurement only. Never touch FP/MVE registers: wrappers may surround ASM. */
#include "profile.h"
#include <zephyr/kernel.h>
#include <stdio.h>
#include <string.h>

struct stats {
    uint64_t self[P_COUNT], inclusive[P_COUNT], total;
    uint32_t calls[P_COUNT], children[P_COUNT], batches;
};
static struct stats stats[2][2];
static struct { unsigned parent, cat; uint64_t start; } frames[16];
static struct stats *row;
static unsigned active, depth, current;
static uint64_t previous, started;
volatile uint32_t profile_error;
static uint64_t ticks(void) { return k_cycle_get_64(); }
void profile_reset(void)
{
    memset(stats, 0, sizeof stats);
    active = depth = current = profile_error = 0;
}
void profile_begin(unsigned degree, unsigned op, unsigned variant)
{
    if (active || degree > 1 || op > 1 || variant > 1) {
        profile_error |= 1; return;
    }
    row = &stats[degree][variant];
    active = 1; depth = current = 0;
    started = previous = ticks();
}
void profile_enter(unsigned cat)
{
    if (!active) return;
    uint64_t now = ticks();
    if (!cat || cat >= P_COUNT || depth == 16) { profile_error |= 2; return; }
    row->self[current] += now - previous;
    row->children[current]++; row->calls[cat]++;
    frames[depth].parent = current; frames[depth].cat = cat;
    frames[depth++].start = now;
    current = cat; previous = now;
}
void profile_leave(unsigned cat)
{
    if (!active) return;
    uint64_t now = ticks();
    if (!depth || frames[depth-1].cat != cat) { profile_error |= 4; return; }
    row->self[current] += now - previous;
    --depth;
    row->inclusive[cat] += now - frames[depth].start;
    current = frames[depth].parent; previous = now;
}
uint64_t profile_end(void)
{
    if (!active || depth) { profile_error |= 8; return 0; }
    uint64_t now = ticks(), elapsed = now - started;
    row->self[current] += now - previous;
    row->total += elapsed; row->batches++; active = 0;
    uint64_t sum = 0;
    for (unsigned i=0;i<P_COUNT;i++) sum += row->self[i];
    if (sum != row->total) profile_error |= 16;
    return elapsed;
}
extern void profile_empty(void), profile_raw_empty(void);
void profile_calibrate(void)
{
    const unsigned runs=4000;
    profile_reset();
    for (unsigned i=0;i<runs;i++) {
        profile_begin(0,0,0); profile_empty(); profile_end();
    }
    uint64_t total=stats[0][0].total, self=stats[0][0].self[1];
    profile_reset();
    for (unsigned i=0;i<runs;i++) {
        profile_begin(0,0,0); profile_raw_empty(); profile_end();
    }
    printf("CALIBRATION runs=%u wrapped=%llu self=%llu raw=%llu\n",runs,
        (unsigned long long)total,(unsigned long long)self,
        (unsigned long long)stats[0][0].total);
    profile_reset();
}
void profile_report(void)
{
    static const char *const names[P_COUNT]={"other","single_keccak","shake_init",
        "shake_inject","shake_flip","shake_extract","inject_chunk","x4_permute",
        "x4_squeeze","batch_prepare","batch_absorb","batch_export","batch_block",
        "sampler_extract","batch_clear"};
    const unsigned op=PROFILE_KEYGEN?0:1;
    for (unsigned d=0;d<2;d++)
        for(unsigned v=0;v<2;v++) {
            struct stats *s=&stats[d][v];
            printf("TOTAL n=%u op=%u variant=%u batches=%u cycles=%llu\n",
                512u<<d,op,v,s->batches,(unsigned long long)s->total);
            for(unsigned c=0;c<P_COUNT;c++)
                printf("CATEGORY n=%u op=%u variant=%u name=%s cycles=%llu calls=%u children=%u inclusive=%llu\n",
                    512u<<d,op,v,names[c],(unsigned long long)s->self[c],
                    s->calls[c],s->children[c],(unsigned long long)s->inclusive[c]);
        }
}

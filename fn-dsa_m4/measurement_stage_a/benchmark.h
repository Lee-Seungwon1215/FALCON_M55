#ifndef FNDSA_M4_BENCHMARK_H
#define FNDSA_M4_BENCHMARK_H
#include <stdint.h>
#define BENCH_RUNS 100
#define BENCH_MAGIC 0x464D3450u
#define BENCH_READY 0x52454144u
#define BENCH_RUNNING 0x52554E21u
#define BENCH_DONE 0x600D0000u
#define BENCH_FAILED 0xBAD00000u
#define BENCH_GO 0x474F3130u
/* All fields are 32-bit words. Place on a separate SRAM bank so debugger
 * polling does not access the bank used for algorithm data and stack. */
struct bench_results {
    uint32_t magic, version, state, error;
    uint32_t runs, degree, iteration, operation;
    uint32_t cpuid, device_id, core_clock_hz, flash_acr;
    uint32_t pwr_cr1, pwr_cr5, rcc_cr, rcc_cfgr;
    uint32_t vtor, primask, assembly, gcc_version;
    uint32_t counts[2][3];
    uint32_t warmup_fingerprint[2], fingerprint[2];
    uint32_t command, fault_cfsr, fault_hfsr, fault_bfar;
    uint32_t cycles[2][3][BENCH_RUNS];
};
extern volatile struct bench_results bench_results;
void platform_init(void);
void platform_finish(void);
void benchmark_fail(uint32_t error);
#endif

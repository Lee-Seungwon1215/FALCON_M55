#ifndef FNDSA_CONTROLLED_BENCHMARK_H
#define FNDSA_CONTROLLED_BENCHMARK_H
#include <stdint.h>
#define BENCH_RUNS 100
#define BENCH_MAGIC 0x46434D50u
#define BENCH_READY 0x52454144u
#define BENCH_RUNNING 0x52554E21u
#define BENCH_DONE 0x600D0000u
#define BENCH_FAILED 0xBAD00000u
#define BENCH_GO 0x474F3130u
/* 100 header words + 600 uint64 cycles + 600 uint32 microseconds = 7600 B. */
struct bench_results {
    uint32_t magic, version, state, error, runs, degree, iteration, operation;
    uint32_t cpuid, core_clock_hz, hclk_hz, cache_control;
    uint32_t vtor, primask, assembly, m55_compat, gcc_version, mve_compiled;
    uint32_t mvfr0, mvfr1, mvfr2, cpacr, fpscr, mpu_ctrl;
    uint32_t counts[2][3], warmup_fingerprint[2], fingerprint[2];
    uint32_t command, fault_cfsr, fault_hfsr, fault_bfar, fault_sfsr, fault_sfar;
    uint32_t device_id, flash_acr, pclk1_hz, pclk2_hz, pclk4_hz, pclk5_hz;
    uint32_t clock_registers[12], mem_remap, dwt_control;
    uint32_t output_digest[2][8], warmup_digest[2][8];
    uint32_t timer_kernel_hz, timer_psc, timer_cr1, timer_arr, timer_dier;
    uint32_t max_timer_error_cycles, timer_kernel_config, reserved;
    uint64_t cycles[2][3][BENCH_RUNS];
    uint32_t microseconds[2][3][BENCH_RUNS];
};
extern volatile struct bench_results bench_results;
void platform_memory_init(void);
void platform_init(void);
void benchmark_timer_start(uint32_t kernel_hz);
void platform_finish(void) __attribute__((noreturn));
void benchmark_fail(uint32_t error) __attribute__((noreturn));
#endif

#include "main.h"
#include <stdint.h>
extern volatile uint32_t fndsa_bench_core_clock_hz, fndsa_bench_cpuid;
extern volatile uint32_t fndsa_bench_device_id, fndsa_bench_cache_control;
void SystemClock_Config(void);
void platform_init(void)
{
    SCB_EnableICache();
    SCB_EnableDCache();
    HAL_Init();
    SystemClock_Config();
    fndsa_bench_core_clock_hz = SystemCoreClock;
    fndsa_bench_cpuid = SCB->CPUID;
    fndsa_bench_cache_control = SCB->CCR;
    fndsa_bench_device_id = DBGMCU->IDCODE;
}
void platform_finish(void)
{
    SCB_CleanDCache();
    __DSB();
    __ISB();
    __BKPT(0);
    for (;;) { }
}

#include "benchmark.h"
#include "main.h"
#include "m-profile/armv8m_mpu.h"

void SystemClock_Config(void);

void _init(void) { }
void _fini(void) { }
void SysTick_Handler(void) { HAL_IncTick(); }
static void fault(uint32_t n)
{
    bench_results.fault_cfsr = SCB->CFSR;
    bench_results.fault_hfsr = SCB->HFSR;
    bench_results.fault_bfar = SCB->BFAR;
    bench_results.fault_sfsr = SAU->SFSR;
    bench_results.fault_sfar = SAU->SFAR;
    benchmark_fail(n);
}
void HardFault_Handler(void) { fault(0xF1); }
void MemManage_Handler(void) { fault(0xF2); }
void BusFault_Handler(void) { fault(0xF3); }
void UsageFault_Handler(void) { fault(0xF4); }
void SecureFault_Handler(void) { fault(0xF5); }
void NMI_Handler(void) { fault(0xF6); }
void Error_Handler(void) { benchmark_fail(0x81); }

void platform_memory_init(void)
{
    SCB_DisableDCache();
    SCB_DisableICache();
    ARM_MPU_Disable();
    unsigned regions = (MPU->TYPE & MPU_TYPE_DREGION_Msk) >> MPU_TYPE_DREGION_Pos;
    for (unsigned i = 0; i < regions; i++) ARM_MPU_ClrRegion(i);
    ARM_MPU_SetMemAttr(0, ARM_MPU_ATTR(ARM_MPU_ATTR_NON_CACHEABLE, ARM_MPU_ATTR_NON_CACHEABLE));
    ARM_MPU_SetRegion(0, ARM_MPU_RBAR(0x341FF000u, ARM_MPU_SH_INNER, 0, 0, 1),
        ARM_MPU_RLAR(0x341FFFFFu, 0));
    ARM_MPU_Enable(MPU_CTRL_PRIVDEFENA_Msk);
    SCB_EnableICache();
    SCB_EnableDCache();
}
void platform_init(void)
{
    HAL_Init();
    SystemClock_Config();
    SystemCoreClockUpdate();
    bench_results.cpuid = SCB->CPUID;
    bench_results.core_clock_hz = SystemCoreClock;
    bench_results.hclk_hz = HAL_RCC_GetHCLKFreq();
    bench_results.cache_control = SCB->CCR;
    bench_results.vtor = SCB->VTOR;
    bench_results.mvfr0 = FPU->MVFR0;
    bench_results.mvfr1 = FPU->MVFR1;
    bench_results.mvfr2 = FPU->MVFR2;
    bench_results.cpacr = SCB->CPACR;
    bench_results.fpscr = __get_FPSCR();
    bench_results.mpu_ctrl = MPU->CTRL;
    if (SystemCoreClock != 600000000u || SCB->VTOR != 0x34180400u)
        benchmark_fail(0x82);
    if ((SCB->CCR & (SCB_CCR_IC_Msk | SCB_CCR_DC_Msk)) != (SCB_CCR_IC_Msk | SCB_CCR_DC_Msk))
        benchmark_fail(0x83);
    SysTick->CTRL = 0;
    __disable_irq();
    bench_results.primask = __get_PRIMASK();
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    *((volatile uint32_t *)0xE0001FB0u) = 0xC5ACCE55u;
    DWT->CYCCNT = 0;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    __DSB();
    __ISB();
}
void platform_finish(void)
{
    __disable_irq();
    __DSB();
    for (;;) { __WFI(); }
}

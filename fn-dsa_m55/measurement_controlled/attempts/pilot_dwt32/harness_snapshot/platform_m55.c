#include "benchmark.h"
#include "main.h"
#include "m-profile/armv8m_mpu.h"
void SystemClock_Config(void);
void _init(void) { }
void _fini(void) { }
void SysTick_Handler(void) { HAL_IncTick(); }
static void fault(uint32_t n)
{
    bench_results.fault_cfsr = SCB->CFSR; bench_results.fault_hfsr = SCB->HFSR;
    bench_results.fault_bfar = SCB->BFAR;
    bench_results.fault_sfsr = SAU->SFSR; bench_results.fault_sfar = SAU->SFAR;
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
    SCB_DisableDCache(); SCB_DisableICache(); ARM_MPU_Disable();
    unsigned regions = (MPU->TYPE & MPU_TYPE_DREGION_Msk) >> MPU_TYPE_DREGION_Pos;
    for (unsigned i = 0; i < regions; i++) ARM_MPU_ClrRegion(i);
    ARM_MPU_SetMemAttr(0, ARM_MPU_ATTR(ARM_MPU_ATTR_NON_CACHEABLE, ARM_MPU_ATTR_NON_CACHEABLE));
    /* Code, constants, data and mailbox all Normal non-cacheable. */
    ARM_MPU_SetRegion(0, ARM_MPU_RBAR(0x34180000u, ARM_MPU_SH_INNER, 0, 0, 0),
        ARM_MPU_RLAR(0x341FFFFFu, 0));
    ARM_MPU_Enable(MPU_CTRL_PRIVDEFENA_Msk);
}
void platform_init(void)
{
    HAL_Init(); SystemClock_Config(); SystemCoreClockUpdate();
    bench_results.cpuid = SCB->CPUID;
    bench_results.core_clock_hz = SystemCoreClock;
    bench_results.hclk_hz = HAL_RCC_GetHCLKFreq();
    bench_results.pclk1_hz = HAL_RCC_GetPCLK1Freq();
    bench_results.pclk2_hz = HAL_RCC_GetPCLK2Freq();
    bench_results.pclk4_hz = HAL_RCC_GetPCLK4Freq();
    bench_results.pclk5_hz = HAL_RCC_GetPCLK5Freq();
    bench_results.cache_control = SCB->CCR; bench_results.vtor = SCB->VTOR;
    bench_results.mvfr0 = FPU->MVFR0; bench_results.mvfr1 = FPU->MVFR1;
    bench_results.mvfr2 = FPU->MVFR2; bench_results.cpacr = SCB->CPACR;
    bench_results.fpscr = __get_FPSCR(); bench_results.mpu_ctrl = MPU->CTRL;
    bench_results.clock_registers[0] = RCC->CFGR1;
    bench_results.clock_registers[1] = RCC->CFGR2;
    bench_results.clock_registers[2] = RCC->IC1CFGR;
    bench_results.clock_registers[3] = RCC->IC2CFGR;
    bench_results.clock_registers[4] = RCC->IC6CFGR;
    bench_results.clock_registers[5] = RCC->IC11CFGR;
    bench_results.clock_registers[6] = RCC->PLL1CFGR1;
    bench_results.clock_registers[7] = RCC->PLL1CFGR2;
    bench_results.clock_registers[8] = RCC->PLL1CFGR3;
    bench_results.clock_registers[9] = RCC->HSICFGR;
    bench_results.clock_registers[10] = HAL_RCC_GetSysClockFreq();
    bench_results.clock_registers[11] = HAL_RCC_GetCpuClockFreq();
    if (SystemCoreClock != 24000000u || bench_results.hclk_hz != 24000000u
        || bench_results.pclk1_hz != 24000000u || bench_results.pclk2_hz != 24000000u
        || bench_results.pclk4_hz != 24000000u || bench_results.pclk5_hz != 24000000u)
        benchmark_fail(0x82);
    if (SCB->VTOR != 0x34180400u || (SCB->CCR & (SCB_CCR_IC_Msk | SCB_CCR_DC_Msk)))
        benchmark_fail(0x83);
    SysTick->CTRL = 0; __disable_irq();
    bench_results.primask = __get_PRIMASK();
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    *((volatile uint32_t *)0xE0001FB0u) = 0xC5ACCE55u;
    DWT->CYCCNT = 0; DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    bench_results.dwt_control = DWT->CTRL;
    __DSB(); __ISB();
}
void platform_finish(void)
{
    __disable_irq(); __DSB();
    for (;;) { __NOP(); }
}

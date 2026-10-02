#include "benchmark.h"
#include "stm32l4xx_hal.h"

/* ST startup calls newlib constructors; no CRT start files are linked. */
void _init(void) { }
void _fini(void) { }

void SysTick_Handler(void) { HAL_IncTick(); }
static void fault(uint32_t n)
{
    bench_results.fault_cfsr = SCB->CFSR;
    bench_results.fault_hfsr = SCB->HFSR;
    bench_results.fault_bfar = SCB->BFAR;
    benchmark_fail(n);
}
void HardFault_Handler(void) { fault(0xF1); }
void MemManage_Handler(void) { fault(0xF2); }
void BusFault_Handler(void) { fault(0xF3); }
void UsageFault_Handler(void) { fault(0xF4); }
void platform_init(void)
{
    bench_results.cpuid = SCB->CPUID;
    bench_results.device_id = DBGMCU->IDCODE;
    if ((DBGMCU->IDCODE & 0xFFFu) != 0x470u) benchmark_fail(0x81);
    HAL_Init();
    __HAL_RCC_PWR_CLK_ENABLE();
    if (HAL_PWREx_ControlVoltageScaling(PWR_REGULATOR_VOLTAGE_SCALE1) != HAL_OK)
        benchmark_fail(0x82);
    /* L4R/L4S Flash needs >=1 wait state at 24 MHz (RM0432 table 12).
     * Set latency before raising the MSI clock. Unlike F407, 0WS is invalid. */
    __HAL_FLASH_SET_LATENCY(FLASH_LATENCY_1);
    __HAL_FLASH_PREFETCH_BUFFER_DISABLE();
    __HAL_FLASH_INSTRUCTION_CACHE_DISABLE();
    __HAL_FLASH_DATA_CACHE_DISABLE();
    __HAL_FLASH_INSTRUCTION_CACHE_RESET();
    __HAL_FLASH_DATA_CACHE_RESET();
    RCC_OscInitTypeDef osc = {0};
    osc.OscillatorType = RCC_OSCILLATORTYPE_MSI;
    osc.MSIState = RCC_MSI_ON;
    osc.MSICalibrationValue = 0;
    osc.MSIClockRange = RCC_MSIRANGE_9; /* nominal 24 MHz */
    osc.PLL.PLLState = RCC_PLL_OFF;
    if (HAL_RCC_OscConfig(&osc) != HAL_OK) benchmark_fail(0x83);
    RCC_ClkInitTypeDef clk = {0};
    clk.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK
        | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2;
    clk.SYSCLKSource = RCC_SYSCLKSOURCE_MSI;
    clk.AHBCLKDivider = RCC_SYSCLK_DIV1;
    clk.APB1CLKDivider = RCC_HCLK_DIV2;
    clk.APB2CLKDivider = RCC_HCLK_DIV1;
    if (HAL_RCC_ClockConfig(&clk, FLASH_LATENCY_1) != HAL_OK) benchmark_fail(0x84);
    SystemCoreClockUpdate();
    bench_results.core_clock_hz = SystemCoreClock;
    bench_results.flash_acr = FLASH->ACR;
    bench_results.pwr_cr1 = PWR->CR1;
    bench_results.pwr_cr5 = PWR->CR5;
    bench_results.rcc_cr = RCC->CR;
    bench_results.rcc_cfgr = RCC->CFGR;
    bench_results.vtor = SCB->VTOR;
    if (SystemCoreClock != 24000000u || (FLASH->ACR & 0x70Fu) != 1u)
        benchmark_fail(0x85);
    if (SCB->VTOR != 0x081C0000u) benchmark_fail(0x86);
    SysTick->CTRL = 0;
    __disable_irq();
    bench_results.primask = __get_PRIMASK();
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
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

#include "benchmark.h"
#include "stm32l4xx_hal.h"
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
void NMI_Handler(void) { fault(0xF6); }
void platform_memory_init(void) { MPU->CTRL = 0; __DSB(); __ISB(); }
void platform_init(void)
{
    if ((DBGMCU->IDCODE & 0xFFFu) != 0x470u) benchmark_fail(0x81);
    HAL_Init();
    __HAL_RCC_PWR_CLK_ENABLE();
    __HAL_RCC_SYSCFG_CLK_ENABLE();
    if (HAL_PWREx_ControlVoltageScaling(PWR_REGULATOR_VOLTAGE_SCALE1) != HAL_OK)
        benchmark_fail(0x82);
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
    osc.MSIClockRange = RCC_MSIRANGE_9;
    osc.PLL.PLLState = RCC_PLL_OFF;
    if (HAL_RCC_OscConfig(&osc) != HAL_OK) benchmark_fail(0x83);
    RCC_ClkInitTypeDef clk = {0};
    clk.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK
        | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2;
    clk.SYSCLKSource = RCC_SYSCLKSOURCE_MSI;
    clk.AHBCLKDivider = RCC_SYSCLK_DIV1;
    clk.APB1CLKDivider = RCC_HCLK_DIV1;
    clk.APB2CLKDivider = RCC_HCLK_DIV1;
    if (HAL_RCC_ClockConfig(&clk, FLASH_LATENCY_1) != HAL_OK) benchmark_fail(0x84);
    SystemCoreClockUpdate();
    bench_results.cpuid = SCB->CPUID;
    bench_results.device_id = DBGMCU->IDCODE;
    bench_results.core_clock_hz = SystemCoreClock;
    bench_results.hclk_hz = HAL_RCC_GetHCLKFreq();
    bench_results.pclk1_hz = HAL_RCC_GetPCLK1Freq();
    bench_results.pclk2_hz = HAL_RCC_GetPCLK2Freq();
    bench_results.flash_acr = FLASH->ACR;
    bench_results.cache_control = SCB->CCR;
    bench_results.vtor = SCB->VTOR;
    bench_results.cpacr = SCB->CPACR;
    bench_results.fpscr = __get_FPSCR();
    bench_results.mpu_ctrl = MPU->CTRL;
    bench_results.mem_remap = SYSCFG->MEMRMP;
    bench_results.clock_registers[0] = RCC->CR;
    bench_results.clock_registers[1] = RCC->CFGR;
    bench_results.clock_registers[2] = RCC->PLLCFGR;
    bench_results.clock_registers[3] = RCC->APB2ENR;
    bench_results.clock_registers[4] = PWR->CR1;
    bench_results.clock_registers[5] = PWR->CR5;
    if (SystemCoreClock != 24000000u || bench_results.hclk_hz != 24000000u
        || bench_results.pclk1_hz != 24000000u || bench_results.pclk2_hz != 24000000u)
        benchmark_fail(0x85);
    if (SCB->VTOR != 0x20000400u || (SYSCFG->MEMRMP & 7) != 3
        || (FLASH->ACR & 0x70Fu) != 1u) benchmark_fail(0x86);
    SysTick->CTRL = 0; __disable_irq();
    __HAL_RCC_TIM2_CLK_ENABLE(); __HAL_RCC_TIM2_FORCE_RESET(); __HAL_RCC_TIM2_RELEASE_RESET();
    benchmark_timer_start(HAL_RCC_GetPCLK1Freq());
    bench_results.primask = __get_PRIMASK();
    CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    DWT->CYCCNT = 0; DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
    bench_results.dwt_control = DWT->CTRL;
    __DSB(); __ISB();
}
void platform_finish(void)
{
    __disable_irq(); __DSB();
    /* Avoid WFI: the previous L4 measurement could not read SRAM in sleep. */
    for (;;) { __NOP(); }
}

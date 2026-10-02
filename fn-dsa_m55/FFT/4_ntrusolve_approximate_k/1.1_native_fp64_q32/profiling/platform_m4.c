/* STM32L4R/L4S (device ID 0x470), SRAM-only benchmark at nominal 120 MHz.
 * Clock setup follows ST's MSI -> PLL range-1 boost configuration.
 * No external oscillator, board-specific pins, or Flash writes are needed.
 */
#include "stm32l4xx_hal.h"
#include <stdint.h>
extern volatile uint32_t fndsa_bench_core_clock_hz, fndsa_bench_cpuid;
extern volatile uint32_t fndsa_bench_device_id, fndsa_bench_cache_control;
extern volatile uint32_t fndsa_bench_state, fndsa_bench_error;
void platform_finish(void);

static void failed(unsigned code)
{
    fndsa_bench_state = 0xBAD10000u | code;
    fndsa_bench_error = code;
    platform_finish();
}
void SysTick_Handler(void) { HAL_IncTick(); }
void HardFault_Handler(void) { failed(0xF1); }
void MemManage_Handler(void) { failed(0xF2); }
void BusFault_Handler(void) { failed(0xF3); }
void UsageFault_Handler(void) { failed(0xF4); }

void platform_init(void)
{
    fndsa_bench_state = 0x10000100;
    fndsa_bench_cpuid = SCB->CPUID;
    fndsa_bench_device_id = DBGMCU->IDCODE;
    if ((DBGMCU->IDCODE & 0xFFF) != 0x470) failed(0x10);
    HAL_Init();
    __HAL_RCC_PWR_CLK_ENABLE();
    if (HAL_PWREx_ControlVoltageScaling(PWR_REGULATOR_VOLTAGE_SCALE1_BOOST) != HAL_OK)
        failed(0x11);
    RCC_OscInitTypeDef osc = {0};
    osc.OscillatorType = RCC_OSCILLATORTYPE_MSI;
    osc.MSIState = RCC_MSI_ON;
    osc.MSICalibrationValue = 0;
    osc.MSIClockRange = RCC_MSIRANGE_6;
    osc.PLL.PLLState = RCC_PLL_ON;
    osc.PLL.PLLSource = RCC_PLLSOURCE_MSI;
    osc.PLL.PLLM = 1;
    osc.PLL.PLLN = 60;
    osc.PLL.PLLP = RCC_PLLP_DIV5;
    osc.PLL.PLLQ = RCC_PLLQ_DIV2;
    osc.PLL.PLLR = RCC_PLLR_DIV2;
    if (HAL_RCC_OscConfig(&osc) != HAL_OK) failed(0x12);
    RCC_ClkInitTypeDef clk = {0};
    clk.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK
        | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2;
    clk.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
    clk.AHBCLKDivider = RCC_SYSCLK_DIV1;
    clk.APB1CLKDivider = RCC_HCLK_DIV1;
    clk.APB2CLKDivider = RCC_HCLK_DIV1;
    if (HAL_RCC_ClockConfig(&clk, FLASH_LATENCY_5) != HAL_OK) failed(0x13);
    SystemCoreClockUpdate();
    fndsa_bench_core_clock_hz = SystemCoreClock;
    fndsa_bench_cache_control = FLASH->ACR;
    if (SystemCoreClock != 120000000) failed(0x14);
}
void platform_finish(void)
{
    __disable_irq();
    __DSB();
    __ISB();
    __BKPT(0);
    for (;;) { }
}

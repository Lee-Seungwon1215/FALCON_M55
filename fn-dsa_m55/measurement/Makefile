ARM_GCC_ROOT ?= /private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi
STM32CUBE_N6 ?= /private/tmp/STM32CubeN6
PREFIX = $(ARM_GCC_ROOT)/bin/arm-none-eabi-
CC = $(PREFIX)gcc
BUILD = build
HAL = $(STM32CUBE_N6)/Drivers/STM32N6xx_HAL_Driver
CMSIS = $(STM32CUBE_N6)/Drivers/CMSIS
DEVICE = $(CMSIS)/Device/ST/STM32N6xx
TEMPLATE = $(STM32CUBE_N6)/Projects/NUCLEO-N657X0-Q/Templates/Template/FSBL
# M4-assembly compatibility baseline: no MVE generation, no native-FP64 rewrite.
ARCH = -mthumb -mcpu=cortex-m55+nomve -mfpu=auto -mfloat-abi=hard -mcmse
SOURCES = codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy
ASM = codec_cm4 mq_cm4 sha3_cm4 sign_fpr_cm4 sign_sampler_cm4
CRYPTO = $(addprefix ../ref/,$(addsuffix .c,$(SOURCES))) $(addprefix ../ref/,$(addsuffix .s,$(ASM)))
PLATFORM = $(TEMPLATE)/Src/system_stm32n6xx_fsbl.c $(TEMPLATE)/Src/stm32n6xx_hal_msp.c \
 $(DEVICE)/Source/Templates/gcc/startup_stm32n657xx_fsbl.s \
 $(addprefix $(HAL)/Src/stm32n6xx_hal,$(addsuffix .c, _cortex _dma _dma_ex _exti _gpio _pwr _pwr_ex _rcc _rcc_ex)) \
 $(HAL)/Src/stm32n6xx_hal.c
CFLAGS = -Wall -Wextra -Wshadow -Wundef -Wno-unused-function -Wno-cast-function-type \
 -std=c99 -ggdb3 -O3 $(ARCH) -fno-common -ffunction-sections -fdata-sections \
 -DFNDSA_ASM_CORTEXM4=1 -DFNDSA_ASM_CORTEXM55=1 -DUSE_HAL_DRIVER -DSTM32N657xx \
 -I. -I../ref -I$(TEMPLATE)/Inc -I$(STM32CUBE_N6)/Drivers/BSP/STM32N6xx_Nucleo \
 -I$(HAL)/Inc -I$(HAL)/Inc/Legacy -I$(DEVICE)/Include -I$(CMSIS)/Include
LDFLAGS = --static -nostartfiles -Tstm32n657_sram.ld -ggdb3 $(ARCH) \
 -Wl,--gc-sections -Wl,-Map=$(BUILD)/fndsa_m55.map -Wl,--print-memory-usage
LIBS = -Wl,--start-group -lc -lgcc -lm -lnosys -Wl,--end-group
.PHONY: all
all: $(BUILD)/fndsa_m55.elf
$(BUILD):
	mkdir -p $(BUILD)
$(BUILD)/fndsa_m55.elf: $(CRYPTO) $(wildcard ../ref/*.h) benchmark.c benchmark.h platform.c clock.c stm32n657_sram.ld Makefile | $(BUILD)
	$(CC) --version
	$(CC) $(CFLAGS) $(CRYPTO) benchmark.c platform.c clock.c $(PLATFORM) $(LDFLAGS) $(LIBS) -o $@
	$(PREFIX)size $@
	$(PREFIX)objcopy -O binary $@ $(BUILD)/fndsa_m55.bin
	$(PREFIX)nm -n $@ > $(BUILD)/symbols.txt
	$(PREFIX)objdump -d $@ > $(BUILD)/disassembly.txt
	$(PREFIX)readelf -l -A $@ > $(BUILD)/elf_attributes.txt

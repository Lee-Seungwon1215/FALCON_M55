ARM_GCC_ROOT ?= /private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi
STM32L4_SYSTEM ?= /Users/seungwon/.platformio/packages/framework-arduinoststm32/system
CMSIS_CORE ?= /Users/seungwon/.platformio/packages/framework-cmsis/CMSIS/Core/Include
BUILD = build
PREFIX = $(ARM_GCC_ROOT)/bin/arm-none-eabi-
CC = $(PREFIX)gcc
HAL = $(STM32L4_SYSTEM)/Drivers/STM32L4xx_HAL_Driver
DEVICE = $(STM32L4_SYSTEM)/Drivers/CMSIS/Device/ST/STM32L4xx
ARCH = -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
SOURCES = codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy
ASM = codec_cm4 mq_cm4 sha3_cm4 sign_fpr_cm4 sign_sampler_cm4
CRYPTO = $(addprefix ../ref/,$(addsuffix .c,$(SOURCES))) $(addprefix ../ref/,$(addsuffix .s,$(ASM)))
PLATFORM = $(DEVICE)/Source/Templates/system_stm32l4xx.c \
 $(DEVICE)/Source/Templates/gcc/startup_stm32l4r5xx.s \
 $(addprefix $(HAL)/Src/stm32l4xx_hal,$(addsuffix .c, _cortex _rcc _rcc_ex _pwr _pwr_ex)) \
 $(HAL)/Src/stm32l4xx_hal.c
CFLAGS = -Wall -Wextra -Wshadow -Wundef -Wno-unused-function -Wno-cast-function-type \
 -std=c99 -ggdb3 -O3 $(ARCH) -fno-common -ffunction-sections -fdata-sections \
 -DFNDSA_ASM_CORTEXM4=1 -DUSE_HAL_DRIVER -DSTM32L4R5xx \
 -DUSER_VECT_TAB_ADDRESS -DVECT_TAB_OFFSET=0x001C0000U \
 -I. -I../ref -I$(HAL)/Inc -I$(HAL)/Inc/Legacy -I$(DEVICE)/Include -I$(CMSIS_CORE)
LDFLAGS = --static -nostartfiles -Tstm32l4rs_flash.ld -ggdb3 $(ARCH) \
 -Wl,--gc-sections -Wl,-Map=$(BUILD)/fndsa_m4.map -Wl,--print-memory-usage
LIBS = -Wl,--start-group -lc -lgcc -lm -lnosys -Wl,--end-group
.PHONY: all host
all: $(BUILD)/fndsa_m4.elf
$(BUILD):
	mkdir -p $(BUILD)
$(BUILD)/fndsa_m4.elf: $(CRYPTO) $(wildcard ../ref/*.h) benchmark.c benchmark.h platform.c stm32l4xx_hal_conf.h stm32l4rs_flash.ld Makefile | $(BUILD)
	$(CC) --version
	$(CC) $(CFLAGS) $(CRYPTO) benchmark.c platform.c $(PLATFORM) $(LDFLAGS) $(LIBS) -o $@
	$(PREFIX)size $@
	$(PREFIX)objcopy -O binary $@ $(BUILD)/fndsa_m4.bin
	$(PREFIX)nm -n $@ > $(BUILD)/symbols.txt
# Portable scalar C oracle from the already validated disposable copies.
# Its pre-existing scalar-helper restoration is NOT applied to the M4 build.
HOST_GEN = ../../fn-dsa_ref/profiling/build/host-0/generated
host: | $(BUILD)
	clang -O3 -std=c99 -DBENCH_HOST -DFNDSA_PROFILE=0 -DFNDSA_ASM_CORTEXM4=0 \
 -DFNDSA_AVX2=0 -DFNDSA_SSE2=0 -DFNDSA_NEON=0 -DFNDSA_NEON_SHA3=0 -DFNDSA_RV64D=0 -DFNDSA_64=0 \
 -I. -I../ref -I../../fn-dsa_ref/profiling benchmark.c \
 $(addprefix $(HOST_GEN)/,$(addsuffix .c,$(SOURCES))) -lm -o $(BUILD)/host_oracle
	$(BUILD)/host_oracle > $(BUILD)/host_oracle.json

BOARD ?= m4
ARM_GCC_ROOT ?= /private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi
PREFIX = $(ARM_GCC_ROOT)/bin/arm-none-eabi-
CC = $(PREFIX)gcc
REF = ../fn-dsa_$(BOARD)/ref
BUILD = ../fn-dsa_$(BOARD)/measurement_controlled/build
SOURCES = codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy
ASM = codec_cm4 mq_cm4 sha3_cm4 sign_fpr_cm4 sign_sampler_cm4
CRYPTO = $(addprefix $(REF)/,$(addsuffix .c,$(SOURCES))) $(addprefix $(REF)/,$(addsuffix .s,$(ASM)))
COMMON = -Wall -Wextra -Wshadow -Wundef -Wno-unused-function -Wno-cast-function-type -std=c99 -ggdb3 -O3 -fno-common -ffunction-sections -fdata-sections -ffp-contract=off
ifeq ($(BOARD),m4)
SYSTEM = /Users/seungwon/.platformio/packages/framework-arduinoststm32/system
HAL = $(SYSTEM)/Drivers/STM32L4xx_HAL_Driver
DEVICE = $(SYSTEM)/Drivers/CMSIS/Device/ST/STM32L4xx
CMSIS = /Users/seungwon/.platformio/packages/framework-cmsis/CMSIS/Core/Include
ARCH = -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
DEFS = -DBENCH_M4 -DSTM32L4R5xx -DUSER_VECT_TAB_ADDRESS -DVECT_TAB_SRAM -DVECT_TAB_OFFSET=0x400U
INCLUDES = -I../fn-dsa_m4/measurement -I$(CMSIS)
PLATFORM = $(DEVICE)/Source/Templates/system_stm32l4xx.c $(DEVICE)/Source/Templates/gcc/startup_stm32l4r5xx.s \
 $(addprefix $(HAL)/Src/stm32l4xx_hal,$(addsuffix .c, _cortex _rcc _rcc_ex _pwr _pwr_ex)) $(HAL)/Src/stm32l4xx_hal.c
else ifeq ($(BOARD),m55)
CUBE = /private/tmp/STM32CubeN6
HAL = $(CUBE)/Drivers/STM32N6xx_HAL_Driver
CMSIS = $(CUBE)/Drivers/CMSIS
DEVICE = $(CMSIS)/Device/ST/STM32N6xx
TEMPLATE = $(CUBE)/Projects/NUCLEO-N657X0-Q/Templates/Template/FSBL
ARCH = -mthumb -mcpu=cortex-m55+nomve -mfpu=auto -mfloat-abi=hard -mcmse
DEFS = -DSTM32N657xx -DFNDSA_ASM_CORTEXM55=1
INCLUDES = -I$(TEMPLATE)/Inc -I$(CUBE)/Drivers/BSP/STM32N6xx_Nucleo -I$(CMSIS)/Include
PLATFORM = clock_m55.c $(TEMPLATE)/Src/system_stm32n6xx_fsbl.c $(TEMPLATE)/Src/stm32n6xx_hal_msp.c \
 $(DEVICE)/Source/Templates/gcc/startup_stm32n657xx_fsbl.s \
 $(addprefix $(HAL)/Src/stm32n6xx_hal,$(addsuffix .c, _cortex _dma _dma_ex _exti _gpio _pwr _pwr_ex _rcc _rcc_ex)) $(HAL)/Src/stm32n6xx_hal.c
else
$(error BOARD must be m4 or m55)
endif
CFLAGS = $(COMMON) $(ARCH) -DFNDSA_ASM_CORTEXM4=1 -DUSE_HAL_DRIVER $(DEFS) -I. -I$(REF) $(INCLUDES) -I$(HAL)/Inc -I$(HAL)/Inc/Legacy -I$(DEVICE)/Include
LDFLAGS = --static -nostartfiles -T$(BOARD).ld -ggdb3 $(ARCH) -Wl,--gc-sections -Wl,-Map=$(BUILD)/firmware.map -Wl,--print-memory-usage
LIBS = -Wl,--start-group -lc -lgcc -lm -lnosys -Wl,--end-group
.PHONY: all host
all: $(BUILD)/firmware.elf
$(BUILD):
	mkdir -p $(BUILD)
$(BUILD)/firmware.elf: $(CRYPTO) $(wildcard $(REF)/*.h) benchmark.c benchmark.h platform_$(BOARD).c $(BOARD).ld sections.ld Makefile $(PLATFORM) | $(BUILD)
	$(CC) --version
	$(CC) $(CFLAGS) $(CRYPTO) benchmark.c platform_$(BOARD).c $(PLATFORM) $(LDFLAGS) $(LIBS) -o $@
	$(PREFIX)size $@
	$(PREFIX)objcopy -O binary $@ $(BUILD)/firmware.bin
	$(PREFIX)nm -n $@ > $(BUILD)/symbols.txt
	$(PREFIX)objdump -d $@ > $(BUILD)/disassembly.txt
	$(PREFIX)readelf -l -A $@ > $(BUILD)/elf_attributes.txt
HOST_GEN = ../fn-dsa_ref/profiling/build/host-0/generated
host:
	mkdir -p build
	clang -O3 -std=c99 -ffp-contract=off -DBENCH_HOST -DFNDSA_PROFILE=0 -DFNDSA_ASM_CORTEXM4=0 \
 -DFNDSA_AVX2=0 -DFNDSA_SSE2=0 -DFNDSA_NEON=0 -DFNDSA_NEON_SHA3=0 -DFNDSA_RV64D=0 -DFNDSA_64=0 \
 -I. -I../fn-dsa_m4/ref -I../fn-dsa_ref/profiling benchmark.c \
 $(addprefix $(HOST_GEN)/,$(addsuffix .c,$(SOURCES))) -lm -o build/host_oracle
	build/host_oracle > build/host_oracle.json

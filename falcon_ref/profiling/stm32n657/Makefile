ARM_GCC_ROOT ?= /private/tmp/arm-gnu-toolchain-15.3.rel1-expanded/Payload
STM32CUBE_N6 ?= /private/tmp/STM32CubeN6

PREFIX = $(ARM_GCC_ROOT)/bin/arm-none-eabi-
CC = $(PREFIX)gcc
SIZE = $(PREFIX)size

ROOT = ../..
COMMON = $(ROOT)/common
IMPL = $(ROOT)/crypto_sign/falcon-512/clean
HAL = $(STM32CUBE_N6)/Drivers/STM32N6xx_HAL_Driver
CMSIS = $(STM32CUBE_N6)/Drivers/CMSIS
DEVICE = $(CMSIS)/Device/ST/STM32N6xx
BSP = $(STM32CUBE_N6)/Drivers/BSP/STM32N6xx_Nucleo
TEMPLATE = $(STM32CUBE_N6)/Projects/NUCLEO-N657X0-Q/Templates/Template/FSBL

TARGET = build/falcon512_profile_m55.elf
LINKER = stm32n657_axisram2_fsbl.ld

FALCON_SOURCES = \
	$(IMPL)/codec.c \
	$(IMPL)/common.c \
	$(IMPL)/fft.c \
	$(IMPL)/fpr.c \
	$(IMPL)/keygen.c \
	$(IMPL)/pqclean.c \
	$(IMPL)/rng.c \
	$(IMPL)/sign.c \
	$(IMPL)/vrfy.c

PLATFORM_SOURCES = \
	main.c \
	platform_nucleo_n657x0_q.c \
	randombytes_profile.c \
	../falcon_profile.c \
	$(COMMON)/fips202.c \
	$(TEMPLATE)/Src/stm32n6xx_hal_msp.c \
	$(TEMPLATE)/Src/stm32n6xx_it.c \
	$(TEMPLATE)/Src/system_stm32n6xx_fsbl.c \
	$(DEVICE)/Source/Templates/gcc/startup_stm32n657xx_fsbl.s \
	$(HAL)/Src/stm32n6xx_hal.c \
	$(HAL)/Src/stm32n6xx_hal_cortex.c \
	$(HAL)/Src/stm32n6xx_hal_dma.c \
	$(HAL)/Src/stm32n6xx_hal_dma_ex.c \
	$(HAL)/Src/stm32n6xx_hal_exti.c \
	$(HAL)/Src/stm32n6xx_hal_gpio.c \
	$(HAL)/Src/stm32n6xx_hal_pwr.c \
	$(HAL)/Src/stm32n6xx_hal_pwr_ex.c \
	$(HAL)/Src/stm32n6xx_hal_rcc.c \
	$(HAL)/Src/stm32n6xx_hal_rcc_ex.c

INCLUDES = \
	-I$(COMMON) \
	-I$(IMPL) \
	-I$(TEMPLATE)/Inc \
	-I$(BSP) \
	-I$(HAL)/Inc \
	-I$(HAL)/Inc/Legacy \
	-I$(DEVICE)/Include \
	-I$(CMSIS)/Include

ARCH_FLAGS = -mcpu=cortex-m55 -mthumb -mfpu=fpv5-d16 \
	-mfloat-abi=hard -mcmse
CPPFLAGS = -DUSE_HAL_DRIVER -DSTM32N657xx -DFALCON_PROFILE \
	-DFALCON_PROFILE_CORTEX_M -DFALCON_PROFILE_DWT_UNLOCK \
	-DFALCON_PROFILE_NO_STDIO
CFLAGS = $(ARCH_FLAGS) -std=c99 -O3 -g3 -ffunction-sections \
	-fdata-sections -fno-tree-vectorize -fno-strict-aliasing \
	-Wall -Wextra -Wno-unused-parameter $(CPPFLAGS) $(INCLUDES)
LDFLAGS = $(ARCH_FLAGS) -T$(LINKER) --specs=nano.specs \
	--specs=nosys.specs -Wl,--gc-sections -Wl,-Map=build/falcon512_profile_m55.map \
	-Wl,--print-memory-usage
LDLIBS = -Wl,--start-group -lc -lm -lgcc -Wl,--end-group

.PHONY: all clean size

all: $(TARGET)

$(TARGET): $(FALCON_SOURCES) $(PLATFORM_SOURCES) $(LINKER) | build
	$(CC) $(CFLAGS) $(FALCON_SOURCES) $(PLATFORM_SOURCES) \
		$(LDFLAGS) $(LDLIBS) -o $@
	$(SIZE) $@

build:
	mkdir -p $@

size: $(TARGET)
	$(SIZE) -A $(TARGET)

clean:
	$(RM) -r build

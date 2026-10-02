# Standalone Cortex-M55 library: only sources in this directory.
# Backend selection is fixed in fndsa_m55_config.h, not supplied with -D.
# A board application still supplies startup, memory layout and sysrng().
CROSS_COMPILE ?= arm-none-eabi-
CC = $(CROSS_COMPILE)gcc
AR = $(CROSS_COMPILE)ar
ARCH_FLAGS = -mcpu=cortex-m55 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard
CFLAGS ?= -O3 -ffp-contract=off -fno-fast-math -fno-strict-aliasing
WARN_FLAGS = -Wall -Wextra
SECTION_FLAGS = -ffunction-sections -fdata-sections

C_SOURCES = codec.c mq.c sha3.c sha3x4.c sysrng.c util.c \
 kgen.c kgen_fxp.c kgen_gauss.c kgen_mp31.c kgen_ntru.c kgen_poly.c \
 kgen_zint31.c kgen_fft_mve.c kgen_fft_bridge.c \
 sign.c sign_core.c sign_fpoly.c sign_fpr.c sign_sampler.c vrfy.c
S_SOURCES = codec_cm4.s sha3_cm4.s sign_fpr_cm4.s sign_sampler_cm4.s \
 mq_cm55.s kgen_mp31_cm55.s kgen_fft_cm55.s sha3x4_cm55.s \
 sign_fft_cm55.s sign_ldl_cm55.s sign_split_merge_cm55.s
OBJECTS = $(C_SOURCES:%.c=build/%.o) $(S_SOURCES:%.s=build/%.o)

.PHONY: all clean
all: build/libfndsa_m55.a

build:
	mkdir -p build

build/%.o: %.c | build
	$(CC) $(ARCH_FLAGS) $(CFLAGS) $(WARN_FLAGS) $(SECTION_FLAGS) -MMD -MP -c $< -o $@

build/%.o: %.s | build
	$(CC) $(ARCH_FLAGS) -c $< -o $@

build/libfndsa_m55.a: $(OBJECTS)
	$(AR) rcs $@ $(OBJECTS)

clean:
	$(RM) $(OBJECTS) $(OBJECTS:.o=.d) build/libfndsa_m55.a

-include $(OBJECTS:.o=.d)

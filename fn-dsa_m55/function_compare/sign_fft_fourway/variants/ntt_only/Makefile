# Independent fixed implementation. No foreign crypto sources.
CROSS_COMPILE ?= arm-none-eabi-
CC = $(CROSS_COMPILE)gcc
AR = $(CROSS_COMPILE)ar
CFLAGS = -O3 -mcpu=cortex-m55 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard -ffp-contract=off -fno-fast-math -fno-strict-aliasing -ffunction-sections -fdata-sections
C_SOURCES = codec.c mq.c sha3.c sysrng.c util.c kgen.c kgen_fxp.c kgen_gauss.c kgen_mp31.c kgen_ntru.c kgen_poly.c kgen_zint31.c sign.c sign_core.c sign_fpoly.c sign_fpr.c sign_sampler.c vrfy.c
S_SOURCES = codec_cm4.s kgen_mp31_cm55.s mq_cm55.s sha3_cm4.s sign_fpr_cm4.s sign_sampler_cm4.s
OBJECTS = $(C_SOURCES:%.c=build/%.o) $(S_SOURCES:%.s=build/%.o)
all: build/libfndsa.a
build:
	mkdir -p build
build/%.o: %.c | build
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@
build/%.o: %.s | build
	$(CC) $(CFLAGS) -c $< -o $@
build/libfndsa.a: $(OBJECTS)
	$(AR) rcs $@ $(OBJECTS)
-include $(OBJECTS:.o=.d)

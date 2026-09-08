CC ?= cc

IMPL = ../crypto_sign/falcon-512/clean
COMMON = ../common
TARGET = bench_falcon512

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

SOURCES = bench_falcon512.c falcon_profile.c \
	$(COMMON)/fips202.c $(COMMON)/randombytes.c $(FALCON_SOURCES)

CFLAGS ?= -O2
CFLAGS += -std=c99 -Wall -Wextra -Wpedantic -Wconversion \
	-DFALCON_PROFILE -I$(COMMON) -I$(IMPL)

.PHONY: all run clean

all: $(TARGET)

$(TARGET): $(SOURCES) $(COMMON)/falcon_profile.h
	$(CC) $(CFLAGS) -o $@ $(SOURCES)

run: $(TARGET)
	./$(TARGET)

clean:
	$(RM) $(TARGET)

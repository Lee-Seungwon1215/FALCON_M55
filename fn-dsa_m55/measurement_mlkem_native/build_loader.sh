#!/bin/bash
set -euo pipefail
MEASUREMENT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$MEASUREMENT_DIR/env/environment.sh"
mkdir -p "$MEASUREMENT_DIR/loader"
arm-none-eabi-gcc -mcpu=cortex-m55 -mthumb -nostdlib \
  -Wl,-Ttext=0x340af000 -Wl,-e,loader_tcm_init \
  "$MEASUREMENT_DIR/loader_tcm_init.s" -o "$MEASUREMENT_DIR/loader/loader_tcm_init.elf"
arm-none-eabi-objcopy -O binary "$MEASUREMENT_DIR/loader/loader_tcm_init.elf" \
  "$MEASUREMENT_DIR/loader/loader_tcm_init.bin"
arm-none-eabi-objdump -d "$MEASUREMENT_DIR/loader/loader_tcm_init.elf"

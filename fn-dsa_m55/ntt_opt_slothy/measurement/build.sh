#!/bin/bash
# Build the actual integrated source files; no Slothy candidate is imported.
set -euo pipefail
MEASUREMENT_LOCAL="$(cd "$(dirname "$0")" && pwd)"
FNDSA_LOCAL_SOURCE="$(cd "$MEASUREMENT_LOCAL/.." && pwd)"
FNDSA_COMMON_MEAS="$(cd "$FNDSA_LOCAL_SOURCE/../measurement_mlkem_native" && pwd)"
source "$FNDSA_COMMON_MEAS/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
FNDSA_LOCAL_BUILD="$FNDSA_LOCAL_SOURCE/build/m55"
mkdir -p "$FNDSA_LOCAL_BUILD"
FNDSA_BUILD_STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
{
  cmake -S "$FNDSA_COMMON_MEAS/app" -B "$FNDSA_LOCAL_BUILD" -G Ninja \
    -DBOARD=nucleo_n657x0_q \
    -DFNDSA_SOURCE_DIR="$FNDSA_LOCAL_SOURCE" -DFNDSA_MQ_ASM=mq_cm55 \
    -DFNDSA_KGEN_MP31_ASM=kgen_mp31_cm55 \
    -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
    -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$FNDSA_COMMON_MEAS/app/fndsa.conf" \
    -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= -DCMAKE_ASM_FLAGS= -DCMAKE_EXE_LINKER_FLAGS=
  cmake --build "$FNDSA_LOCAL_BUILD" -j 4
  # The sparse ELF is the firmware. The flat BIN includes a 512 MiB address gap.
  cmake -E rm -f "$FNDSA_LOCAL_BUILD/zephyr/zephyr.bin"
} 2>&1 | tee "$FNDSA_LOCAL_BUILD/build-$FNDSA_BUILD_STAMP.log"

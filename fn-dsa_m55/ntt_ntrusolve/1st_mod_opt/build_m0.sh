#!/bin/bash
# Reproducible NUCLEO-N657X0-Q builds for the pre-Slothy reference and M0.
set -euo pipefail

STAGE_DIR="$(cd "$(dirname "$0")" && pwd)"
MEASUREMENT_DIR="$STAGE_DIR/../../measurement_mlkem_native"
source "$MEASUREMENT_DIR/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS

if [ "$#" -ne 1 ]; then
  echo "usage: $0 {ref|m0|m0_audit}" >&2
  exit 2
fi

case "$1" in
  ref)
    SOURCE_DIR="$STAGE_DIR/../ref_preslothy"
    BUILD_DIR="$MEASUREMENT_DIR/build-ntru-ref"
    MP31_ASM=""
    MP31_SELFTEST=OFF
    ;;
  m0)
    SOURCE_DIR="$STAGE_DIR/M0_general_montgomery"
    BUILD_DIR="$MEASUREMENT_DIR/build-ntru-m0"
    MP31_ASM="kgen_mp31_cm55"
    MP31_SELFTEST=OFF
    ;;
  m0_audit)
    SOURCE_DIR="$STAGE_DIR/M0_general_montgomery"
    BUILD_DIR="$MEASUREMENT_DIR/build-ntru-m0-audit"
    MP31_ASM="kgen_mp31_cm55"
    MP31_SELFTEST=ON
    ;;
  *)
    echo "unknown build: $1" >&2
    exit 2
    ;;
esac

cmake -S "$MEASUREMENT_DIR/app" -B "$BUILD_DIR" -G Ninja \
  -DBOARD=nucleo_n657x0_q \
  -DFNDSA_SOURCE_DIR="$SOURCE_DIR" -DFNDSA_MQ_ASM=mq_cm55 \
  -DFNDSA_KGEN_MP31_ASM="$MP31_ASM" \
  -DFNDSA_MP31_SELFTEST="$MP31_SELFTEST" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$MEASUREMENT_DIR/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= -DCMAKE_ASM_FLAGS= \
  -DCMAKE_EXE_LINKER_FLAGS=
cmake --build "$BUILD_DIR" -j 4
# Keep the sparse ELF; a flat BIN spans the large ITCM/DTCM address gap.
cmake -E rm -f "$BUILD_DIR/zephyr/zephyr.bin"

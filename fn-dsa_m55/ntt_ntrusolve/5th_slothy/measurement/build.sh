#!/bin/bash
set -euo pipefail
LOCAL_MEAS="$(cd "$(dirname "$0")" && pwd)"
STAGE="$(cd "$LOCAL_MEAS/.." && pwd)"
COMMON="$(cd "$STAGE/../.." && pwd)/measurement_mlkem_native"
case "${1:-}" in baseline|slothyA|slothyB|ref_slothy) VARIANT="$1";; *) exit 2;; esac
SOURCE="$STAGE/$VARIANT"
if [ "$VARIANT" = ref_slothy ]; then SOURCE="$STAGE/../ref_slothy"; fi
case "${2:-}" in audit) SELFTEST=ON;; perf) SELFTEST=OFF;; *) exit 2;; esac
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
BUILD="$SOURCE/build/$2"
cmake -S "$LOCAL_MEAS/app" -B "$BUILD" -G Ninja \
  -DBOARD=nucleo_n657x0_q -DFNDSA_SOURCE_DIR="$SOURCE" \
  -DFNDSA_MQ_ASM=mq_cm55 -DFNDSA_KGEN_MP31_ASM=kgen_mp31_cm55 \
  -DFNDSA_MP31_SELFTEST="$SELFTEST" -DFNDSA_MP31_SIGNED_SELFTEST="$SELFTEST" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$LOCAL_MEAS/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= -DCMAKE_ASM_FLAGS= -DCMAKE_EXE_LINKER_FLAGS=
cmake --build "$BUILD" -j 4
cmake -E rm -f "$BUILD/zephyr/zephyr.bin"
python3 "$LOCAL_MEAS/run.py" "$VARIANT" "$2" record

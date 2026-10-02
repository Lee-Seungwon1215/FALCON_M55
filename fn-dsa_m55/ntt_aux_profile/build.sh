#!/bin/bash
set -euo pipefail
PROFILE_ROOT="$(cd "$(dirname "$0")" && pwd)"
WORK_ROOT="$(cd "$PROFILE_ROOT/.." && pwd)"
COMMON_MEAS="$WORK_ROOT/measurement_mlkem_native"
source "$COMMON_MEAS/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
build_one() {
  local mode="$1" src build generated stamp
  src="$WORK_ROOT/ntt_ntrusolve/ref_preslothy"
  build="$PROFILE_ROOT/build/$mode"
  generated="$build/generated"
  mkdir -p "$generated"
  python3 "$PROFILE_ROOT/instrument.py" "$src" "$generated" "$mode"
  python3 "$PROFILE_ROOT/provenance.py" prepare "$mode"
  stamp="$(date -u +%Y%m%dT%H%M%SZ)"
  {
    cmake --fresh -S "$PROFILE_ROOT" -B "$build" -G Ninja \
      -DBOARD=nucleo_n657x0_q \
      -DFNDSA_SOURCE_DIR="$src" -DFNDSA_GENERATED_DIR="$generated" \
      -DFNDSA_COMMON_MEAS="$COMMON_MEAS" -DFNDSA_MQ_ASM=mq_cm55 \
      -DFNDSA_KGEN_MP31_ASM=kgen_mp31_cm55 -DPROFILE_CANDIDATE="$mode" \
      -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
      -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON_MEAS/app/fndsa.conf" \
      -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
      -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= -DCMAKE_ASM_FLAGS= -DCMAKE_EXE_LINKER_FLAGS=
    cmake --build "$build" -j 4
    cmake -E rm -f "$build/zephyr/zephyr.bin"
    python3 "$PROFILE_ROOT/provenance.py" record "$mode"
  } 2>&1 | tee "$build/build-$stamp.log"
}
case "${1:-all}" in
  control|detailed) build_one "$1" ;;
  all) build_one control; build_one detailed ;;
  *) echo "usage: bash build.sh [control|detailed|all]" >&2; exit 2 ;;
esac

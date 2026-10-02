#!/bin/bash
set -euo pipefail

PROFILE_ROOT="$(cd "$(dirname "$0")" && pwd)"
WORK_ROOT="$(cd "$PROFILE_ROOT/.." && pwd)"
SOURCE="$WORK_ROOT/ntt_opt_slothy"
COMMON_MEAS="$WORK_ROOT/measurement_mlkem_native"
source "$COMMON_MEAS/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS

build_one() {
  local candidate="$1" build generated stamp source_dir="$SOURCE" mode="$1" mp31=""
  if [[ "$candidate" == ntt_opt_* ]]; then
    source_dir="$WORK_ROOT/ntt_opt"
    mode="${candidate#ntt_opt_}"
    mp31=kgen_mp31_cm55
  fi
  build="$PROFILE_ROOT/build/$candidate"
  generated="$build/generated"
  mkdir -p "$generated"
  python3 "$PROFILE_ROOT/instrument.py" "$source_dir" "$generated" "$mode"
  if [[ "$candidate" == ntt_opt_* ]]; then
    python3 "$PROFILE_ROOT/latest.py" "$candidate" prepare
  fi
  stamp="$(date -u +%Y%m%dT%H%M%SZ)"
  {
    cmake --fresh -S "$PROFILE_ROOT" -B "$build" -G Ninja \
      -DBOARD=nucleo_n657x0_q \
      -DFNDSA_SOURCE_DIR="$source_dir" -DFNDSA_GENERATED_DIR="$generated" \
      -DFNDSA_KGEN_MP31_ASM="$mp31" \
      -DFNDSA_COMMON_MEAS="$COMMON_MEAS" \
      -DPROFILE_CANDIDATE="$candidate" \
      -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
      -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON_MEAS/app/fndsa.conf" \
      -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
      -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= -DCMAKE_ASM_FLAGS= -DCMAKE_EXE_LINKER_FLAGS=
    cmake --build "$build" -j 4
    cmake -E rm -f "$build/zephyr/zephyr.bin"
    if [[ "$candidate" == ntt_opt_* ]]; then
      python3 "$PROFILE_ROOT/latest.py" "$candidate" record
    fi
  } 2>&1 | tee "$build/build-$stamp.log"
}

case "${1:-all}" in
  control|detailed|logn|ntt_opt_control|ntt_opt_fft) build_one "$1" ;;
  latest) build_one ntt_opt_control; build_one ntt_opt_fft ;;
  all) build_one control; build_one detailed ;;
  *) echo "usage: $0 [control|detailed|logn|all|ntt_opt_control|ntt_opt_fft|latest]" >&2; exit 2 ;;
esac

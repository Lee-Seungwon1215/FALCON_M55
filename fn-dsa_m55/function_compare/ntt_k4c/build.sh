#!/bin/bash
set -euo pipefail
NTT_ROOT="$(cd "$(dirname "$0")" && pwd)"
source "$NTT_ROOT/../../measurement_mlkem_native/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
for layout in "${@:-ab}"; do
  case "$layout" in ab|ba) ;; *) echo 'usage: bash build.sh [ab ba]'; exit 2;; esac
  NTT_BUILD="$NTT_ROOT/build/$layout"
  mkdir -p "$NTT_BUILD"
  python3 "$NTT_ROOT/audit.py" sources
  {
    cmake --fresh -S "$NTT_ROOT" -B "$NTT_BUILD" -G Ninja \
      -DBOARD=nucleo_n657x0_q -DCOMPARE_LAYOUT="$layout" \
      -DCONF_FILE="$NTT_ROOT/board/prj.conf" \
      -DEXTRA_CONF_FILE="$NTT_ROOT/board/nucleo.conf;$NTT_ROOT/board/extra.conf" \
      -DDTC_OVERLAY_FILE="$NTT_ROOT/board/nucleo.overlay" \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
      -DCMAKE_C_FLAGS= -DCMAKE_ASM_FLAGS= -DCMAKE_EXE_LINKER_FLAGS=
    cmake --build "$NTT_BUILD" -j 4
    cmake -E rm -f "$NTT_BUILD/zephyr/zephyr.bin"
    python3 "$NTT_ROOT/audit.py" record "$layout"
  } 2>&1 | tee "$NTT_BUILD/build.log"
done

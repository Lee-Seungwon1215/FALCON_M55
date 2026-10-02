#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$ROOT/../../measurement_mlkem_native/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
cmake --fresh -S "$ROOT" -B "$ROOT/build/board" -G Ninja \
  -DBOARD=nucleo_n657x0_q \
  -DCONF_FILE="$ROOT/board/prj.conf" \
  -DEXTRA_CONF_FILE="$ROOT/board/nucleo.conf;$ROOT/board/extra.conf" \
  -DDTC_OVERLAY_FILE="$ROOT/board/nucleo.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_C_FLAGS= -DCMAKE_ASM_FLAGS= -DCMAKE_EXE_LINKER_FLAGS=
cmake --build "$ROOT/build/board" -j 4

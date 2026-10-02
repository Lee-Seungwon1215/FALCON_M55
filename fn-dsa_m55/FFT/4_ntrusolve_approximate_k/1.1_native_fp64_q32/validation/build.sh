#!/bin/bash
set -euo pipefail
TASK_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TASK_M55="$(cd "$TASK_ROOT/../../.." && pwd)"
COMMON="$TASK_M55/measurement_mlkem_native"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
kind="${1:?kat|sigkat|guard_repro|perfct|keyprofile|ntruprofile|ntrucontrol|orthoprofile|orthocontrol}"
profile_mode=detail
case "$kind" in
  kat) bench=board_kat.c;;
  sigkat) bench=board_signkat.c;;
  guard_repro) bench=board_repro.c;;
  perfct) bench=perfct.c;;
  keyprofile) bench=keyprofile.c;;
  ntruprofile) bench=ntruprofile.c;;
  ntrucontrol) bench=ntruprofile.c; profile_mode=control;;
  orthoprofile) bench=orthoprofile.c;;
  orthocontrol) bench=orthoprofile.c; profile_mode=control;;
  *) exit 2;;
esac
build="$TASK_ROOT/validation/build/$kind"
cmake --fresh -S "$TASK_ROOT/validation" -B "$build" -G Ninja -DBOARD=nucleo_n657x0_q \
  -DCRYPTO_SOURCE="$TASK_ROOT" -DCOMMON_MEAS="$COMMON" -DBENCH_SOURCE="$bench" \
  -DNTRU_PROFILE_MODE="$profile_mode" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$build" -j 4

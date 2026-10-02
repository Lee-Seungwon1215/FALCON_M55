#!/bin/bash
set -euo pipefail
TASK_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TASK_M55="$(cd "$TASK_ROOT/../../.." && pwd)"
COMMON="$TASK_M55/measurement_mlkem_native"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
kind="${1:?kat|sigkat|api_perf|guard_repro|kernels|perfct|keyprofile|ntruprofile|ntrucontrol|orthoprofile|orthocontrol}"
profile_mode=detail
integration_mode=default
pin_integer_layout=OFF
crypto_source="$TASK_ROOT"
keygen_baseline=OFF
case "$kind" in
  kat) bench=board_kat.c;;
  sigkat) bench=board_signkat.c;;
  api_perf) bench=board_api_perf.c;;
  guard_repro) bench=board_repro.c;;
  kernels) bench=board_kernels.c;;
  perfct) bench=perfct.c;;
  keyprofile) bench=keyprofile.c;;
  ntruprofile) bench=ntruprofile.c;;
  ntrucontrol) bench=ntruprofile.c; profile_mode=control;;
  orthoprofile) bench=orthoprofile.c;;
  orthocontrol) bench=orthoprofile.c; profile_mode=control;;
  bridgeprofile) bench=bridgeprofile.c;;
  twiddlebench) bench=twiddlebench.c;;
  keygen_current) bench=board_keygen_perf.c;;
  keygen_ref) bench=board_keygen_perf.c; crypto_source="$TASK_M55/M55_ref"; keygen_baseline=ON;;
  ipro_current) bench=integration_bench.c;;
  ipro_ref) bench=integration_bench.c; crypto_source="$TASK_M55/M55_ref"; keygen_baseline=ON;;
  zpro_current) bench=integration_bench.c; integration_mode=integer;;
  zpro_ref) bench=integration_bench.c; integration_mode=integer; crypto_source="$TASK_M55/M55_ref"; keygen_baseline=ON;;
  zlayout_current) bench=integration_bench.c; integration_mode=integer; pin_integer_layout=ON;;
  zlayout_ref) bench=integration_bench.c; integration_mode=integer; pin_integer_layout=ON; crypto_source="$TASK_M55/M55_ref"; keygen_baseline=ON;;
  keylayout_current) bench=board_keygen_perf.c; pin_integer_layout=ON;;
  keylayout_ref) bench=board_keygen_perf.c; pin_integer_layout=ON; crypto_source="$TASK_M55/M55_ref"; keygen_baseline=ON;;
  *) exit 2;;
esac
build="$TASK_ROOT/validation/build/$kind"
cmake --fresh -S "$TASK_ROOT/validation" -B "$build" -G Ninja -DBOARD=nucleo_n657x0_q \
  -DCRYPTO_SOURCE="$crypto_source" -DCOMMON_MEAS="$COMMON" -DBENCH_SOURCE="$bench" \
  -DKEYGEN_BASELINE="$keygen_baseline" \
  -DINTEGRATION_MODE="$integration_mode" \
  -DPIN_INTEGER_LAYOUT="$pin_integer_layout" \
  -DNTRU_PROFILE_MODE="$profile_mode" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$build" -j 4

#!/bin/bash
set -euo pipefail
TASK_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TASK_M55="$(cd "$TASK_ROOT/../.." && pwd)"
COMMON="$TASK_M55/measurement_mlkem_native"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
kind="${1:?kat_invnorm|kat|sigkat|kernels|keygen_current|keygen_ntt|keygen_ref|keylayout_current|keylayout_ntt|keylayout_ref}"
crypto_source="$TASK_ROOT"
baseline=candidate
pin=OFF
case "$kind" in
  kat_invnorm|kat) bench=board_kat.c;;
  extra) bench=board_extra_kat.c;;
  q32timing) bench=board_q32_timing.c;;
  sigkat) bench=board_signkat.c;;
  kernels) bench=board_kernels.c;;
  fixtures) bench=board_fixtures.c;;
  breakdown) bench=board_breakdown.c;;
  keygen_current|keylayout_current) bench=board_keygen_perf.c;;
  keygen_ntt|keylayout_ntt) bench=board_keygen_perf.c; crypto_source="$TASK_M55/ntt_opt"; baseline=ntt;;
  keygen_ref|keylayout_ref) bench=board_keygen_perf.c; crypto_source="$TASK_M55/M55_ref"; baseline=m55_ref;;
  *) exit 2;;
esac
case "$kind" in keylayout_*) pin=ON;; esac
cmake --fresh -S "$TASK_ROOT/validation" -B "$TASK_ROOT/validation/build/$kind" -G Ninja \
  -DBOARD=nucleo_n657x0_q -DCRYPTO_SOURCE="$crypto_source" -DCOMMON_MEAS="$COMMON" \
  -DBENCH_SOURCE="$bench" -DBASELINE_KIND="$baseline" -DPIN_INTEGER_LAYOUT="$pin" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$TASK_ROOT/validation/build/$kind" -j 4

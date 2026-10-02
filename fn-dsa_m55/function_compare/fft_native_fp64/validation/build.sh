#!/bin/bash
set -euo pipefail
AUDIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
AUDIT_M55="$(cd "$AUDIT_ROOT/../.." && pwd)"
COMMON="$AUDIT_M55/measurement_mlkem_native"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
backend="${1:?reference|native|q32_trial}"; kind="${2:?stages|kat}"
case "$backend" in reference|native|q32_trial) ;; *) exit 2;; esac
case "$kind" in stages) bench=stages.c;; kat) bench=board_kat.c;; sigkat) bench=board_signkat.c;; perfct) bench=perfct.c;; keyprofile) bench=keyprofile.c;; repro|guard_repro) bench=board_repro.c;; first_failure) bench=first_failure.c;; *) exit 2;; esac
build="$AUDIT_ROOT/build/$backend-$kind"
cmake --fresh -S "$AUDIT_ROOT/validation" -B "$build" -G Ninja -DBOARD=nucleo_n657x0_q \
  -DCRYPTO_SOURCE="$AUDIT_ROOT/$backend" -DCOMMON_MEAS="$COMMON" -DBENCH_SOURCE="$bench" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$build" -j 4

#!/bin/bash
set -euo pipefail
TASK_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMMON="$(cd "$TASK_ROOT/../measurement_mlkem_native" && pwd)"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
candidate="${1:?candidate source folder}"
mode="${2:?keygen|profile|kat|extra|sigkat|arithmetic}"
case "$candidate" in baseline_m55|baseline_ntt|A_tw_bridge|B_continuous_ds) ;; *) exit 2;; esac
case "$mode" in
  keygen) bench=board_keygen_perf.c;;
  profile) bench=integration_bench.c;;
  kat) bench=board_kat.c;;
  extra) bench=board_extra_kat.c;;
  sigkat) bench=board_signkat.c;;
  arithmetic) bench=arithmetic/board.c;;
  kernel) bench=kernel/$candidate.c;;
  encoding) bench=encoding/board.c;;
  rounding) bench=rounding/board.c;;
  decoding) bench=decoding/board.c;;
  fixed_input) bench=fixed_input/board.c;;
  input_pair) bench=fixed_input/pair_board.c;;
  input_predicate) bench=fixed_input/predicate_board.c;;
  division) bench=division/board.c;;
  fixed_division) bench=fixed_division/board.c;;
  twiddle) bench=twiddle/board.c;;
  twiddle_fft) bench=twiddle/fft_board.c;;
  fixed_fft) bench=twiddle/integration_board.c;;
  invnorm) bench=invnorm/board.c;;
  security_invnorm) bench=security/invnorm_audit.c;;
  security_api) bench=security/api_audit.c;;
  rootmul) bench=rootmul/board.c;;
  fft_alignment) bench=twiddle/alignment_board.c;;
  fft_placement) bench=twiddle/placement_board.c;;
  fft_context) bench=twiddle/context_board.c;;
  fft_replay) bench=twiddle/replay_bench.c;;
  profile_probe) bench=integration_probe.c;;
  fft_fusion) bench=twiddle/fusion_board.c;;
  *) exit 2;;
esac
cmake --fresh -S "$TASK_ROOT/validation" -B "$TASK_ROOT/validation/build/$candidate/$mode" -G Ninja \
  -DBOARD=nucleo_n657x0_q -DCRYPTO_SOURCE="$TASK_ROOT/$candidate" \
  -DCOMMON_MEAS="$COMMON" -DBENCH_SOURCE="$bench" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$TASK_ROOT/validation/build/$candidate/$mode" -j 4

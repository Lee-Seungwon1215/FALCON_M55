#!/bin/bash
set -euo pipefail

PROFILE_ROOT="$(cd "$(dirname "$0")" && pwd)"
WORK_ROOT="$(cd "$PROFILE_ROOT/.." && pwd)"
COMMON_MEAS="$WORK_ROOT/measurement_mlkem_native"
source "$COMMON_MEAS/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS

build_one() {
  local candidate="$1" source mq build generated stamp mp31=""
  if [ "$candidate" = before ]; then
    source="$WORK_ROOT/ref"
    mq=mq_cm4
  elif [ "$candidate" = after ]; then
    source="$WORK_ROOT/ntt_opt_slothy"
    mq=mq_cm55
  elif [ "$candidate" = preslothy ]; then
    source="$WORK_ROOT/ntt_ntrusolve/ref_preslothy"
    mq=mq_cm55
    mp31=kgen_mp31_cm55
  elif [ "$candidate" = ntt_opt ]; then
    source="$WORK_ROOT/ntt_opt"
    mq=mq_cm55
    mp31=kgen_mp31_cm55
  else
    echo "candidate must be before, after, preslothy, ntt_opt, or all" >&2
    return 2
  fi
  build="$PROFILE_ROOT/build/$candidate"
  generated="$build/generated"
  mkdir -p "$generated"
  python3 "$PROFILE_ROOT/instrument.py" "$source" "$generated"
  if [ "$candidate" = preslothy ]; then
    python3 "$PROFILE_ROOT/provenance.py" prepare
  elif [ "$candidate" = ntt_opt ]; then
    python3 "$PROFILE_ROOT/ntt_opt_audit.py" prepare
  fi
  stamp="$(date -u +%Y%m%dT%H%M%SZ)"
  {
    cmake --fresh -S "$PROFILE_ROOT" -B "$build" -G Ninja \
      -DBOARD=nucleo_n657x0_q \
      -DFNDSA_SOURCE_DIR="$source" -DFNDSA_GENERATED_DIR="$generated" \
      -DFNDSA_COMMON_MEAS="$COMMON_MEAS" -DFNDSA_MQ_ASM="$mq" \
      -DFNDSA_KGEN_MP31_ASM="$mp31" \
      -DPROFILE_CANDIDATE="$candidate" \
      -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
      -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON_MEAS/app/fndsa.conf" \
      -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
      -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= -DCMAKE_ASM_FLAGS= -DCMAKE_EXE_LINKER_FLAGS=
    cmake --build "$build" -j 4
    cmake -E rm -f "$build/zephyr/zephyr.bin"
    if [ "$candidate" = preslothy ]; then
      python3 "$PROFILE_ROOT/provenance.py" record
    elif [ "$candidate" = ntt_opt ]; then
      python3 "$PROFILE_ROOT/ntt_opt_audit.py" record
    fi
  } 2>&1 | tee "$build/build-$stamp.log"
}

case "${1:-all}" in
  before|after|preslothy|ntt_opt) build_one "$1" ;;
  all) build_one before; build_one after ;;
  *) echo "usage: $0 [before|after|preslothy|ntt_opt|all]" >&2; exit 2 ;;
esac

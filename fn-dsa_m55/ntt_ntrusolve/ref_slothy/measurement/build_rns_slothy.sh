#!/bin/bash
# Build the C/H/S files of this ref_slothy folder; tooling only is shared.
set -euo pipefail
LOCAL="$(cd "$(dirname "$0")" && pwd)"
exec bash "$LOCAL/../../5th_slothy/measurement/build.sh" ref_slothy "${1:?audit or perf}"

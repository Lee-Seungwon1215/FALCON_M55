#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob dotglob

# Usage: ./apply_patch.sh source_patch target_repo
SRC="${1:-source_patch}"
DEST="${2:-target_repo}"

echo "== Applying patch =="
echo " Source:      $SRC"
echo " Destination: $DEST"
echo "---------------------------------------"

# Ensure destination is a Git repo
if ! git -C "$DEST" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: Destination '$DEST' is not a Git repository."
  exit 1
fi

find "$SRC" -type f | while read -r src_file; do
  rel_path="${src_file#$SRC/}"
  dest_file="$DEST/$rel_path"
  dest_dir="$(dirname "$dest_file")"

  echo
  echo "→ Processing: $rel_path"

  if [[ ! -d "$dest_dir" ]]; then
    echo "   Creating directory: $dest_dir"
    mkdir -p "$dest_dir"
  fi

  # Read file content safely (trim whitespace and newlines)
  line="$(<"$src_file")"
  line="$(echo "$line" | tr -d '\r' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

  # Detect if file is a symlink descriptor:
  #  - non-empty single line (no newlines)
  #  - looks like a relative path (starts with ./, ../, or contains /)
  if [[ -n "$line" && "$line" != *$'\n'* && "$line" =~ ^(\.\/|\.\.\/|[^[:space:]]+/) ]]; then
    echo "   Detected symlink descriptor"
    echo "   Creating symlink: $dest_file → $line"
    rm -f "$dest_file"
    ln -s "$line" "$dest_file"
  else
    echo "   Copying file to: $dest_file"
    cp -f "$src_file" "$dest_file"
  fi
done

echo
echo "---------------------------------------"
echo "✅ Patch applied and staged in Git."

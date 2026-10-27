#!/usr/bin/env bash
# backup.sh - create a timestamped tar.gz of a directory and keep only the newest N archives.
# Usage: ./backup.sh SOURCE_DIR DEST_DIR [KEEP]     (KEEP defaults to 7)
# Exit codes: 0 success, 1 backup failed, 2 bad arguments
set -euo pipefail

src="${1:-}"; dest="${2:-}"; keep="${3:-7}"

if [[ -z "$src" || -z "$dest" ]]; then
    echo "Usage: $0 SOURCE_DIR DEST_DIR [KEEP]" >&2; exit 2
fi
[[ -d "$src" ]] || { echo "Source is not a directory: $src" >&2; exit 2; }
[[ "$keep" =~ ^[1-9][0-9]*$ ]] || { echo "KEEP must be a positive number" >&2; exit 2; }
mkdir -p "$dest"

name="$(basename "$(realpath "$src")")"
archive="$dest/${name}_$(date +%Y%m%d_%H%M%S).tar.gz"

if ! tar -czf "$archive" -C "$(dirname "$(realpath "$src")")" "$name"; then
    echo "Backup FAILED for $src" >&2
    rm -f "$archive"
    exit 1
fi
tar -tzf "$archive" >/dev/null || { echo "Archive is corrupt: $archive" >&2; exit 1; }
echo "Created $archive ($(du -h "$archive" | cut -f1))"

# Rotation: delete all but the newest $keep archives for this source
mapfile -t old < <(ls -1t "$dest/${name}"_*.tar.gz 2>/dev/null | tail -n +"$((keep + 1))")
for f in "${old[@]}"; do
    rm -f -- "$f" && echo "Rotated out $f"
done
exit 0

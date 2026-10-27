#!/usr/bin/env bash
# log_scan.sh - count error patterns in a log file and show the most frequent ones.
# Usage: ./log_scan.sh LOGFILE [PATTERN] [TOP]
#        PATTERN defaults to 'error|fail|critical|timeout|denied' (case-insensitive)
# Exit codes: 0 no matches, 1 matches found, 2 bad arguments
set -euo pipefail

file="${1:-}"
pattern="${2:-error|fail|critical|timeout|denied}"
top="${3:-10}"

if [[ -z "$file" || ! -r "$file" ]]; then
    echo "Usage: $0 LOGFILE [PATTERN] [TOP]   (file must exist and be readable)" >&2
    exit 2
fi
[[ "$top" =~ ^[0-9]+$ ]] || { echo "TOP must be a number" >&2; exit 2; }

total=$(grep -Eic "$pattern" "$file" || true)
echo "File: $file"
echo "Pattern: $pattern"
echo "Matching lines: $total"
(( total == 0 )) && exit 0

echo
echo "Top $top messages (numbers, hex and timestamps normalised so repeats group together):"
grep -Ei "$pattern" "$file" \
  | sed -E 's/^[A-Z][a-z]{2} +[0-9]+ [0-9:]+ //; s/^[0-9-]+[T ][0-9:.,+Z-]+ //; s/0x[0-9a-fA-F]+/0xN/g; s/[0-9]+/N/g' \
  | sort | uniq -c | sort -rn | head -n "$top"

echo
echo "First match: $(grep -Eim1 "$pattern" "$file")"
echo "Last match:  $(grep -Ei "$pattern" "$file" | tail -n1)"
exit 1

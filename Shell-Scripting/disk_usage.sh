#!/usr/bin/env bash
# disk_usage.sh - report filesystem usage and alert above thresholds.
# Usage: ./disk_usage.sh [WARN_PCT] [CRIT_PCT]      (defaults 85 95)
# Exit codes: 0 OK, 1 WARNING, 2 CRITICAL, 3 UNKNOWN (bad arguments)
set -euo pipefail

WARN="${1:-85}"
CRIT="${2:-95}"

is_pct() { [[ "$1" =~ ^[0-9]+$ ]] && (( $1 >= 1 && $1 <= 100 )); }
if ! is_pct "$WARN" || ! is_pct "$CRIT" || (( WARN >= CRIT )); then
    echo "Usage: $0 [WARN_PCT] [CRIT_PCT]  (1-100, WARN < CRIT)" >&2
    exit 3
fi

status=0
printf "%-30s %8s %6s  %s\n" "MOUNT" "SIZE" "USED%" "STATE"
# --output picks only the columns we need; the mount point comes last, so a path
# with spaces stays intact in $mount. Pseudo filesystems are skipped.
while read -r size pct mount; do
    p="${pct%\%}"
    state="OK"
    if (( p >= CRIT )); then state="CRITICAL"; status=2
    elif (( p >= WARN )); then state="WARNING"; (( status < 1 )) && status=1
    fi
    printf "%-30s %8s %5s%%  %s\n" "$mount" "$size" "$p" "$state"
done < <(df -h --output=size,pcent,target -x tmpfs -x devtmpfs -x squashfs -x overlay 2>/dev/null | tail -n +2)

exit "$status"

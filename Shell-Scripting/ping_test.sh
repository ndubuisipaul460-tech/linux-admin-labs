#!/usr/bin/env bash
# ping_test.sh - check reachability of several hosts and print an UP/DOWN summary.
# Usage: ./ping_test.sh HOST [HOST...]
# Exit codes: 0 all up, 1 one or more down, 2 bad arguments
set -euo pipefail

if (( $# == 0 )); then
    echo "Usage: $0 HOST [HOST...]" >&2
    exit 2
fi

down=0
for host in "$@"; do
    # -c 2 packets, -W 2 s timeout per reply (Linux iputils)
    if out=$(ping -c 2 -W 2 "$host" 2>&1); then
        rtt=$(grep -oE 'min/avg/max[^=]*= [0-9.]+/[0-9.]+' <<<"$out" | awk -F/ '{print $NF}')
        printf "UP    %-25s avg %s ms\n" "$host" "${rtt:-?}"
    else
        printf "DOWN  %-25s\n" "$host"
        down=$((down + 1))
    fi
done

echo "$# host(s) checked, $down down."
(( down == 0 ))

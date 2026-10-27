#!/usr/bin/env bash
# service_check.sh - check that systemd services are active; optionally restart once.
# Usage: ./service_check.sh [--restart] SERVICE [SERVICE...]
# Exit codes: 0 all active, 1 one or more inactive, 2 bad arguments / unknown unit
set -euo pipefail

restart=false
if [[ "${1:-}" == "--restart" ]]; then restart=true; shift; fi
if (( $# == 0 )); then
    echo "Usage: $0 [--restart] SERVICE [SERVICE...]" >&2
    exit 2
fi
command -v systemctl >/dev/null || { echo "systemctl not found (not a systemd host?)" >&2; exit 2; }

status=0
for svc in "$@"; do
    if ! systemctl list-unit-files --type=service --no-legend "${svc%.service}.service" | grep -q .; then
        echo "UNKNOWN   $svc (no such unit)"
        status=2
        continue
    fi
    if systemctl is-active --quiet "$svc"; then
        echo "ACTIVE    $svc"
        continue
    fi
    echo "INACTIVE  $svc  ($(systemctl is-active "$svc" || true))"
    echo "  last log lines:"
    journalctl -u "$svc" -n 5 --no-pager 2>/dev/null | sed 's/^/    /' || true
    if $restart; then
        echo "  restarting $svc once..."
        if sudo systemctl restart "$svc" && systemctl is-active --quiet "$svc"; then
            echo "  -> ACTIVE after restart"
            continue
        fi
        echo "  -> still not active; escalate to the service owner"
    fi
    (( status < 1 )) && status=1
done
exit "$status"

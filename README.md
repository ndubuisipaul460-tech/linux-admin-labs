# Linux Administration Labs

Linux administration notes, Bash scripts and troubleshooting commands for supporting Unix and Linux servers in production (RHEL, AIX-style Unix environments, Ubuntu). Scripts are written to be run, scheduled and used as monitoring checks.

## Repository Structure

```
linux-admin-labs/
├── File-Management/        # permissions, find, disk usage, archives
├── Process-Management/     # ps, top, load, memory, systemctl, journalctl
├── Networking/             # ip, ss, dig, traceroute, curl, tcpdump, firewall, ssh
├── Shell-Scripting/        # production-style Bash scripts (below)
└── Interview_Questions/    # Linux troubleshooting Q&A
```

## Shell Scripts

| Script | What it does | Example |
|--------|--------------|---------|
| `disk_usage.sh` | Filesystem usage with WARNING/CRITICAL thresholds; exit 0/1/2 for monitoring | `./disk_usage.sh 85 95` |
| `service_check.sh` | Checks systemd services, shows recent log lines, optional single restart | `./service_check.sh --restart nginx` |
| `ping_test.sh` | UP/DOWN and average RTT for several hosts | `./ping_test.sh 10.0.0.1 8.8.8.8` |
| `log_scan.sh` | Counts error patterns and groups repeated messages | `./log_scan.sh /var/log/messages` |
| `backup.sh` | Timestamped `tar.gz`, integrity check, rotation | `./backup.sh /etc /backups 7` |

All scripts use `set -euo pipefail`, validate their arguments and return meaningful exit codes, so they can run from cron or a monitoring agent.

## Troubleshooting Order

1. **What changed?** Recent changes, patches, deployments.
2. **Resources**: CPU (`top`), memory (`free -h`), disk (`df -h`, `df -i`), I/O (`vmstat`).
3. **Service**: `systemctl status`, `journalctl -u`.
4. **Network**: `ip a`, `ip route`, `ss -tulpn`, `dig`, `curl -v`.
5. **Logs**: `/var/log/messages` or `syslog`, application logs.
6. **Escalate** with the evidence if it's outside the runbook.

## Skills Demonstrated

- Linux command line, file permissions and disk management
- Bash scripting (argument validation, exit codes, safe deletion, rotation)
- Process, service and log management (`ps`, `top`, `systemctl`, `journalctl`)
- Network diagnostics (`ip`, `ss`, `dig`, `traceroute`, `tcpdump`)
- Structured troubleshooting

## Environment

- RHEL / Rocky Linux, Ubuntu
- Scripts syntax-checked and tested in Bash (GNU coreutils)

## Related Repositories

- [it-operations-labs](https://github.com/ndubuisipaul460-tech/it-operations-labs): monitoring scripts, ITIL runbooks and templates
- [network-engineer-labs](https://github.com/ndubuisipaul460-tech/network-engineer-labs): Packet Tracer labs and Cisco ASA notes
- [wireshark-labs](https://github.com/ndubuisipaul460-tech/wireshark-labs): packet analysis labs

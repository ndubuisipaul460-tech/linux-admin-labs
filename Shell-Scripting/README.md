# Shell Scripts

Production-style Bash scripts for daily operations. All use `set -euo pipefail`, validate their arguments, and return meaningful exit codes so they work from cron or as monitoring checks.

| Script | What it does | Exit codes | Example |
|--------|--------------|------------|---------|
| `disk_usage.sh` | Filesystem usage with WARNING/CRITICAL thresholds, pseudo filesystems skipped | 0 OK, 1 WARN, 2 CRIT, 3 bad args | `./disk_usage.sh 80 90` |
| `service_check.sh` | Checks systemd services; shows last log lines; `--restart` tries once, then says escalate | 0 active, 1 inactive, 2 unknown/bad args | `./service_check.sh --restart nginx sshd` |
| `ping_test.sh` | Reachability and average RTT for several hosts | 0 all up, 1 any down, 2 bad args | `./ping_test.sh 10.0.0.1 8.8.8.8` |
| `log_scan.sh` | Counts error patterns and groups repeated messages (numbers normalised) | 0 none, 1 matches, 2 bad args | `./log_scan.sh /var/log/syslog timeout 15` |
| `backup.sh` | Timestamped `tar.gz`, integrity check, keeps newest N | 0 ok, 1 failed, 2 bad args | `./backup.sh /etc /backups 7` |

## Run from cron

```cron
# m  h  dom mon dow  command
*/15 *  *   *   *    /opt/scripts/disk_usage.sh 85 95 || logger -t disk_usage "disk threshold exceeded"
0    2  *   *   *    /opt/scripts/backup.sh /etc /backups 14 >> /var/log/backup.log 2>&1
```

## Make them executable

```bash
chmod +x *.sh
bash -n *.sh     # syntax check without running
```

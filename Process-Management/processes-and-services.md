# Processes and Services

## Processes

```bash
top                         # live view; press P (CPU), M (memory), 1 (per-CPU)
htop                        # friendlier top, if installed
ps aux --sort=-%cpu | head  # top CPU consumers
ps aux --sort=-%mem | head  # top memory consumers
ps -ef --forest             # parent/child tree
pgrep -a nginx              # find PIDs by name
kill -15 <pid>              # ask to stop (SIGTERM)
kill -9 <pid>               # force (SIGKILL), last resort
```

## Load and memory

```bash
uptime          # load average for 1, 5, 15 minutes
nproc           # number of CPUs: load consistently above this = CPU saturation
free -h         # "available" is what matters, not "free"
vmstat 2 5      # r (run queue), si/so (swapping), wa (I/O wait)
iostat -x 2 3   # disk utilisation and wait (sysstat package)
```

High load with low CPU use usually means processes are waiting on **disk or network I/O** (check `wa` in `vmstat`, `iostat`).

## systemd services

```bash
systemctl status sshd
systemctl start | stop | restart | reload sshd
systemctl enable --now sshd           # start now and at boot
systemctl is-active sshd; systemctl is-enabled sshd
systemctl --failed                    # every failed unit
systemctl list-units --type=service --state=running
systemctl cat sshd                    # the unit file in use
systemctl daemon-reload               # after editing unit files
```

## Logs (journald)

```bash
journalctl -u sshd --since "1 hour ago"
journalctl -p err -b                  # errors since this boot
journalctl -f                         # follow live
journalctl --disk-usage
```

Classic log files: `/var/log/messages` (RHEL), `/var/log/syslog` (Ubuntu), `/var/log/secure` or `/var/log/auth.log` (logins), `/var/log/dmesg` (kernel).

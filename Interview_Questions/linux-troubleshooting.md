# Linux Troubleshooting Interview Q&A

**A server is slow. What do you check?**
`uptime` (load vs `nproc`), `top` (which process), `free -h` (memory, swap), `vmstat 2` (I/O wait), `df -h` and `df -i` (full disk), then logs with `journalctl -p err`. Also: is a backup or batch job running right now?

**"No space left on device" but `df -h` shows free space?**
Inodes are full (`df -i`), usually millions of tiny files. Or the space is used by deleted files still held open by a process (`lsof +L1`); restarting that process frees it.

**A service won't start.**
`systemctl status svc`, `journalctl -u svc -n 50`; check the config syntax (e.g. `nginx -t`), the port isn't already in use (`ss -tulpn`), permissions on its files, and SELinux denials.

**Difference between a hard link and a symlink?**
A hard link is another name for the same inode (same filesystem only, survives deleting the original). A symlink points to a path (works across filesystems, breaks if the target is removed).

**What's the load average?**
Average number of processes running or waiting (for CPU or uninterruptible I/O) over 1, 5 and 15 minutes. Compare it with the number of CPUs.

**How do you find which process is listening on port 8080?**
`ss -tulpn | grep 8080` (or `lsof -i :8080`).

**Can't SSH to a server. Steps?**
Ping/route, then `nc -zv host 22`, then `ssh -v`. On the server: `systemctl status sshd`, firewall rules, `/var/log/secure` or `auth.log`, disk not full, account not locked.

**What does `chmod 644` mean?**
Owner read/write, group read, others read.

**How do you see what changed recently on a server?**
Package history (`dnf history` / `/var/log/apt/history.log`), `last` and `/var/log/secure` for logins, config file modification times (`find /etc -mtime -1`), and the change records.

**What's the difference between `kill -15` and `kill -9`?**
15 (SIGTERM) asks the process to exit cleanly; 9 (SIGKILL) ends it immediately with no clean-up. Use 9 only when 15 fails.

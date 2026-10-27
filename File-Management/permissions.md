# Files and Permissions

## Reading `ls -l`

```
-rwxr-x---  1 paul ops  4096 Oct 27 10:00 deploy.sh
│└┬┘└┬┘└┬┘     │    │
│ │  │  │      │    └ group
│ │  │  │      └ owner
│ │  │  └ others: no access
│ │  └ group: read + execute
│ └ owner: read + write + execute
└ type: - file, d directory, l symlink
```

| Permission | Number | On a file | On a directory |
|------------|--------|-----------|----------------|
| r | 4 | Read contents | List names |
| w | 2 | Modify | Create/delete files inside |
| x | 1 | Run | Enter (`cd`) and access files |

`chmod 750 deploy.sh` = owner rwx (7), group r-x (5), others none (0).

## Commands

```bash
chmod u+x script.sh            # add execute for owner
chmod 640 app.conf             # owner rw, group r, others none
chown paul:ops app.conf        # change owner and group
chown -R www-data: /var/www    # recursive, group = user's primary group
umask                          # default permissions mask for new files (022 -> files 644, dirs 755)
```

## Special bits

| Bit | Example | Effect |
|-----|---------|--------|
| setuid | `-rwsr-xr-x /usr/bin/passwd` | Runs as the file's owner |
| setgid on dir | `drwxrws--- /srv/shared` | New files inherit the directory's group |
| sticky | `drwxrwxrwt /tmp` | Only the owner can delete their files |

## Troubleshooting "Permission denied"

1. `ls -l file` and `ls -ld` on **every directory in the path** (each needs `x`).
2. `id user`: is the user in the group?
3. `namei -l /path/to/file`: shows permissions along the whole path.
4. SELinux (RHEL): `ls -Z`, `getenforce`, check `/var/log/audit/audit.log`.

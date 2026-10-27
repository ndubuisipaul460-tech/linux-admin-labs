# Finding Files and Archives

## find

```bash
find /var/log -name "*.log" -mtime +14                 # logs older than 14 days
find / -xdev -type f -size +500M 2>/dev/null           # big files on this filesystem
find /etc -newer /tmp/marker                           # changed after a marker file
find /data -type f -mtime +30 -name "*.tmp" -print     # review first...
find /data -type f -mtime +30 -name "*.tmp" -delete    # ...then delete
find /srv -perm -o+w -type f                           # world-writable files
```

Always run `find` with `-print` first, read the list, then add `-delete`.

## Disk usage

```bash
df -h                     # filesystems
df -i                     # inodes
du -sh /var/*             # size per directory
du -xh / --max-depth=2 2>/dev/null | sort -rh | head -20
```

## Archives

```bash
tar -czf backup.tar.gz /etc          # create gzip archive
tar -tzf backup.tar.gz               # list contents (also tests integrity)
tar -xzf backup.tar.gz -C /restore   # extract to a directory
gzip big.log / gunzip big.log.gz
zip -r site.zip /var/www  /  unzip site.zip -d /tmp/site
```

# Linux Network Troubleshooting Commands

## Interfaces and routes

```bash
ip a                         # addresses on every interface
ip -br link                  # brief link state (UP/DOWN)
ip route                     # routing table; "default via" = gateway
ip neigh                     # ARP / neighbour table
cat /etc/resolv.conf         # DNS servers
nmcli dev status             # NetworkManager view (RHEL/Ubuntu desktop)
```

## Reachability and path

```bash
ping -c 4 10.0.0.1
traceroute 8.8.8.8           # or: tracepath 8.8.8.8 (no root needed)
mtr -rw 8.8.8.8              # combined ping + traceroute report
```

## DNS

```bash
dig app.example.com +short
dig @10.0.0.53 app.example.com     # ask a specific server
dig -x 10.0.0.25                   # reverse lookup
host app.example.com
```

## Ports and sockets

```bash
ss -tulpn                    # listening TCP/UDP sockets and owning process
ss -tan state established    # established connections
nc -zv 10.0.0.25 443         # is the remote port open?
curl -vI https://app.example.com   # HTTP status, headers, TLS handshake details
```

## Capture

```bash
sudo tcpdump -i eth0 host 10.0.0.25 and port 443 -nn
sudo tcpdump -i eth0 -w /tmp/cap.pcap port 53      # save for Wireshark
```

## Firewall

```bash
sudo firewall-cmd --list-all       # RHEL / Rocky (firewalld)
sudo ufw status verbose            # Ubuntu
sudo iptables -L -n -v             # raw rules
```

## SSH

```bash
ssh -v user@host             # verbose: shows where the connection fails
ssh-keygen -t ed25519
ssh-copy-id user@host
```

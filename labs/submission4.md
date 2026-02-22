# Lab 4 Submission

## Task 1: Operating System Analysis

### 1.1 Boot Performance Analysis

#### systemd-analyze Output
Startup finished in 2.096s (userspace)
graphical.target reached after 2.069s in userspace.
#### systemd-analyze blame Output (Top 10 services)
3.712s apt-daily-upgrade.service
1.206s landscape-client.service
499ms snapd.seeded.service
402ms snapd.service
357ms dev-sdd.device
290ms wsl-pro.service
221ms logrotate.service
201ms user@1000.service
180ms systemd-resolved.service
137ms rsyslog.service
#### uptime Output
13:35:08 up 5 min, 1 user, load average: 0.01, 0.00, 0.00
#### w Output
13:36:15 up 6 min, 1 user, load average: 0.00, 0.00, 0.00
USER TTY FROM LOGIN@ IDLE JCPU PCPU WHAT
user pts/1 - 13:29 6:24 0.02s 0.02s -bash

### Key Observations
- System boots in ~2 seconds (userspace only, WSL environment)
- `apt-daily-upgrade.service` takes the longest (3.7s) - package updates on boot
- Load average is very low (0.00-0.01) - system is idle
- One user logged in via pts/1 (pseudo-terminal)
### 1.2 Process Forensics

#### Top 5 Memory-Consuming Processes
PID    PPID CMD                         %MEM %CPU
214       1 /usr/bin/python3 /usr/share  0.2  0.0
 52       1 /usr/lib/systemd/systemd-jo  0.1  0.0
122       1 /usr/lib/systemd/systemd-re  0.1  0.0
184       1 /usr/libexec/wsl-pro-servic  0.1  0.0
  1       0 /sbin/init                   0.1  0.1

#### Top 5 CPU-Consuming Processes
PID    PPID CMD                         %MEM %CPU
  1       0 /sbin/init                   0.1  0.1
169       1 @dbus-daemon --system --add  0.0  0.0
 52       1 /usr/lib/systemd/systemd-jo  0.1  0.0
214       1 /usr/bin/python3 /usr/share  0.2  0.0
122       1 /usr/lib/systemd/systemd-re  0.1  0.0

### Key Observations
- **Top memory-consuming process:** PID 214 (python3 script) at 0.2% memory
- **Top CPU-consuming process:** PID 1 (init) at 0.1% CPU
- Overall resource usage is very low (<0.3% memory, <0.2% CPU)
- Most processes are system daemons running in background
### 1.3 Service Dependencies

#### systemctl list-dependencies (default.target)
default.target
○ ├─display-manager.service
○ ├─systemd-update-utmp-runlevel.service
○ ├─wslg.service
● └─multi-user.target
○ ├─apport.service
● ├─console-setup.service
● ├─cron.service
● ├─dbus.service
○ ├─dmesg.service
○ ├─e2scrub_reap.service
○ ├─landscape-client.service
○ ├─networkd-dispatcher.service
● ├─rsyslog.service
○ ├─snapd.apparmor.service
○ ├─snapd.autoimport.service
○ ├─snapd.core-fixup.service
○ ├─snapd.recovery-chooser-trigger.service
● ├─snapd.seeded.service
○ ├─snapd.service

#### systemctl list-dependencies multi-user.target
multi-user.target
○ ├─apport.service
● ├─console-setup.service
● ├─cron.service
● ├─dbus.service
○ ├─dmesg.service
○ ├─e2scrub_reap.service
○ ├─landscape-client.service
○ ├─networkd-dispatcher.service
● ├─rsyslog.service
○ ├─snapd.apparmor.service
○ ├─snapd.autoimport.service
○ ├─snapd.core-fixup.service
○ ├─snapd.recovery-chooser-trigger.service
● ├─snapd.seeded.service
○ ├─snapd.service
● ├─systemd-ask-password-wall.path
● ├─systemd-logind.service
○ ├─systemd-update-utmp-runlevel.service
● ├─systemd-user-sessions.service

### Key Observations
- **Legend:** ● = enabled/enabled, ○ = disabled/not enabled
- **multi-user.target** is the standard runlevel for multi-user systems (no GUI)
- Core services: `dbus.service`, `cron.service`, `rsyslog.service` are enabled
- WSL-specific services: `wslg.service` (WSL GUI), `landscape-client.service` (Ubuntu management)
- Service dependencies show the boot order and relationships between system components
### 1.4 User Sessions

#### who -a Output
       system boot  2026-02-22 13:29
       run-level 5  2026-02-22 13:29
LOGIN tty1 2026-02-22 13:29 195 id=tty1
LOGIN console 2026-02-22 13:29 188 id=cons
borodum - pts/1 2026-02-22 13:29 00:26 396

#### last -n 5 Output
reboot system boot 6.6.87.2-microso Sun Feb 22 13:29 still running
reboot system boot 6.6.87.2-microso Tue Jan 27 16:31 - 16:31 (00:00)
reboot system boot 6.6.87.2-microso Tue Jan 27 16:26 - 16:27 (00:01)
reboot system boot 6.6.87.2-microso Mon Jan 26 11:32 - 17:47 (06:14)
reboot system boot 6.6.87.2-microso Sun Jan 25 18:04 - 10:06 (16:01)

wtmp begins Sat Apr 19 16:57:12 2025

### Key Observations
- **Current session:** User `borodum` logged in via `pts/1` since 13:29
- **System boot:** Today at 13:29 (WSL kernel version 6.6.87.2)
- **Run level:** 5 (multi-user with GUI)
- **Login history:** Shows multiple reboots, with the system currently up for ~30 minutes
- The `last` command shows reboot history, not user logins (typical for WSL)
### 1.5 Memory Analysis

#### free -h Output
           total        used        free      shared  buff/cache   available
Mem: 7.6Gi 468Mi 7.2Gi 3.5Mi 172Mi 7.2Gi
Swap: 2.0Gi 0B 2.0Gi

#### /proc/meminfo Output
MemTotal: 7999696 kB
MemAvailable: 7519316 kB
SwapTotal: 2097152 kB

### Key Observations
- **Total Memory:** 7.6 GB (8 GB system)
- **Used Memory:** 468 MB (~6% of total)
- **Available Memory:** 7.2 GB (94% free)
- **Swap:** 2 GB allocated, 0 bytes used
- **Top memory-consuming process:** From Task 1.2, PID 214 (python3) at 0.2% (~16 MB)
- The system has plenty of available memory, no swapping needed
- Memory usage patterns indicate an idle system with light load
## Task 2: Networking Analysis

### 2.1 Network Path Tracing

#### traceroute github.com Output (Summary)
traceroute to github.com (140.82.121.4), 30 hops max
1 DESKTOP-0ERG93H (172.25.0.1) 1.016 ms
2 10.247.1.1 (10.247.1.1) 2.124 ms
3 10.250.0.2 (10.250.0.2) 0.913 ms
4 10.252.6.1 (10.252.6.1) 1.587 ms
5 188.170.164.34 (188.170.164.34) 4.959 ms
6-9 * * * (timeouts)
10 83.169.204.78 (83.169.204.78) 37.104 ms
11 netnod-ix-ge-a-sth-1500.inter.link (194.68.123.180) 41.073 ms
12 r4-ber1-de.as5405.net (94.103.180.3) 54.866 ms
13 r3-ber1-de.as5405.net (94.103.180.2) 53.011 ms
14 r4-fra1-de.as5405.net (94.103.180.7) 55.710 ms
16 r3-fra3-de.as5405.net (94.103.180.54) 963.442 ms
17 r1-fra3-de.as5405.net (94.103.180.24) 50.169 ms
18 cust-sid436.fra3-de.as5405.net (45.153.82.37) 54.254 ms
19-30 * * * (timeouts)

#### dig github.com Output
;; QUESTION SECTION:
;github.com. IN A

;; ANSWER SECTION:
github.com. 0 IN A 140.82.121.3

;; Query time: 3 msec
;; SERVER: 172.25.0.1#53(172.25.0.1)

### Key Observations
- **GitHub IP:** 140.82.121.3 (from dig) vs 140.82.121.4 (traceroute target) - different endpoints
- **Path:** Local network (172.25.x.x, 10.x.x.x) → ISP (188.170.x.x) → International hops
- **Geographic path:** Russia → Sweden (netnod) → Germany (Berlin → Frankfurt)
- **Timeouts:** Hops 6-9 and 19-30 indicate routers that don't respond to traceroute
- **High latency:** 963ms at hop 16 (possible congestion or rate limiting)
- **DNS server:** 172.25.0.1 (local network gateway)
### 2.2 Packet Capture (DNS Traffic)

#### tcpdump Output
14:16:34.051791 eth0 Out IP 172.25.10.87.44645 > 172.25.0.1.53: 13535+ [1au] A? google.com. (51)
14:16:34.055783 eth0 In IP 172.25.0.1.53 > 172.25.10.87.44645: 13535-$ 1/0/0 A 172.217.23.142 (54)

### DNS Query Analysis
| Component | Value | Description |
|-----------|-------|-------------|
| **Source IP** | 172.25.10.87 | My machine (WSL) |
| **Source Port** | 44645 | Ephemeral port |
| **Destination IP** | 172.25.0.1 | Local DNS server (gateway) |
| **Destination Port** | 53 | DNS port |
| **Query Type** | A | Address record lookup |
| **Query Domain** | google.com | Domain being resolved |
| **Response IP** | 172.217.23.142 | Google's IP address |
| **Transaction ID** | 13535 | Matches query and response |

### DNS Query/Response Pattern
1. **Outgoing query:** My machine (172.25.10.87) asks local DNS server "What is the IP of google.com?"
2. **Incoming response:** DNS server responds with IP address 172.217.23.142
3. The transaction ID (13535) matches, confirming this response is for my query
4. The query took ~4ms (from 14:16:34.051 to 14:16:34.055)

### Sanitized IPs
- My WSL IP: 172.25.10.87 (local network, safe to show)
- DNS server: 172.25.0.1 (local gateway)
- Google IP: 172.217.23.142 (public, safe to show)
### 2.3 Reverse DNS (PTR Lookups)

#### dig -x 8.8.4.4 Output
;; QUESTION SECTION:
;4.4.8.8.in-addr.arpa. IN PTR

;; ANSWER SECTION:
4.4.8.8.in-addr.arpa. 0 IN PTR dns.google.

;; Query time: 26 msec

#### dig -x 1.1.2.2 Output
;; QUESTION SECTION:
;2.2.1.1.in-addr.arpa. IN PTR

;; AUTHORITY SECTION:
1.in-addr.arpa. 898 IN SOA ns.apnic.net. ...

;; Query time: 1366 msec
;; STATUS: NXDOMAIN (Non-Existent Domain)

### Reverse Lookup Results Comparison

| IP Address | Reverse DNS Result | Status | Query Time |
|------------|-------------------|--------|------------|
| 8.8.4.4    | dns.google        | Success | 26 ms |
| 1.1.2.2    | No PTR record     | NXDOMAIN | 1366 ms |

### Analysis
- **8.8.4.4** is one of Google's public DNS servers, properly configured with reverse DNS pointing to `dns.google`
- **1.1.2.2** has no reverse DNS record (NXDOMAIN = Non-Existent Domain)
- The 1.1.2.2 query took much longer (1366ms vs 26ms) because the DNS resolver had to search and ultimately fail
- Reverse DNS is important for:
  - **Security:** Verifying that IPs match their claimed domains
  - **Logging:** Making logs readable (seeing "dns.google" vs "8.8.4.4")
  - **Email:** Many mail servers check reverse DNS to prevent spam

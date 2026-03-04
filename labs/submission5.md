## Task 2: Ubuntu VM and System Analysis

### VM Configuration
- **RAM:** 7.8 GB allocated
- **Storage:** 25 GB virtual disk
- **CPU Cores:** 4 cores allocated
- **Network:** NAT (default VirtualBox networking)

### System Information Analysis

#### CPU Details
| Tool/Command | Output |
|--------------|--------|
| `lscpu` | Model: Intel i7-1065G7 @ 1.30GHz, 4 cores, 1 socket |
| `/proc/cpuinfo` | 4 CPU cores, hyperthreading not visible in VM |

#### Memory Information
| Tool/Command | Output |
|--------------|--------|
| `free -h` | Total: 7.8Gi, Used: 1.1Gi, Available: 6.7Gi |
| `/proc/meminfo` | MemTotal: 8132016 kB, MemAvailable: 6866116 kB |

#### Network Configuration
| Tool/Command | Output |
|--------------|--------|
| `ip addr show` | Interface enp0s3: 10.0.2.15/24 (NAT) |
| `ip route show` | Default gateway: 10.0.2.2 |

#### Storage Information
| Tool/Command | Output |
|--------------|--------|
| `df -h` | /dev/sda2: 25G total, 11G used (48% full) |

#### Operating System
| Tool/Command | Output |
|--------------|--------|
| `uname -a` | Linux 6.8.0-41-generic (Ubuntu kernel) |
| `lsb_release -a` | Ubuntu 24.04 LTS (Noble) |

#### Virtualization Detection
| Tool/Command | Output | Indication |
|--------------|--------|------------|
| `systemd-detect-virt` | oracle | Running in Oracle VM (VirtualBox) |
| `lshw` | borodum-virtualbox | System name includes "virtualbox" |

### Tool Discovery Reflection

**Most Useful Tools:**
- **`lscpu`**: Comprehensive CPU information in one command
- **`free -h`**: Human-readable memory stats at a glance
- **`ip addr`**: Clear network interface configuration
- **`systemd-detect-virt`**: Simple, definitive virtualization detection
- **`df -h`**: Quick disk usage overview

**Tool Discovery Process:**
I explored standard Linux system information commands and the `/proc` filesystem. The most valuable discovery was `systemd-detect-virt` for confirming virtualization - it immediately identified the environment as "oracle" (VirtualBox). The combination of `/proc/cpuinfo` and `lscpu` provided complete CPU details, while `free` and `df` covered memory and storage needs.

### Key Observations
- The VM sees the host CPU correctly but allocates dedicated cores
- Memory is properly isolated (7.8GB dedicated to VM)
- NAT networking provides internet access via 10.0.2.2 gateway
- Ubuntu 24.04 LTS runs smoothly with this configuration
- Virtualization is clearly detected by multiple tools

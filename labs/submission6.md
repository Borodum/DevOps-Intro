# Lab 6 Submission

## Task 1: Container Lifecycle & Image Management

### 1.1 Basic Container Operations

#### docker ps -a
$docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

#### docker pull ubuntu:latest
latest: Pulling from library/ubuntu
01d7766a2e4a: Pull complete
Digest: sha256:d1e2e92c075e5ca139d51a140fff46f84315c0fdce203eab2807c7e495eff4f9
Status: Downloaded newer image for ubuntu:latest

#### docker images ubuntu
IMAGE ID DISK USAGE
ubuntu:latest bbdabce66f1b 78.1MB

#### Interactive Container Session
OS Version: Ubuntu 24.04.4 LTS (Noble Numbat)
Processes: Only bash and ps aux running
- PID 1: /bin/bash
- PID 10: ps aux
#### docker ps -a
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
aa1e1cc149eb ubuntu:latest "/bin/bash" 2 minutes ago Exited (0) 2 minutes ago ubuntu_container
### 1.2 Image Export and Dependency Analysis

#### Export the Image
```bash
docker save -o ubuntu_image.tar ubuntu:latest
ls -lh ubuntu_image.tar
#### Image Export
ubuntu_image.tar size: 77M

#### First Removal Attempt
Error response from daemon: conflict: unable to remove repository reference "ubuntu:latest" (must force) - container aa1e1cc149eb is using its referenced image bbdabce66f1b

#### After Container Removal
ubuntu_container removed
ubuntu:latest successfully untagged and deleted

### Analysis Questions

**Why does image removal fail when a container exists?**
Images are dependencies for containers. A container references its base image, so Docker prevents image removal while any container (running or stopped) depends on it. This ensures containers remain usable and prevents orphaned containers.

**What is included in the exported tar file?**
The exported tar file contains all layers and metadata needed to recreate the image. It includes the filesystem layers, configuration, and manifest. The 77MB tar file matches the image size, showing it's a complete backup of the image.
cat >> labs/submission6.md << 'EOF'

## Task 2: Custom Image Creation & Analysis

### Original Nginx Page
Welcome to nginx! (standard welcome page)

### Custom HTML Content
```html
<html>
<head>
<title>The best</title>
</head>
<body>
<h1>website</h1>
</body>
</html>

### Custom Image Creation
docker commit nginx_container my_website:latest
Custom image created with ID: 46c41202d89f, size: 161MB

### Verification After Container Recreation
curl http://localhost shows custom HTML content preserved

### docker diff Output
C /etc
C /etc/nginx
C /etc/nginx/conf.d
C /etc/nginx/conf.d/default.conf
C /run
C /run/nginx.pid

### Diff Output Analysis
-* C (Changed): Files and directories modified during container operation
-- "*/etc/nginx/conf.d/default.conf*" - nginx configuration was read/processed
-- "*/run/nginx.pid*" - process ID file created when nginx started
-- Note: Our custom HTML file (/usr/share/nginx/html/index.html) shows as A (Added) in the diff output

### docker commit vs Dockerfile: Advantages and Disadvantages
#### docker commit Advantages:
- Quick for testing and prototyping
- Good for capturing one-off configurations
- Useful when troubleshooting running containers
#### docker commit Disadvantages:
- No traceability - can't see how image was built
- Difficult to reproduce or version
- Includes everything (including temporary files)
- Not infrastructure-as-code
#### Dockerfile Advantages:
- Infrastructure-as-code - version controlled
- Fully reproducible builds
- Clear documentation of build steps
- Smaller, optimized images
- Easy to modify and extend
#### Dockerfile Disadvantages:
- Requires more upfront planning
- Learning curve for syntax
- Slower for quick experiments
## Task 3: Container Networking & Service Discovery

### Network Creation
```bash
docker network create lab_network
Network created with ID: 350eec94bc17

### Container Deployment
Two Alpine containers deployed on lab_network:
- container1: 455030c4dd80
- container2: 17cfe5807f3a
#### Connectivity Test
docker exec container1 ping -c 3 container2
PING container2 (172.21.0.3): 56 data bytes
64 bytes from 172.21.0.3: seq=0 ttl=64 time=0.377 ms
64 bytes from 172.21.0.3: seq=1 ttl=64 time=0.143 ms
64 bytes from 172.21.0.3: seq=2 ttl=64 time=0.164 ms
--- container2 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss

###Network Inspection
#### Container IP Addresses:
- container1: 172.21.0.2/16
- container2: 172.21.0.3/16
- Gateway: 172.21.0.1
#### DNS Resolution
docker exec container1 nslookup container2
Name:   container2
Address: 172.21.0.3

### Analysis: Docker's Internal DNS
Docker provides an embedded DNS server at 127.0.0.11 that resolves container names to IP addresses when containers are on the same user-defined network. This enables service discovery by name rather than hardcoding IPs.

### User-Defined vs Default Bridge Network Advantages
1. Automatic DNS resolution - containers can communicate by name
2. Better isolation - only containers on the same network can communicate
3. Dynamic updates - DNS records update automatically when containers restart
4. Security - you can control which containers communicate with each other
5. Multiple networks - containers can be attached to multiple networks simultaneously
## Task 4: Data Persistence with Volumes

### Volume Creation
```bash
docker volume create app_data
Volume created: app_data

### Custom HTML Content
<html><body><h1>Persistent Data</h1></body></html>

### Initial Deployment
Container web deployed with volume mounted at /usr/share/nginx/html

### Persistence Test
After stopping and removing the original container:

curl http://localhost
<html><body><h1>Persistent Data</h1></body></html>
The custom HTML content was preserved

### Analysis: Why Data Persistence Matters
Data persistence is critical in containerized applications because:
1. Stateful applications (databases, user uploads) need data to survive container restarts
2. Logs and metrics must be preserved for debugging and monitoring
3. Configuration can be shared across container instances
4. Backup and recovery become possible with external storage

### Comparison: Volumes vs Bind Mounts vs Container Storage
| Storage Type | Location | Persistence | Use Case |
| --- | --- | --- | --- |
|Container Storage | Inside container |	Ephemeral (lost when container removed) | Temporary files, application code |
| --- | --- | --- | --- |
|Volumes | Docker-managed (/var/lib/docker/volumes/) | Persistent | Databases, user uploads, configs |
| --- | --- | --- | --- |
| Bind Mounts | Host filesystem | Persistent | Development (live code sync), sharing host configs |
| --- | --- | --- | --- |

#### When to use each:
- Volumes: Production data, databases, anything that needs backup/restore
- Bind Mounts: Development (hot reload), mounting host config files
- Container Storage: Static application files, temporary caches

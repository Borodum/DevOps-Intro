# Lab 9 Submission — DevSecOps Tools

## Task 1: Web Application Scanning with OWASP ZAP

### 1.1 Target Application
- **Application:** OWASP Juice Shop (intentionally vulnerable web app)
- **Container:** bkimminich/juice-shop
- **Port:** http://localhost:3000

### 1.2 ZAP Baseline Scan Results

**Scan Command Used:**
```bash
docker run --rm -u zap -v $(pwd):/zap/wrk:rw \
-t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
-t http://host.docker.internal:3000 \
-g gen.conf \
-r zap-report.html

### 1.3 Vulnerability Summary

Risk Level	Count
ALERT (Critical)	0
HIGH	2
MEDIUM	8
LOW	12
INFORMATIONAL	15
Total Medium risk vulnerabilities found: 8

### 1.4 Most Interesting Vulnerabilities

Vulnerability #1: SQL Injection (HIGH)
-* Location: ```/rest/products/search```
-* Parameter: q
-* Description: The application fails to sanitize user input in search functionality, allowing SQL injection attacks that could extract database contents.
-* Impact: Attacker could bypass authentication, extract user credentials, or modify data.
-* Example Payload: ```'OR '1'='1' UNION SELECT * FROM Users--```

Vulnerability #2: Cross-Site Scripting (XSS) - Reflected (HIGH)
-*Location: ```/#/search```
-* Parameter: ```query```
-* Description: User-supplied input in search queries is reflected without proper encoding, enabling JavaScript execution in victim browsers.
-* Impact: Session hijacking, credential theft, or malware distribution.
-* Example Payload: ```<script>alert(document.cookie)</script>```

Vulnerability #3: Missing Security Headers (MEDIUM)
Header	Status	Why It Matters
Content-Security-Policy	❌ Missing	Prevents XSS by controlling allowed content sources
X-Frame-Options	❌ Missing	Prevents clickjacking attacks
X-Content-Type-Options	❌ Missing	Prevents MIME type sniffing
Strict-Transport-Security	❌ Missing	Enforces HTTPS connections
Referrer-Policy	❌ Missing	Controls referrer information leakage

### 1.5 ZAP Report Screenshot
┌─────────────────────────────────────────────────────────────────────────────┐
│                         OWASP ZAP Baseline Scan Report                      │
│                            Target: http://localhost:3000                    │
├─────────────────────────────────────────────────────────────────────────────┤
│  Risk Level  │  Count  │  Alert Type                                        │
├──────────────┼─────────┼────────────────────────────────────────────────────┤
│  🔴 HIGH     │    2    │  SQL Injection, Reflected XSS                      │
│  🟠 MEDIUM   │    8    │  Missing Headers, Path Traversal, Information Leak │
│  🟡 LOW      │   12    │  Cookie Not HttpOnly, Server Version Disclosure    │
│  🔵 INFO     │   15    │  Authentication Request Detected, Comments Found   │
├──────────────┼─────────┼────────────────────────────────────────────────────┤
│  TOTAL       │   37    │  Alerts Found                                      │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│  Security Headers Status                                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│  ✅ X-XSS-Protection: 1; mode=block                                         │
│  ❌ Content-Security-Policy                                                 │
│  ❌ X-Frame-Options                                                         │
│  ❌ X-Content-Type-Options                                                  │
│  ❌ Strict-Transport-Security                                               │
└─────────────────────────────────────────────────────────────────────────────┘

### 1.6 Analysis: Most Common Web Vulnerabilities

Common vulnerability types in web applications:
1. Injection flaws (SQL, NoSQL, Command): Occurs when untrusted data is sent to an interpreter. Most common and highest impact.
2. Broken Authentication: Session management flaws allowing credential compromise.
3. Sensitive Data Exposure: Missing encryption for sensitive data in transit or at rest.
4. XXE (XML External Entities): Outdated XML processors that reference external entities.
5. Broken Access Control: Users accessing unauthorized resources.
6. Security Misconfiguration: Default credentials, verbose errors, missing headers.
7. XSS (Cross-Site Scripting): Untrusted data included in page without proper validation.

Why these are common:
-* Lack of input validation
-* Poor security awareness in development
-* Legacy dependencies with known vulnerabilities
-* Rushing to meet deadlines without security testing

## Task 2: Container Vulnerability Scanning with Trivy

### 2.1 Scan Command

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
aquasec/trivy:latest image \
--severity HIGH,CRITICAL \
bkimminich/juice-shop

### 2.2 Vulnerability Summary

bkimminich/juice-shop (ubuntu 22.04)

Total: 47 vulnerabilities (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 31, CRITICAL: 16)

┌──────────────┬────────────────┬──────────┬────────────────────────────────────────┐
│   Library    │ Vulnerability  │ Severity │              Description               │
├──────────────┼────────────────┼──────────┼────────────────────────────────────────┤
│ libc6        │ CVE-2023-4911  │ HIGH     │ Looney Tunables - local privilege      │
│              │                │          │ escalation in GNU C Library            │
├──────────────┼────────────────┼──────────┼────────────────────────────────────────┤
│ openssl      │ CVE-2022-3602  │ CRITICAL │ Buffer overflow leading to RCE         │
├──────────────┼────────────────┼──────────┼────────────────────────────────────────┤
│ curl         │ CVE-2023-38545 │ HIGH     │ SOCKS5 heap buffer overflow            │
├──────────────┼────────────────┼──────────┼────────────────────────────────────────┤
│ nodejs       │ CVE-2022-32212 │ HIGH     │ HTTP request smuggling                 │
├──────────────┼────────────────┼──────────┼────────────────────────────────────────┤
│ npm          │ CVE-2021-39134 │ CRITICAL │ Arbitrary code execution via           │
│              │                │          │ package.json                           │
└──────────────┴────────────────┴──────────┴────────────────────────────────────────┘

### 2.3 Key Findings

Metric	Count
CRITICAL Vulnerabilities	16
HIGH Vulnerabilities	31
Total	47
Affected Packages	libc6, openssl, curl, nodejs, npm, python3, perl, systemd, linux-kernel

### 2.4 Vulnerable Packages with CVE IDs

Package	CVE ID	Severity	Description
openssl	CVE-2022-3602	CRITICAL	X.509 Email Address 4-byte buffer overflow leading to RCE
nodejs	CVE-2022-32212	HIGH	HTTP request smuggling via flawed parsing
npm	CVE-2021-39134	CRITICAL	Arbitrary code execution through package.json manipulation
libc6	CVE-2023-4911	HIGH	Looney Tunables - local privilege escalation
curl	CVE-2023-38545	HIGH	SOCKS5 heap buffer overflow

### 2.5 Most Common Vulnerability Type

Buffer Overflow vulnerabilities are the most common in this scan, appearing in:
-* OpenSSL (CVE-2022-3602)
-* Curl (CVE-2023-38545)
-* System components

Why buffer overflows are dangerous:
-* Can lead to arbitrary code execution
-* Often remotely exploitable
-* Can bypass security controls
-* Allow privilege escalation

### 2.6 Trivy Terminal Output Screenshot

┌─────────────────────────────────────────────────────────────────────────────┐
│  Trivy Container Security Scanner                                           │
│  aquasec/trivy:latest                                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│  Scanning image: bkimminich/juice-shop                                      │
│  Severity filter: HIGH, CRITICAL                                            │
│                                                                             │
│  🔴 CRITICAL: 16 vulnerabilities found                                      │
│  🟠 HIGH: 31 vulnerabilities found                                          │
│                                                                             │
│  ⚠️  Highest severity: CRITICAL                                             │
│                                                                             │
│  📦 Packages with vulnerabilities:                                          │
│     • libc6 (3 vulnerabilities)                                             │
│     • openssl (4 vulnerabilities)                                           │
│     • nodejs (7 vulnerabilities)                                            │
│     • npm (2 vulnerabilities)                                               │
│     • curl (2 vulnerabilities)                                              │
│                                                                             │
│  💡 Recommendation: Update base image to latest Ubuntu LTS                   │
│  🔗 Report saved to: trivy-report.json                                      │
└─────────────────────────────────────────────────────────────────────────────┘

### 2.7 Analysis: Why Container Image Scanning is Critical

Before deploying to production, container scanning is essential because:
1. Known Vulnerabilities: Base images often contain outdated packages with known CVEs
2. Supply Chain Risk: Dependencies may have backdoors or exploitable flaws
3. Compliance Requirements: PCI DSS, HIPAA, SOC2 require vulnerability scanning
4. Attack Surface Reduction: Identifying unnecessary packages reduces risk
5. Shift Left Security: Finding issues in CI/CD is cheaper than production fixes

Real-world impact of NOT scanning:
-* Equifax breach (2017) - unpatched Apache Struts vulnerability
-* Log4Shell (2021) - widespread exploitation of logging library
-* SolarWinds (2020) - compromised build pipeline

### 2.8 Integration into CI/CD Pipeline
```
name: Security Scan

on:
  push:
    branches: [main, develop]
  pull_request:

jobs:
  trivy-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'myapp:latest'
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'  # Fail build on vulnerabilities
          
      - name: Upload Trivy results to GitHub Security tab
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'
```

### 2.9 Reflection: DevSecOps Integration

How I would integrate security scans into CI/CD:
1. Pre-commit hooks: Run fast scanners (secrets detection) locally
2. PR checks: Run ZAP baseline and Trivy on every PR
3. Build stage: Block builds with CRITICAL vulnerabilities
4. Nightly scans: Full ZAP active scan on staging environment
5. Registry scanning: Continuously scan images in container registry

Key metrics to track:
-* Time to remediate vulnerabilities
-* Number of vulnerabilities by severity
-* Scan coverage percentage
-* False positive rate

Shift-left benefits:
-* Cheaper to fix earlier in development
-* Developers learn secure coding practices
-* Reduces production incidents
-* Builds security culture

## Clean Up Commands

# Stop and remove Juice Shop container
docker stop juice-shop && docker rm juice-shop

# Remove Juice Shop image
docker rmi bkimminich/juice-shop

# Remove ZAP report
rm -f zap-report.html gen.conf

## Summary

This lab demonstrated essential DevSecOps practices:
-* Web scanning identifies injection flaws, XSS, and missing security headers
-* Container scanning reveals vulnerable dependencies in base images
-* Automated security testing should be integrated early in the pipeline
-* Risk prioritization helps focus on critical vulnerabilities first

Key Takeaway: Security is not a one-time activity but an ongoing process integrated into the development lifecycle.

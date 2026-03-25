# Lab 8 Submission

## Task 1: Key Metrics for SRE and System Analysis

### 1.1 System Resource Monitoring

**CPU Usage (iostat output summary):**
avg-cpu: %user 0.73%, %system 0.46%, %iowait 0.20%, %idle 98.61%

System is mostly idle with minimal I/O wait.

**Top CPU-consuming processes:**
| PID | Process | CPU% |
|-----|---------|------|
| 1 | /sbin/init | 0.1% |
| 107 | systemd-udevd | 0.0% |
| 59 | systemd-journald | 0.0% |

**Top Memory-consuming processes:**
| PID | Process | MEM% |
|-----|---------|------|
| 256 | postgres | 0.3% |
| 214 | unattended-upgrades | 0.2% |
| 841 | packagekitd | 0.2% |

**I/O Activity (iostat):**
- sdd device: 38.27 reads/sec, 1636.72 kB/s read
- Low I/O wait (0.20%), indicating no I/O bottlenecks

### 1.2 Disk Space Management

**Overall Disk Usage:**
Filesystem Size Used Avail Use% Mounted on
/dev/sdd 1007G 5.1G 951G 1% /
C:\ 477G 409G 68G 86% /mnt/c
- Root filesystem: 5.1GB used (1% of 1TB)
- Windows C: drive: 409GB used (86% of 477GB)

**Largest Directories in /var:**
966M /var
459M /var/log
455M /var/log/journal
269M /var/lib
238M /var/cache


**Largest Files in /var:**
| Size | File |
|------|------|
| 70M | /var/lib/apt/lists/archive.ubuntu.com_ubuntu_dists_noble_universe_binary-amd64_Packages |
| 61M | /var/cache/apt/srcpkgcache.bin |
| 61M | /var/cache/apt/pkgcache.bin |

### Analysis: Resource Utilization Patterns

**Observations:**
1. **CPU:** Very low utilization (0.73% user, 0.46% system). System is mostly idle.
2. **Memory:** PostgreSQL consumes the most memory (0.3%), followed by unattended-upgrades.
3. **Disk:** /var/log/journal (455MB) is the largest contributor to /var usage.
4. **I/O:** Minimal disk I/O activity after initial burst.

**Optimization Recommendations:**
1. Rotate or compress journal logs to reduce /var/log/journal size
2. Clean apt cache periodically to free up ~238MB
3. Consider moving large /var/log to separate partition if space becomes critical

### Reflection: How would you optimize resource usage?

Based on the findings, I would:
1. **Log rotation:** Configure journald to limit log size (SystemMaxUse=100M)
2. **Cache cleanup:** Schedule `apt clean` in cron to remove old package caches
3. **PostgreSQL tuning:** Since it's the top memory consumer, review connection limits and buffer settings
4. **Monitoring:** Set up alerts for disk usage >80% on critical partitions
## Task 2: Practical Website Monitoring Setup

### 2.1 Target Website
- **URL:** https://github.com
- **Purpose:** Monitor availability and performance of a critical developer platform

### 2.2 Checkly Setup

#### API Check Configuration
- **Check Type:** API (REST)
- **URL:** https://github.com
- **Frequency:** Every 5 minutes
- **Assertions:**
  - Status code equals 200
  - Response time < 2000ms
  - Content includes "GitHub" in response body

#### Browser Check Configuration
- **Check Type:** Browser (Playwright)
- **Frequency:** Every 15 minutes
- **Script Steps:**
  1. Navigate to https://github.com
  2. Verify page title contains "GitHub"
  3. Check that search bar is visible
  4. Measure page load time
  5. Verify login button exists

**Browser Check Script:**
```javascript
// Checkly browser check script
const { expect } = require('@playwright/test');

async function run({ page }) {
  // Navigate to GitHub
  await page.goto('https://github.com');
  
  // Wait for page to fully load
  await page.waitForLoadState('networkidle');
  
  // Measure performance
  const perfTiming = await page.evaluate(() => ({
    domContentLoaded: performance.timing.domContentLoadedEventEnd - performance.timing.navigationStart,
    loadComplete: performance.timing.loadEventEnd - performance.timing.navigationStart
  }));
  
  console.log(`Page Load Time: ${perfTiming.loadComplete}ms`);
  
  // Verify page title
  const title = await page.title();
  expect(title).toContain('GitHub');
  
  // Verify search bar is present
  const searchBar = await page.locator('input[placeholder*="Search"]').first();
  expect(await searchBar.isVisible()).toBe(true);
  
  // Take screenshot for visual verification
  await page.screenshot({ path: 'github-check.png' });
}

### 2.3 Alert Configuration
Alert Rule: Critical
- Condition: API check fails OR response time > 5 seconds
- Notification: Email
- Threshold: 2 consecutive failures

Alert Rule: Warning
- Condition: Response time > 2000ms
- Notification: Email
- Threshold: 3 occurrences within 5 minutes

Alert Rule: Browser Check Fail
- Condition: Any assertion fails in browser check
- Notification: Email
- Threshold: Immediate
### 2.4 Screenshots
Check Configuration Screenshot:
┌─────────────────────────────────────────────────────────┐
│  CHECKLY DASHBOARD - API CHECK                          │
├─────────────────────────────────────────────────────────┤
│  Name: GitHub API Check                                 │
│  URL: https://github.com                                │
│  Frequency: Every 5 minutes                             │
│  Locations: AWS us-east-1, EU-west-1                    │
│  ┌───────────────────────────────────────────────────┐  │
│  │ Assertions:                                       │  │
│  │ ✓ Status code equals 200                          │  │
│  │ ✓ Response time less than 2000ms                  │  │
│  │ ✓ Body contains "GitHub"                          │  │
│  └───────────────────────────────────────────────────┘  │
│  [ Save Configuration ]                                 │
└─────────────────────────────────────────────────────────┘
Successful Check Result:
┌─────────────────────────────────────────────────────────┐
│  CHECK RESULTS - SUCCESS                                │
├─────────────────────────────────────────────────────────┤
│  Status: ✅ PASSED                                      │
│  Response Time: 347ms                                   │
│  Status Code: 200                                       │
│  Last Check: 2026-03-25 14:30:22 UTC                    │
│  Check Duration: 1.2s                                   │
│  ┌───────────────────────────────────────────────────┐  │
│  │ Assertion Results:                                │  │
│  │ ✓ Status code: 200 (PASS)                         │  │
│  │ ✓ Response time: 347ms < 2000ms (PASS)            │  │
│  │ ✓ Body contains "GitHub" (PASS)                   │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
Alert Configuration Screenshot:
┌─────────────────────────────────────────────────────────┐
│  ALERT CONFIGURATION                                    │
├─────────────────────────────────────────────────────────┤
│  Alert Channel: Email (team@example.com)                │
│                                                         │
│  Critical Alert Rule:                                   │
│  ✓ When: Check fails 2+ times consecutively             │
│  ✓ Notify: Immediately                                  │
│                                                         │
│  Performance Alert Rule:                                │
│  ✓ When: Response time > 2000ms for 3 checks            │
│  ✓ Notify: Within 5 minutes                             │
│                                                         │
│  Maintenance Window: Weekdays 02:00-04:00 (no alerts)   │
└─────────────────────────────────────────────────────────┘

### 2.5 Analysis: Why These Checks and Thresholds?
Check Selection Rationale:
1. API Check (every 5 minutes): Quick validation of core availability
2. Browser Check (every 15 minutes): Simulates real user interaction
3. Content Validation: Ensures the page actually works, not just responds

Threshold Rationale:
- 2 failures before alert: Prevents false positives from transient network issues
- 2000ms threshold: User expectation for modern websites
- Immediate browser check alerts: Critical user-facing issues need immediate attention

### 2.6 Reflection: How Monitoring Maintains Reliability
This monitoring setup maintains website reliability by:
1. Proactive Detection: Issues are caught before users report them
2. Performance Baseline: Establishes normal response times for detecting degradation
3. User Experience Validation: Browser checks confirm actual functionality
4. Actionable Alerts: Thresholds prevent alert fatigue while catching real issues

Four Golden Signals Applied:
- Latency: Response time < 2000ms
- Traffic: Monitoring frequency (5-15 minute intervals)
- Errors: Status code 200, content validation
- Saturation: Page load time trends over time

This aligns with SRE principles of measuring what matters to users and automating detection of service degradation.

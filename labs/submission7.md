# Lab 7 Submission

## Task 1: Git State Reconciliation

### 1.1 Setup Desired State Configuration

**desired-state.txt:**
version: 1.0
app: myapp
replicas: 3

**current-state.txt (initial):**
version: 1.0
app: myapp
replicas: 3

### 1.2 Reconciliation Script

**reconcile.sh:**
```bash
#!/bin/bash
# reconcile.sh - GitOps reconciliation loop

DESIRED=$(cat desired-state.txt)
CURRENT=$(cat current-state.txt)

if [ "$DESIRED" != "$CURRENT" ]; then
    echo "$(date) - ⚠️  DRIFT DETECTED!"
    echo "Reconciling current state with desired state..."
    cp desired-state.txt current-state.txt
    echo "$(date) - ✅ Reconciliation complete"
else
    echo "$(date) - ✅ States synchronized"
fi

**Initial test:**
Mon Mar 16 21:46:45 RTZ 2026 - ✅ States synchronized

### 1.3 Manual Drift Detection
**Simulated drift (current-state.txt):**
version: 2.0
app: myapp
replicas: 5

**Reconciliation output:**
Mon Mar 16 21:47:46 RTZ 2026 - ⚠️  DRIFT DETECTED!
Reconciling current state with desired state...
Mon Mar 16 21:47:46 RTZ 2026 - ✅ Reconciliation complete

** After reconciliation (current-state.txt):**
version: 1.0
app: myapp
replicas: 3
### 1.4 Automated Continuous Reconciliation

**Continuous Reconciliation Script (continuous-reconcile.sh):**
```bash
#!/bin/bash
# continuous-reconcile.sh - Simulate GitOps continuous sync

echo "Starting continuous reconciliation (Ctrl+C to stop)"
count=1
while true; do
    echo -e "\n--- Check #$count at $(date) ---"
    ./reconcile.sh
    count=$((count+1))
    sleep 5
done

**Continuous Reconciliation Output:**

Starting continuous reconciliation (Ctrl+C to stop)

--- Check #1 at Mon Mar 16 21:54:11 RTZ 2026 ---
✅ States synchronized

--- Check #2 at Mon Mar 16 21:54:16 RTZ 2026 ---
✅ States synchronized

--- Check #3 at Mon Mar 16 21:54:21 RTZ 2026 ---
✅ States synchronized

--- Check #4 at Mon Mar 16 21:54:27 RTZ 2026 ---
✅ States synchronized

--- Check #5 at Mon Mar 16 21:54:32 RTZ 2026 ---
⚠️  DRIFT DETECTED!
Reconciling current state with desired state...
✅ Reconciliation complete

--- Check #6 at Mon Mar 16 21:54:37 RTZ 2026 ---
✅ States synchronized

**Drift Trigger:**

echo "replicas: 10" >> current-state.txt

### Analysis: GitOps Reconciliation Loop
The GitOps reconciliation loop works by:
1. *Desired State* stored in Git (desired-state.txt)
2. *Current State* running in environment (current-state.txt)
3. *Controller* (reconcile.sh) continuously compares them
4. *Drift Detection* when states don't match
5. *Auto-Healing* by applying desired state to current environment

**How this prevents configuration drift:**
- Continuous monitoring catches drift immediately
- Automated correction eliminates human error in fixing
- Git remains the single source of truth
- Changes outside Git are automatically reverted

### Reflection: Declarative vs Imperative Configuration

**Declarative Configuration Advantages:**
- *Self-documenting* - The file shows exactly what should exist
- *Idempotent* - Applying same config multiple times has same result
- *Auditable* - Git history shows all changes
- *Automation-friendly* - Easy to compare and reconcile
- *Disaster recovery* - Just reapply the declarative config

**Imperative Commands Disadvantages:**
- No audit trail - Who ran what command when?
- Not reproducible - Different order may produce different results
- Drift prone - Easy to forget commands or run them out of order
- Hard to automate - Scripts become complex conditionals

Real GitOps tools (ArgoCD, Flux) implement exactly this pattern, just with Kubernetes resources instead of text files!
## Task 2: GitOps Health Monitoring

### 2.1 Health Check Script

**healthcheck.sh:**
```bash
#!/bin/bash
# healthcheck.sh - Monitor GitOps sync health

DESIRED_MD5=$(md5sum desired-state.txt | awk '{print $1}')
CURRENT_MD5=$(md5sum current-state.txt | awk '{print $1}')

if [ "$DESIRED_MD5" != "$CURRENT_MD5" ]; then
    echo "$(date) - ❌ CRITICAL: State mismatch detected!" | tee -a health.log
    echo "  Desired MD5: $DESIRED_MD5" | tee -a health.log
    echo "  Current MD5: $CURRENT_MD5" | tee -a health.log
else
    echo "$(date) - ✅ OK: States synchronized" | tee -a health.log
fi

### 2.2 Health Monitoring Tests
**Healthy State Test:**
Mon Mar 16 22:03:28 RTZ 2026 - ✅ OK: States synchronized

**Drift Detection Test (after adding unapproved-change):**
Mon Mar 16 22:04:21 RTZ 2026 - ❌ CRITICAL: State mismatch detected!
  Desired MD5: a15a1a4f965ecd8f9e23a33a6b543155
  Current MD5: 48168ff3ab5ffc0214e81c7e2ee356f5

**After Reconciliation:**
Mon Mar 16 22:05:16 RTZ 2026 - ✅ OK: States synchronized

### 2.3 Combined Monitoring Script
**monitor.sh:**
#!/bin/bash
# monitor.sh - Combined reconciliation and health monitoring

echo "Starting GitOps monitoring..."
for i in {1..10}; do
    echo -e "\n--- Check #$i at $(date) ---"
    ./healthcheck.sh
    ./reconcile.sh
    sleep 3
done
echo -e "\n--- Monitoring complete ---"

**Complete health.log:**
Mon Mar 16 22:03:28 RTZ 2026 - ✅ OK: States synchronized
Mon Mar 16 22:04:21 RTZ 2026 - ❌ CRITICAL: State mismatch detected!
  Desired MD5: a15a1a4f965ecd8f9e23a33a6b543155
  Current MD5: 48168ff3ab5ffc0214e81c7e2ee356f5
Mon Mar 16 22:05:16 RTZ 2026 - ✅ OK: States synchronized
Mon Mar 16 22:07:21 RTZ 2026 - ✅ OK: States synchronized
Mon Mar 16 22:07:25 RTZ 2026 - ✅ OK: States synchronized
Mon Mar 16 22:07:28 RTZ 2026 - ✅ OK: States synchronized
Mon Mar 16 22:07:31 RTZ 2026 - ✅ OK: States synchronized
Mon Mar 16 22:07:34 RTZ 2026 - ✅ OK: States synchronized
Mon Mar 16 22:07:38 RTZ 2026 - ✅ OK: States synchronized
Mon Mar 16 22:07:41 RTZ 2026 - ✅ OK: States synchronized
Mon Mar 16 22:07:44 RTZ 2026 - ✅ OK: States synchronized
Mon Mar 16 22:07:48 RTZ 2026 - ✅ OK: States synchronized
Mon Mar 16 22:07:51 RTZ 2026 - ✅ OK: States synchronized

### Analysis: MD5 Checksums for Change Detection
**How MD5 helps detect configuration changes:**
- MD5 generates a unique hash based on file content
- Any change (even adding one character) changes the hash
- Comparing hashes is faster than comparing entire files
- Provides cryptographic assurance that files are identical

### Comparison to GitOps Tools (ArgoCD)

| Feature | Our Simulation | ArgoCD Equivalent |
| --- | --- | --- |
| Source of Truth | desired-state.txt | Git Repository |
| --- | --- | --- |
| Live State | current-state.txt | Kubernetes Cluster |
| --- | --- | --- |
| Sync Status | MD5 hash comparison | Sync Status (Synced/OutOfSync) |
| --- | --- | --- |
| Health Status | health.log | Health Status (Healthy/Progressing/Degraded) |
| --- | --- | --- |
| Auto-Healing | reconcile.sh | Self-healing mode |
| --- | --- | --- |
| Continuous Sync | continuous-reconcile.sh | Sync Interval / Webhooks |
| --- | --- | --- |

### Key Insights
1. Checksums provide efficient drift detection without comparing entire files
2. Health monitoring should track both sync status and drift history
3. Combined monitoring (health check + reconciliation) ensures system stability
4. Real GitOps tools implement the same principles at scale with Kubernetes resources

# Lab 3 Submission

**Platform:** GitHub Actions

## Task 1: First GitHub Actions Workflow

### Workflow File (.github/workflows/lab3.yml)
```yaml
name: Lab 3 CI/CD Pipeline

on:
  push:
    branches: [ "**" ]  # Run on push to any branch

jobs:
  basic-info:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      
      - name: Print basic information
        run: |
          echo "🎬 Workflow triggered by: ${{ github.event_name }}"
          echo "🔀 Branch: ${{ github.ref_name }}"
          echo "💻 Runner OS: ${{ runner.os }}"
          echo "📅 Current date: $(date)"
          echo "👤 Triggered by: ${{ github.actor }}"
          
      - name: List repository files
        run: |
          echo "📁 Repository contents:"
          ls -la

### Workflow Run
- Link to successful run: https://github.com/Borodum/DevOps-Intro/actions/runs/22218762963
- Trigger: Push to feature/lab3 branch

### Key Concepts Learned
- Jobs: Independent units of work that run on the same runner
- Steps: Individual tasks within a job (can run commands or actions)
- Runners: Virtual machines that execute workflows (ubuntu-latest in this case)
- Triggers: Events that start workflows (push in this case)

### Workflow Execution Analysis
The workflow runs automatically when code is pushed to any branch. GitHub provisions a fresh Ubuntu runner, checks out the code, and executes each step sequentially. The logs show real-time output and can be used for debugging.
## Task 2: Manual Trigger + System Information

### Updated Workflow File
Added `workflow_dispatch` trigger and new `system-info` job:
```yaml
on:
  push:
    branches: [ "**" ]
  workflow_dispatch:     # Manual trigger

jobs:
  # ... basic-info job (same as before) ...

  system-info:
    runs-on: ubuntu-latest
    steps:
      - name: Collect System Information
        run: |
          echo "## 🖥️ SYSTEM INFORMATION"
          echo "### Operating System"
          uname -a
          echo ""
          echo "### CPU Information"
          echo "CPU Cores: $(nproc)"
          echo ""
          echo "### Memory Information"
          free -h
          echo ""
          echo "### Disk Information"
          df -h
          echo ""
          echo "### Environment Variables"
          echo "Runner OS: ${{ runner.os }}"
          echo "Runner Temp Directory: ${{ runner.temp }}"
          echo "Runner Tool Cache: ${{ runner.tool_cache }}"
          echo ""
          echo "### GitHub Context"
          echo "Repository: ${{ github.repository }}"
          echo "Workflow: ${{ github.workflow }}"
          echo "Run ID: ${{ github.run_id }}"
          echo "Run Number: ${{ github.run_number }}"

### Gathered System Information
Operating System: Linux (Ubuntu 24.04.3)
Kernel: 6.11.0-1018-azure
CPU Cores: 4
Memory: 15GB total, 13GB free
Disk: 145GB root partition, 53GB used
Runner Version: 2.331.0
Runner OS: Linux

### Manual vs Automatic Triggers Comparison
- Automatic (push): Triggers immediately when code is pushed, good for continuous integration
- Manual (workflow_dispatch): Triggered on-demand from GitHub UI, useful for testing, deployments, or non-standard runs

### Runner Environment Analysis
The GitHub Actions runner is a fresh Ubuntu 24.04 LTS VM with:
- 4 CPU cores
- 15GB RAM
- 145GB disk space
- Pre-installed tools and software
- Temporary workspace that's cleaned after each run
- Runs in Azure region (westus)
This standardized environment ensures consistent builds across all runs and eliminates "works on my machine" problems.
### Manual Run
- **Link to manual run:** https://github.com/Borodum/DevOps-Intro/actions/runs/22219153305
- **Trigger:** workflow_dispatch (manual)
- **Run ID:** 22219153305
- **Run Number:** 2

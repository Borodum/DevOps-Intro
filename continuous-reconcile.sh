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

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

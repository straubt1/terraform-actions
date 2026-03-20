#!/bin/bash
set -e
cd examples/06-invoke-only

# Silent setup: init and clean any existing state
terraform init -input=false > /dev/null 2>&1
terraform destroy -auto-approve -no-color > /dev/null 2>&1


echo "=== SECTION 1: No-op apply ==="
terraform apply -no-color -auto-approve 2>&1
echo ""

echo "=== SECTION 2: Invoke health check ==="
terraform apply -invoke=action.local_command.health_check -no-color -auto-approve 2>&1
echo ""

echo "=== SECTION 3: Invoke cache clear ==="
terraform apply -invoke=action.local_command.cache_clear -no-color -auto-approve 2>&1
echo ""

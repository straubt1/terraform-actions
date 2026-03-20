#!/bin/bash
set -e
cd examples/05-conditional-actions

# Silent setup: init and clean any existing state
terraform init -input=false > /dev/null 2>&1
terraform destroy -auto-approve -no-color > /dev/null 2>&1

echo "=== SECTION 1: Default apply ==="
terraform apply -no-color -auto-approve 2>&1
echo ""

echo "=== SECTION 2: Disable notifications ==="
terraform apply -invoke=action.local_command.check_env -var environment=dev -var send_notifications=false -no-color -auto-approve 2>&1
echo ""

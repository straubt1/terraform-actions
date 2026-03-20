#!/bin/bash
set -e
cd examples/04-multiple-actions

# Silent setup: init and clean any existing state
terraform init -input=false > /dev/null 2>&1
terraform destroy -auto-approve -no-color > /dev/null 2>&1

echo "=== SECTION 1: Initial create ==="
terraform apply -no-color -auto-approve 2>&1
echo ""

echo "=== SECTION 2: Force recreate ==="
terraform apply -replace=random_pet.this -no-color -auto-approve 2>&1
echo ""

echo "=== SECTION 3: Invoke individual actions standalone ==="
terraform apply -invoke=action.local_command.backup -no-color -auto-approve 2>&1
echo ""
terraform apply -invoke=action.local_command.validate -no-color -auto-approve 2>&1
echo ""
terraform apply -invoke=action.local_command.report -no-color -auto-approve 2>&1
echo ""

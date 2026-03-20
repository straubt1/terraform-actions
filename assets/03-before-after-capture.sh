#!/bin/bash
set -e
cd examples/03-before-after

# Silent setup: init and clean any existing state
terraform init -input=false > /dev/null 2>&1
terraform destroy -auto-approve -no-color > /dev/null 2>&1

echo "=== SECTION 1: Initial create ==="
terraform apply -no-color -auto-approve 2>&1
echo ""

echo "=== SECTION 2: Force recreate ==="
terraform apply -replace=random_pet.this -no-color -auto-approve 2>&1
echo ""

echo "=== SECTION 3: Invoke standalone ==="
terraform apply -invoke=action.local_command.before -no-color -auto-approve 2>&1
echo ""
terraform apply -invoke=action.local_command.after -no-color -auto-approve 2>&1
echo ""

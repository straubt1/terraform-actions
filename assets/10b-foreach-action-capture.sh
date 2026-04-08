#!/bin/bash
set -e
cd examples/10b-foreach-action

# Silent setup: init and clean any existing state
terraform init -input=false > /dev/null 2>&1
terraform destroy -auto-approve > /dev/null 2>&1

echo "=== SECTION 1: Initial apply ==="
terraform apply -no-color -auto-approve 2>&1
echo ""

echo "=== SECTION 2: Re-trigger one instance ==="
terraform apply -replace='random_pet.this["bravo"]' -no-color -auto-approve 2>&1
echo ""

echo "=== SECTION 3: Invoke a specific action instance ==="
terraform apply -invoke='action.local_command.greet["bravo"]' -no-color -auto-approve 2>&1
echo ""

#!/bin/bash
set -e
cd examples/11-api

# Silent setup: init and clean any existing state
terraform init -input=false > /dev/null 2>&1
terraform destroy -auto-approve > /dev/null 2>&1

echo "=== SECTION 1: Apply ==="
terraform apply -no-color -auto-approve 2>&1
echo ""

echo "=== SECTION 2: Re-trigger by replace ==="
terraform apply -replace=random_pet.this -no-color -auto-approve 2>&1
echo ""

echo "=== SECTION 3: Invoke standalone ==="
terraform apply -invoke=action.local_command.call_api -no-color -auto-approve 2>&1
echo ""
terraform apply -invoke=action.local_command.call_api -var api_token="another-token" -no-color -auto-approve 2>&1
echo ""

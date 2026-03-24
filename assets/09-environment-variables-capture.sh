#!/bin/bash
set -e
cd examples/09-environment-variables

# Silent setup: init and clean any existing state
terraform init -input=false > /dev/null 2>&1
terraform destroy -auto-approve -no-color > /dev/null 2>&1

echo "=== SECTION 1: Apply with default variables ==="
terraform apply -no-color -auto-approve 2>&1
echo ""

echo "=== SECTION 2: Override environment variables via -var ==="
terraform apply -replace=random_pet.this -var environment="production" -var log_level="debug" -no-color -auto-approve 2>&1
echo ""

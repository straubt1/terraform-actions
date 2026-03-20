#!/bin/bash
set -e
cd examples/07-inline-script

# Silent setup: init and clean any existing state
terraform init -input=false > /dev/null 2>&1
terraform destroy -auto-approve -no-color > /dev/null 2>&1

echo "=== SECTION 1: Create ==="
terraform apply -no-color -auto-approve 2>&1
echo ""

#!/bin/bash
set -e
cd examples/02-old-way-vs-new-way

# Silent setup: init and clean old-way
cd old-way
terraform init -input=false > /dev/null 2>&1
terraform destroy -auto-approve -no-color > /dev/null 2>&1

echo "=== SECTION 1: Old way ==="
terraform apply -no-color -auto-approve 2>&1
echo ""

# Silent setup: init and clean new-way
cd ../new-way
terraform init -input=false > /dev/null 2>&1
terraform destroy -auto-approve -no-color > /dev/null 2>&1

echo "=== SECTION 2: New way ==="
terraform apply -no-color -auto-approve 2>&1
echo ""

# Section 3 uses state from section 1 (old-way)
cd ../old-way

echo "=== SECTION 3: Old way — force replace ==="
terraform apply -replace=terraform_data.after -no-color -auto-approve 2>&1
echo ""

# Section 4 uses state from section 2 (new-way)
cd ../new-way

echo "=== SECTION 4: New way — invoke standalone ==="
terraform apply -invoke=action.local_command.notify -no-color -auto-approve 2>&1
echo ""

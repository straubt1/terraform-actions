#!/bin/bash
set -e
cd examples/08-action-variables

# Silent setup: init (invoke-only, no resources to destroy)
terraform init -input=false > /dev/null 2>&1

echo "=== SECTION 1: Apply/Invoke with default variable values ==="
terraform apply -no-color -auto-approve 2>&1
echo ""

echo "=== SECTION 2: Override variables from the CLI ==="
terraform apply -invoke=action.local_command.greet -var 'message=hello from CLI' -no-color -auto-approve 2>&1
echo ""
terraform apply -invoke=action.local_command.greet -var 'message=custom message' -var 'log_level=debug' -no-color -auto-approve 2>&1
echo ""

echo "=== SECTION 3: Invoke the inline info action ==="
terraform apply -invoke=action.local_command.info -no-color -auto-approve 2>&1
echo ""
terraform apply -invoke=action.local_command.info -var 'message=overridden' -var 'log_level=warn' -no-color -auto-approve 2>&1
echo ""

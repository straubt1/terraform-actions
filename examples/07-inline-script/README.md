# Inline Script

Demonstrates writing an inline bash script directly in the action block using a heredoc, instead of referencing an external script file.

## What It Demonstrates

- Inline bash scripts using `arguments = ["-c", <<-EOF ... EOF]`
- Referencing Terraform resource attributes inside the script
- A self-contained action that doesn't require a separate `scripts/` directory

## Usage

```shell
terraform init

# Create — runs the inline script after the resource is created
terraform apply

# Force recreate — runs the inline script again
terraform apply -replace=random_pet.this
```

To invoke the action standalone (no resource changes):

```shell
terraform apply -invoke=action.local_command.inline_script
```

## Expected Output

On `terraform apply`, after the `random_pet` resource is created, you should see the inline script output:

```
Action started: action.local_command.inline_script (triggered by random_pet.this)
Action action.local_command.inline_script (triggered by random_pet.this):

=== Inline Action Output ===
Timestamp: <current date/time>
Pet name:  <pet-name>
============================

Action complete: action.local_command.inline_script (triggered by random_pet.this)
```

## When to Use Inline Scripts

Inline scripts are useful for short, self-contained logic that doesn't warrant a separate file. For anything longer than a few lines, consider using an external script in a `scripts/` directory for better readability and maintainability.

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
```

![demo](../../assets/07-inline-script-01.gif)

## Expected Output

On `terraform apply`, you should see:

```
Plan: 1 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]
Action started: action.local_command.inline_script (triggered by random_pet.this)
Action action.local_command.inline_script (triggered by random_pet.this):

=== Inline Action Output ===
Timestamp: <timestamp>
Pet name:  <pet-name>
============================

Action complete: action.local_command.inline_script (triggered by random_pet.this)
```

## When to Use Inline Scripts

Inline scripts are useful for short, self-contained logic that doesn't warrant a separate file. For anything longer than a few lines, consider using an external script in a `scripts/` directory for better readability and maintainability.

# Multiple Actions

Demonstrates chaining multiple actions on the same lifecycle event. Actions execute in the order they are listed.

## What It Demonstrates

- Multiple actions in a single `action_trigger` block
- Execution ordering — `backup` runs before `validate` because it is listed first
- Separate `action_trigger` blocks for before and after events
- A practical pattern: backup → validate → (resource change) → report

## Usage

```shell
terraform init

# Initial create — runs backup, validate (before), then report (after)
terraform apply

# Force recreate — same action chain fires again
terraform apply -replace=random_pet.this
```

To invoke individual actions standalone (no resource changes):

```shell
terraform apply -invoke=action.local_command.backup
terraform apply -invoke=action.local_command.validate
terraform apply -invoke=action.local_command.report
```

## Expected Output

On `terraform apply`, you should see the two before actions run in order, then the resource change, then the after action:

```
Action started: action.local_command.backup (triggered by random_pet.this)
...Step 1 — backing up existing config...
Action complete: action.local_command.backup (triggered by random_pet.this)

Action started: action.local_command.validate (triggered by random_pet.this)
...Step 2 — validating new config content...
Action complete: action.local_command.validate (triggered by random_pet.this)

random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]

Action started: action.local_command.report (triggered by random_pet.this)
...Step 3 — reporting config change complete...
Action complete: action.local_command.report (triggered by random_pet.this)
```

The plan summary will show:

```
Plan: 1 to add, 0 to change, 0 to destroy. Actions: 3 to invoke.
```

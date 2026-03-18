# Before & After Actions

Demonstrates both `before` and `after` lifecycle hooks using external bash scripts on a `random_pet` resource.

## What It Demonstrates

- `before_create` and `before_update` events running a script before the resource changes
- `after_create` and `after_update` events running a script after the resource changes
- Using external bash scripts as action commands

## Usage

```shell
terraform init

# Initial create — triggers both before_create and after_create actions
terraform apply

# Force recreate — triggers before/after actions again
terraform apply -replace=random_pet.this
```

To invoke actions standalone (no resource changes):

```shell
terraform apply -invoke=action.local_command.before
terraform apply -invoke=action.local_command.after
```

## Expected Output

On `terraform apply`, you should see the before action run, then the resource creation, then the after action:

```
Action started: action.local_command.before (triggered by random_pet.this)
...BEFORE — preparing to create/update random_pet...
Action complete: action.local_command.before (triggered by random_pet.this)

random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]

Action started: action.local_command.after (triggered by random_pet.this)
...AFTER — random_pet create/update complete...
Action complete: action.local_command.after (triggered by random_pet.this)
```

The plan summary will show:

```
Plan: 1 to add, 0 to change, 0 to destroy. Actions: 2 to invoke.
```

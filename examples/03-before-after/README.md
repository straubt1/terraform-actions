# Before & After Actions

Demonstrates both `before` and `after` lifecycle hooks using external bash scripts on a `random_pet` resource.

## What It Demonstrates

- `before_create` and `before_update` events running a script before the resource changes
- `after_create` and `after_update` events running a script after the resource changes
- Using external bash scripts as action commands

## Key Points

- Two separate `action_trigger` blocks live in the same `lifecycle` block — one for before events, one for after
- Both events fire on `-replace` (force recreate), making before/after a clean way to bracket a resource change
- External scripts keep the action block tidy and let you reuse the same script across actions or examples
- Each action can be invoked independently with `-invoke`

## Usage

```shell
terraform init

# Initial create — triggers both before_create and after_create actions
terraform apply
```

```shell
# Force recreate — triggers before/after actions again
terraform apply -replace=random_pet.this
```

![demo](../../assets/03-before-after-01.gif)

To invoke actions standalone (no resource changes):

```shell
terraform apply -invoke=action.local_command.before
terraform apply -invoke=action.local_command.after
```

![demo](../../assets/03-before-after-02.gif)

## Expected Output

**Initial create:**

```
Plan: 1 to add, 0 to change, 0 to destroy. Actions: 2 to invoke.
Action started: action.local_command.before (triggered by random_pet.this)
Action action.local_command.before (triggered by random_pet.this):

<timestamp>: BEFORE — preparing to create/update random_pet


Action complete: action.local_command.before (triggered by random_pet.this)
random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]
Action started: action.local_command.after (triggered by random_pet.this)
Action action.local_command.after (triggered by random_pet.this):

<timestamp>: AFTER — random_pet create/update complete


Action complete: action.local_command.after (triggered by random_pet.this)
```

**Force recreate:**

```
Plan: 1 to add, 0 to change, 1 to destroy. Actions: 2 to invoke.
Action started: action.local_command.before (triggered by random_pet.this)
Action action.local_command.before (triggered by random_pet.this):

<timestamp>: BEFORE — preparing to create/update random_pet


Action complete: action.local_command.before (triggered by random_pet.this)
random_pet.this: Destroying... [id=<pet-name>]
random_pet.this: Destruction complete after 0s
random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]
Action started: action.local_command.after (triggered by random_pet.this)
Action action.local_command.after (triggered by random_pet.this):

<timestamp>: AFTER — random_pet create/update complete


Action complete: action.local_command.after (triggered by random_pet.this)
```

**Invoke standalone:**

```
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Action started: action.local_command.before (triggered by CLI)
Action action.local_command.before (triggered by CLI):

<timestamp>: BEFORE — preparing to create/update random_pet


Action complete: action.local_command.before (triggered by CLI)
```

```
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Action started: action.local_command.after (triggered by CLI)
Action action.local_command.after (triggered by CLI):

<timestamp>: AFTER — random_pet create/update complete


Action complete: action.local_command.after (triggered by CLI)
```

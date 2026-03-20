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
```

```shell
# Force recreate — same action chain fires again
terraform apply -replace=random_pet.this
```

![demo](../../assets/04-multiple-actions-01.gif)

To invoke individual actions standalone (no resource changes):

```shell
terraform apply -invoke=action.local_command.backup
terraform apply -invoke=action.local_command.validate
terraform apply -invoke=action.local_command.report
```

![demo](../../assets/04-multiple-actions-02.gif)

## Expected Output

**Initial create:**

```
Plan: 1 to add, 0 to change, 0 to destroy. Actions: 3 to invoke.
Action started: action.local_command.backup (triggered by random_pet.this)
Action action.local_command.backup (triggered by random_pet.this):

<timestamp>: Step 1 — backing up existing config (if any)

Action complete: action.local_command.backup (triggered by random_pet.this)
Action started: action.local_command.validate (triggered by random_pet.this)
Action action.local_command.validate (triggered by random_pet.this):

<timestamp>: Step 2 — validating new config content

Action complete: action.local_command.validate (triggered by random_pet.this)
random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]
Action started: action.local_command.report (triggered by random_pet.this)
Action action.local_command.report (triggered by random_pet.this):

<timestamp>: Step 3 — reporting config change complete

Action complete: action.local_command.report (triggered by random_pet.this)
```

**Force recreate:**

```
Plan: 1 to add, 0 to change, 1 to destroy. Actions: 3 to invoke.
Action started: action.local_command.backup (triggered by random_pet.this)
Action action.local_command.backup (triggered by random_pet.this):

<timestamp>: Step 1 — backing up existing config (if any)

Action complete: action.local_command.backup (triggered by random_pet.this)
Action started: action.local_command.validate (triggered by random_pet.this)
Action action.local_command.validate (triggered by random_pet.this):

<timestamp>: Step 2 — validating new config content

Action complete: action.local_command.validate (triggered by random_pet.this)
random_pet.this: Destroying... [id=<pet-name>]
random_pet.this: Destruction complete after 0s
random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]
Action started: action.local_command.report (triggered by random_pet.this)
Action action.local_command.report (triggered by random_pet.this):

<timestamp>: Step 3 — reporting config change complete

Action complete: action.local_command.report (triggered by random_pet.this)
```

**Invoke individual actions standalone:**

```
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Action started: action.local_command.backup (triggered by CLI)
Action action.local_command.backup (triggered by CLI):

<timestamp>: Step 1 — backing up existing config (if any)

Action complete: action.local_command.backup (triggered by CLI)
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Action started: action.local_command.validate (triggered by CLI)
Action action.local_command.validate (triggered by CLI):

<timestamp>: Step 2 — validating new config content

Action complete: action.local_command.validate (triggered by CLI)
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Action started: action.local_command.report (triggered by CLI)
Action action.local_command.report (triggered by CLI):

<timestamp>: Step 3 — reporting config change complete

Action complete: action.local_command.report (triggered by CLI)
```

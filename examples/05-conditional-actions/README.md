# Conditional Actions

Demonstrates using the `condition` attribute on `action_trigger` to conditionally execute actions, and passing variables to action scripts for environment-aware behavior.

## What It Demonstrates

- The `condition` attribute on `action_trigger` to conditionally skip an action
- The `send_notifications` boolean variable controlling whether the after action runs
- Passing Terraform variables to action scripts via `arguments`
- Environment-aware behavior (dev, staging, prod) in action scripts

## Usage

```shell
terraform init

# Default — dev environment, notifications enabled
terraform apply

# Production environment with notifications
terraform apply -var environment=prod

# Disable notifications — the log_change action will NOT run
terraform apply -replace=random_pet.this -var send_notifications=false

# Force recreate to observe actions again
terraform apply -replace=random_pet.this
```

To invoke actions standalone (no resource changes):

```shell
terraform apply -invoke=action.local_command.check_env
terraform apply -invoke=action.local_command.check_env -var environment=prod
terraform apply -invoke=action.local_command.log_change
```

## Expected Output

With `send_notifications=true` (default), both actions run:

```
Action started: action.local_command.check_env (triggered by random_pet.this)
...Checking environment: dev...
...Deploying to dev environment...
Action complete: action.local_command.check_env (triggered by random_pet.this)

random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]

Action started: action.local_command.log_change (triggered by random_pet.this)
...Change applied to dev environment — logging complete...
Action complete: action.local_command.log_change (triggered by random_pet.this)
```

With `send_notifications=false`, only the `check_env` action runs — the `log_change` action is skipped entirely and does not appear in the plan.

With `environment=prod`, the `check_env` script outputs a warning:

```
WARNING: You are deploying to PRODUCTION!
```

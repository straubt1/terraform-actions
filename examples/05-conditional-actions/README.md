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
```

```shell
# Disable notifications — the log_change action will NOT run
terraform apply -invoke=action.local_command.check_env -var environment=dev -var send_notifications=false
```

![demo](../../assets/05-conditional-actions-01.gif)


## Expected Output

**Default apply:**

```
Plan: 1 to add, 0 to change, 0 to destroy. Actions: 2 to invoke.
Action started: action.local_command.check_env (triggered by random_pet.this)
Action action.local_command.check_env (triggered by random_pet.this):

<timestamp>: Checking environment: prod
WARNING: You are deploying to PRODUCTION!


Action complete: action.local_command.check_env (triggered by random_pet.this)
random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]
Action started: action.local_command.log_change (triggered by random_pet.this)
Action action.local_command.log_change (triggered by random_pet.this):

<timestamp>: Change applied to prod environment — logging complete


Action complete: action.local_command.log_change (triggered by random_pet.this)
```

**Disable notifications:**

```
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Action started: action.local_command.check_env (triggered by CLI)
Action action.local_command.check_env (triggered by CLI):

<timestamp>: Checking environment: dev
Deploying to dev environment.


Action complete: action.local_command.check_env (triggered by CLI)
```

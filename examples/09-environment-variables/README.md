# Environment Variables

Demonstrates injecting environment variables into action scripts using the native `environment` map on `local_command` (available in `hashicorp/local` >= 2.8.0). The script reads values from the environment rather than positional arguments.

## What It Demonstrates

- Passing resource attributes and Terraform variables as environment variables via the native `environment` config attribute
- Scripts that read `$PET_NAME`, `$ENVIRONMENT`, `$LOG_LEVEL` from the environment
- Inheriting an env var (`LOG_LEVEL`) from the parent shell — no Terraform variable required, no wrapper needed

## Key Points

- Environment variables are cleaner than positional arguments when scripts need many inputs
- The `environment` map on `local_command`'s `config` block sets variables directly — no inline `export` wrapper required
- Env vars set in the parent shell (e.g. `LOG_LEVEL=debug terraform apply`) flow through Terraform into the action's subprocess automatically and are merged with the explicit `environment` map
- Requires `hashicorp/local` provider version `~> 2.8` (see [PR #493](https://github.com/hashicorp/terraform-provider-local/pull/493))

## Usage

```shell
terraform init

# Apply — creates a random_pet and runs the report action
terraform apply
```

![demo](../../assets/09-environment-variables-01.gif)

```shell
# Override `environment` via -var, and set LOG_LEVEL in the parent shell
LOG_LEVEL=debug terraform apply -replace=random_pet.this -var environment="production"
```

![demo](../../assets/09-environment-variables-02.gif)

## Expected Output

**Apply (default — no LOG_LEVEL set in parent shell):**

```
Plan: 1 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.

random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]
Action started: action.local_command.report (triggered by random_pet.this)
Action action.local_command.report (triggered by random_pet.this):

=== Environment Report ===
Pet Name:    <pet-name>
Environment: dev
Log Level:
===========================

Action complete: action.local_command.report (triggered by random_pet.this)
```

> Note `Log Level:` is empty — the parent shell didn't export `LOG_LEVEL`, so the action's bash subprocess sees no value for `$LOG_LEVEL`.

**With `LOG_LEVEL=debug` and `-var environment="production"`:**

```
Plan: 1 to add, 0 to change, 1 to destroy. Actions: 1 to invoke.

random_pet.this: Destroying... [id=<pet-name>]
random_pet.this: Destruction complete after 0s
random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name-2>]
Action started: action.local_command.report (triggered by random_pet.this)
Action action.local_command.report (triggered by random_pet.this):

=== Environment Report ===
Pet Name:    <pet-name-2>
Environment: production
Log Level:   debug
===========================

Action complete: action.local_command.report (triggered by random_pet.this)
```

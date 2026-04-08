# Environment Variables

Demonstrates injecting environment variables into action scripts using inline `export` statements. The script reads values from the environment rather than positional arguments.

## What It Demonstrates

- Passing resource attributes and Terraform variables as environment variables to action scripts
- Inline `export` wrapper pattern (since `local_command` doesn't yet support a native `env` config)
- Scripts that read `$PET_NAME`, `$ENVIRONMENT`, `$LOG_LEVEL` from the environment
- Inheriting an env var (`LOG_LEVEL`) from the parent shell — no Terraform variable required

## Key Points

- Environment variables are cleaner than positional arguments when scripts need many inputs
- The inline `export` + script call pattern is the current workaround for the lack of a native `env` attribute
- Env vars set in the parent shell (e.g. `LOG_LEVEL=debug terraform apply`) flow through Terraform into the action's subprocess automatically — no Terraform variable needed
- See the root README's [Thoughts on Additional Features](../../README.md#thoughts-on-additional-features) for the proposed `env` syntax

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

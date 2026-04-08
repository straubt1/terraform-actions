# Action Variables

Demonstrates passing Terraform variables to actions, including overriding them from the CLI with `-var` when using `-invoke`. Also shows the `stdin` config option.

## What It Demonstrates

- Terraform variables used inside action `arguments` and inline scripts
- Overriding variables from the CLI when invoking actions: `-invoke ... -var message="from CLI"`
- The `stdin` config option to pass variable values as standard input to the command
- Invoke-only actions (no resource lifecycle triggers)

## Key Points

- Variables defined in `.tf` files work the same way with `-invoke` as they do with `terraform apply`
- Use `-var` to override variables at invocation time — useful for parameterized Day 2 operations
- The `stdin` config option pipes a value to the command's standard input
- Variables can be passed as `arguments` (positional) or via `stdin` (streamed)

## Usage

```shell
terraform init

# Apply/Invoke with default variable values
terraform apply
```

![demo](../../assets/08-action-variables-01.gif)


```shell
# Override variables from the CLI
terraform apply -invoke=action.local_command.greet -var message="hello from CLI"
terraform apply -invoke=action.local_command.greet -var message="custom message" -var log_level="debug"
```

```shell
# Invoke the inline info action
terraform apply -invoke=action.local_command.info
terraform apply -invoke=action.local_command.info -var message="overridden" -var log_level="warn"
```

## Expected Output

**Apply/Invoke with default variable values:**

```
No changes. Your infrastructure matches the configuration.
```

**Override variables from the CLI:**

```
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Action started: action.local_command.greet (triggered by CLI)
Action action.local_command.greet (triggered by CLI):
<timestamp>: [info] Action invoked
Message (from argument): hello from CLI
Stdin (from stdin config): hello from CLI
Action complete: action.local_command.greet (triggered by CLI)

Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Action started: action.local_command.greet (triggered by CLI)
Action action.local_command.greet (triggered by CLI):
<timestamp>: [debug] Action invoked
Message (from argument): custom message
Stdin (from stdin config): custom message
Action complete: action.local_command.greet (triggered by CLI)
```

**Invoke the inline info action:**

```
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Action started: action.local_command.info (triggered by CLI)
Action action.local_command.info (triggered by CLI):
=== Action Variables Demo ===
Message:   default from .tf file
Log Level: info
=============================
Action complete: action.local_command.info (triggered by CLI)

Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Action started: action.local_command.info (triggered by CLI)
Action action.local_command.info (triggered by CLI):
=== Action Variables Demo ===
Message:   overridden
Log Level: warn
=============================
Action complete: action.local_command.info (triggered by CLI)
```

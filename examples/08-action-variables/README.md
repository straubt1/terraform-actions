# Action Variables

Demonstrates passing Terraform variables to actions, including overriding them from the CLI with `-var` when using `-invoke`. Also shows the `stdin` config option.

## What It Demonstrates

- Terraform variables used inside action `arguments` and inline scripts
- Overriding variables from the CLI when invoking actions: `-invoke ... -var message="from CLI"`
- The `stdin` config option to pass variable values as standard input to the command
- Invoke-only actions (no resource lifecycle triggers)

## Usage

```shell
terraform init

# Invoke with default variable values
terraform apply -invoke=action.local_command.greet

# Override variables from the CLI
terraform apply -invoke=action.local_command.greet -var message="hello from CLI"
terraform apply -invoke=action.local_command.greet -var message="custom message" -var log_level="debug"

# Invoke the inline info action
terraform apply -invoke=action.local_command.info
terraform apply -invoke=action.local_command.info -var message="overridden" -var log_level="warn"
```

## Expected Output

With default values:

```
Action started: action.local_command.greet
...
[info] Action invoked
Message (from argument): default from .tf file
Stdin (from stdin config): default from .tf file
...
Action complete: action.local_command.greet
```

With `-var message="hello from CLI"`:

```
Action started: action.local_command.greet
...
[info] Action invoked
Message (from argument): hello from CLI
Stdin (from stdin config): hello from CLI
...
Action complete: action.local_command.greet
```

## Key Points

- Variables defined in `.tf` files work the same way with `-invoke` as they do with `terraform apply`
- Use `-var` to override variables at invocation time — useful for parameterized Day 2 operations
- The `stdin` config option pipes a value to the command's standard input
- Variables can be passed as `arguments` (positional) or via `stdin` (streamed)

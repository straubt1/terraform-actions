# Invoke-Only Actions

Actions that are **not attached to any resource lifecycle**. They exist solely to be invoked on-demand via `terraform apply -invoke`.

## What It Demonstrates

- Actions defined without any `action_trigger` — no resources, no lifecycle events
- Standalone invocation via `terraform apply -invoke=<action address>`
- Practical Day 2 operation patterns (health checks, cache clearing)

## When to Use

The `-invoke` flag is useful for **Day 2 operations** — ad-hoc tasks that need to run against existing infrastructure:

- Cache invalidation
- Certificate rotation
- Health checks
- On-demand report generation
- Manual triggering of notifications

## Usage

```shell
terraform init

# There are no resources — a normal apply does nothing
terraform apply
```

```shell
# Invoke the health check action
terraform apply -invoke=action.local_command.health_check
```

```shell
# Invoke the cache clear action
terraform apply -invoke=action.local_command.cache_clear
```

![demo](../../assets/06-invoke-only-01.gif)

## Expected Output

**No-op apply:**

```
Plan: 1 to add, 0 to change, 0 to destroy.
random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]
```

**Invoke health check:**

```
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Action started: action.local_command.health_check (triggered by CLI)
Action action.local_command.health_check (triggered by CLI):

$(date): Running health check — all systems operational

Action complete: action.local_command.health_check (triggered by CLI)
```

**Invoke cache clear:**

```
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Action started: action.local_command.cache_clear (triggered by CLI)
Action action.local_command.cache_clear (triggered by CLI):

<timestamp>: Clearing cache...
Cache cleared successfully.

Action complete: action.local_command.cache_clear (triggered by CLI)
```

## Key Points

- `-invoke` runs the action in isolation — no resources are planned or applied
- Actions do not need to be attached to a resource lifecycle to be invoked
- The action code can be updated and re-invoked without changing any resource state
- A normal `terraform apply` with no `-invoke` flag will have nothing to do in this example

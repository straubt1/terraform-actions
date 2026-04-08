# Terraform Actions

Terraform Actions are a native way to run commands during a resource's lifecycle — before or after a *create* or *update* — or standalone via the CLI. This repository contains working examples using the `local_command` action type, comparisons with older approaches, and thoughts on where the feature could go.

## Getting Started

### Requirements

- Terraform version that supports the `action` block (1.11+)
- No cloud credentials required — all examples use local-only resources (`terraform_data`, `random_pet`)

```shell
git clone https://github.com/straubt1/terraform-actions.git
cd terraform-actions/examples/01-hello-action
terraform init
terraform apply
```

To force a resource to be recreated (re-triggering actions):

```shell
terraform apply -replace=random_pet.this
```

To invoke an action standalone:

```shell
terraform apply -invoke=action.local_command.hello
```

## Why Actions?

### The Problem

Before Actions, running code around a resource lifecycle required workarounds:

- **`null_resource` / `terraform_data` with `local-exec` provisioners** — requires creating separate resources with `depends_on` and `triggers_replace` to approximate before/after behavior
- **Before triggers are brittle** — the trigger inputs must manually mirror the target resource's inputs; they easily fall out of sync
- **Logic is scattered** — before/after behavior lives in disconnected resources, making it harder to read, maintain, and reason about
- **Replace semantics** — `terraform_data` replaces on change rather than running a discrete action, which can cause unintended side effects

### What Actions Solve

- **Co-located** — action triggers live inside the resource's `lifecycle` block, right next to the resource they affect
- **Event-driven** — tied to actual lifecycle events (`before_create`, `after_update`, etc.), not synthetic trigger values
- **Cleaner plans** — `terraform plan` output shows actions alongside the resource, with a summary like `Actions: 2 to invoke`
- **Standalone invocation** — actions can be invoked independently via `terraform apply -invoke` for Day 2 operations

## Action Syntax Overview

An action has two parts: the **action block** (what to run) and the **action_trigger** (when to run it).

```hcl
# Define the action
action "local_command" "notify" {
  config {
    command   = "bash"
    arguments = ["scripts/notify.sh"]
  }
}

# Attach it to a resource's lifecycle
resource "random_pet" "this" {
  lifecycle {
    action_trigger {
      events  = [before_create, before_update]
      actions = [action.local_command.notify]
    }
  }
}
```

The `local_command` action type runs a command on the machine executing Terraform. The `config` block accepts:

- `command` — the executable to run (e.g., `"bash"`, `"python3"`)
- `arguments` — a list of arguments passed to the command
- `stdin` — optional value piped to the command's standard input

## Available Lifecycle Events

| Event | Description |
|-------|-------------|
| `before_create` | Runs before the resource is created |
| `after_create` | Runs after the resource is created |
| `before_update` | Runs before the resource is updated |
| `after_update` | Runs after the resource is updated |

> **Note:** Destroy hooks (`before_destroy`, `after_destroy`) are not yet supported. See [Thoughts on Additional Features](#thoughts-on-additional-features) below.

## Triggering Actions

Actions fire automatically on resource lifecycle events. To re-trigger actions on an existing resource, use `-replace`:

```shell
terraform apply -replace=random_pet.this
```

Actions can also be invoked standalone — without any resource changes — using `-invoke`:

```shell
terraform apply -invoke=action.local_command.notify
```

## Actions and State

**Actions do not affect Terraform state.** When an action runs — whether triggered by a lifecycle event or invoked standalone — no resources are added, changed, or destroyed in state. The action executes and finishes; state remains untouched.

This is reflected directly in the plan output:

```
# Lifecycle-triggered (resource + action)
Plan: 1 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Apply complete! Resources: 1 added, 0 changed, 0 destroyed. Actions: 1 invoked.

# Standalone -invoke (action only)
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Apply complete! Resources: 0 added, 0 changed, 0 destroyed. Actions: 1 invoked.
```

Actions are pure side-effect operations — notifications, cache flushes, validations, API calls — that run alongside infrastructure but sit outside Terraform's state machine. A resource can exist in state with zero associated actions, and an action can be invoked repeatedly without ever touching state.

## Examples

| Example | Description |
|---------|-------------|
| [01-hello-action](examples/01-hello-action/) | Minimal example — single `after_create` action with inline echo |
| [02-old-way-vs-new-way](examples/02-old-way-vs-new-way/) | Side-by-side comparison of `terraform_data` provisioners vs Actions |
| [03-before-after](examples/03-before-after/) | Before and after lifecycle hooks with external bash scripts |
| [04-multiple-actions](examples/04-multiple-actions/) | Chaining multiple actions on the same lifecycle event |
| [05-conditional-actions](examples/05-conditional-actions/) | Conditional action execution with `condition` and environment-aware behavior |
| [06-invoke-only](examples/06-invoke-only/) | Standalone actions with no resource ties — invoked only via `-invoke` |
| [07-inline-script](examples/07-inline-script/) | Inline bash script in an action block using heredoc syntax |
| [08-action-variables](examples/08-action-variables/) | Passing variables to actions and overriding them with `-var` on `-invoke` |
| [09-environment-variables](examples/09-environment-variables/) | Injecting environment variables into action scripts using inline exports |
| [10a-foreach-resource](examples/10a-foreach-resource/) | `for_each` on a resource that triggers a single shared action |
| [10b-foreach-action](examples/10b-foreach-action/) | `for_each` on both the resource and the action, paired by key |
| [11-api](examples/11-api/) | Calling a real REST API from an action with a bearer token via `curl` |

## Thoughts on Additional Features

Terraform Actions are still evolving. Here are some areas I'd love to see developed further.

> **Note:** These are not committed features — just my wishlist based on user feedback and my own experience building the current implementation.

### Destroy Hooks

Currently, actions only support create and update events. Destroy hooks (`before_destroy`, `after_destroy`) are a highly requested feature that would enable cleanup tasks like deregistering from service discovery, draining connections, or revoking certificates before a resource is removed.

### Module-Level Lifecycle Actions

Today, actions are scoped to individual resources. Module-level lifecycle actions would allow running actions when an entire module is applied or destroyed — useful for orchestrating cross-resource workflows like "run integration tests after all resources in this module are created."

```hcl
module "example" {
  source = "./example-module"

  lifecycle {
    action_trigger {
      events  = [after_create]
      actions = [action.local_command.hello]
    }
  }
}

action "local_command" "hello" {
  config {
    command   = "echo"
    arguments = ["Hello from Terraform Actions!"]
  }
}
```

### Action Dependencies

Today, if a resource requires an action to complete before it can be created (e.g., a setup step that creates a prerequisite directory or config file), the pattern requires an intermediate resource with `depends_on`. A more native approach would allow actions to be expressed as direct dependencies between resources without extra scaffolding.

For example, imagine needing to create a directory before writing a file into it:

```hcl
# Today: requires a terraform_data wrapper just to run the setup action first
resource "terraform_data" "setup" {
  input = "setup"

  lifecycle {
    action_trigger {
      events  = [after_create]
      actions = [action.local_command.create_dir]
    }
  }
}

resource "local_file" "config" {
  filename = "output/config.txt"
  content  = "hello"

  # Must depend on the wrapper resource, not the action itself
  depends_on = [terraform_data.setup]
}

# Ideally, you could express this dependency directly:
# depends_on = [action.local_command.create_dir]
```

### Triggering Resource Context

Today, an action has no information about *what triggered it*. When the action runs, it doesn't know which resource fired it, which lifecycle event ran (`before_create` vs `after_update`), or whether it was invoked by Terraform or directly via `-invoke`. The action block is evaluated statically — it can only reference resources by their fully-qualified address, not by relationship to the call site.

A native `trigger` reference would expose context about the calling `action_trigger` block and the resource that fired it:

```hcl
# Desired syntax (not yet supported)
action "local_command" "report" {
  config {
    command = "bash"
    arguments = ["-c",
      <<-EOF
      echo "Events:    ${trigger.events}"       # e.g. ["after_create","after_update"]
      echo "Actions:   ${trigger.actions}"      # ordered list of actions in this trigger
      echo "Condition: ${trigger.condition}"    # the condition expression result
      echo "Resource:  ${trigger.resource}"     # full resource object that fired
      echo "Pet name:  ${trigger.resource.id}"  # any attribute on the resource
    EOF
    ]
  }
}
```

Available fields:

- `trigger.events` — array of lifecycle events on the firing `action_trigger` block (e.g. `[after_create, after_update]`)
- `trigger.actions` — array of actions defined in the trigger, ordered by execution priority
- `trigger.condition` — the evaluated condition expression on the trigger (true when the action fires)
- `trigger.resource` — the full resource object (all attributes) that owns the lifecycle block

With this, a single action could be reused across many resources and still produce meaningful, resource-aware output — log lines, notifications, audit records — without hard-coding addresses or duplicating the action per instance.

### Native Environment Variable Support

Today, injecting environment variables into an action's command requires an inline shell wrapper with `export` statements (see [09-environment-variables](examples/09-environment-variables/)). A native `env` attribute on the `config` block would simplify this pattern:

```hcl
# Desired syntax (not yet supported)
action "local_command" "with_env" {
  config {
    command   = "bash"
    arguments = ["scripts/report.sh"]
    env = {
      PET_NAME    = random_pet.this.id
      ENVIRONMENT = var.environment
      LOG_LEVEL   = var.log_level
    }
  }
}
```

This would eliminate the need for inline heredoc wrappers and make actions with environment variables cleaner and more readable.

### Additional Action Types

`local_command` is the only action type today. A natural next step would be action types that call cloud APIs directly — removing the need for wrapper scripts and CLI tool installations.

For example, Azure Storage Accounts have a `isHnsEnabled` flag (hierarchical namespace) that cannot be modified through the AzureRM Terraform provider after creation. Today you would need a `local_command` action that shells out to the Azure CLI:

```hcl
action "local_command" "enable_hns" {
  config {
    command   = "az"
    arguments = [
      "storage", "account", "update",
      "--name", azurerm_storage_account.this.name,
      "--resource-group", azurerm_storage_account.this.resource_group_name,
      "--enable-hierarchical-namespace", "true"
    ]
  }
}
```

A dedicated `azurerm_cli` or `http_request` action type could handle this natively — with built-in authentication, retry logic, and proper error handling — instead of requiring the Azure CLI to be installed on the machine running Terraform.

### Terraform CLI List Commands

A `terraform` command to list available actions in a configuration:

```
terraform actions list

action.local_command.backup
action.local_command.validate
action.local_command.report
```

# Old Way vs New Way

This example demonstrates the same goal — running code after a `random_pet` resource is created or updated — using two different approaches.

## Old Way: `terraform_data` + `local-exec` Provisioners

Uses separate `terraform_data` resources with `local-exec` provisioners to run shell commands around the target resource.

- **Before**: a `terraform_data` resource with `triggers_replace` tied to the same inputs as the target resource, combined with `depends_on` to enforce ordering
- **After**: a `terraform_data` resource with `triggers_replace` tied to the target resource's output value

> **Note:** If you are familiar with `null_resource`, the syntax is nearly identical — `terraform_data` is its modern replacement. Both use `provisioner "local-exec"` and `triggers_replace` (or `triggers` for `null_resource`).

**Pros**

- No additional providers required
- Works with most Terraform versions

**Cons**

- Brittle: the `before` trigger must manually mirror every input that could change the target resource and can easily fall out of sync
- Before/after logic is spread across three disconnected resources
- `terraform_data` replaces on change rather than running a discrete action
- Triggering can affect other resource changes, making it difficult to isolate the intent of the plan
- Plan shows 3 resources instead of 1, obscuring the actual intent
- Output is more difficult to parse:
```
terraform_data.after: Creating...
terraform_data.after: Provisioning with 'local-exec'...
terraform_data.after (local-exec): Executing: ["/bin/sh" "-c" "echo \"$(date): AFTER random_pet create/update — pet name: probable-foal\""]
terraform_data.after (local-exec): Tue Mar 17 15:10:52 CDT 2026: AFTER random_pet create/update — pet name: probable-foal
terraform_data.after: Creation complete after 0s [id=a889d099-047d-0ac4-2ed0-98aec50c8571]
```

## New Way: Terraform Actions

Uses `action` blocks with `local_command` action type, attached to the resource's `lifecycle` block via `action_trigger`.

- **After**: declared via `action_trigger` with `events = [after_create, after_update]`

**Pros**

- Logic is co-located with the resource — easier to read, maintain, and reason about
- Triggers are tied directly to resource lifecycle events, not manually synchronized inputs
- Less brittle: no risk of the before trigger falling out of sync with the target resource
- Plan shows 1 resource + 1 action, clearly communicating the intent
- Output is easier to parse:
```
Action started: action.local_command.notify (triggered by random_pet.this)
Action action.local_command.notify (triggered by random_pet.this):

Tue Mar 17 15:12:00 CDT 2026: AFTER — random_pet create/update complete


Action complete: action.local_command.notify (triggered by random_pet.this)
```

**Cons**

- Requires Terraform 1.11+

## Usage

```shell
# Old way
cd old-way
terraform init
terraform apply
```

![demo](../../assets/02-old-way-vs-new-way-01.gif)

```shell
# New way
cd new-way
terraform init
terraform apply
```

![demo](../../assets/02-old-way-vs-new-way-02.gif)

To update old-way standalone (resource changes):

```shell
cd old-way
terraform apply -replace=terraform_data.after
```

![demo](../../assets/02-old-way-vs-new-way-03.gif)

To invoke new-way actions standalone (no resource changes):

```shell
cd new-way
terraform apply -invoke=action.local_command.notify
```

![demo](../../assets/02-old-way-vs-new-way-04.gif)

## Expected Output

**Old way:**

```
Plan: 2 to add, 0 to change, 0 to destroy.

random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]
terraform_data.after: Creating...
terraform_data.after: Provisioning with 'local-exec'...
terraform_data.after (local-exec): Executing: ["/bin/sh" "-c" "echo \"$(date): AFTER random_pet create/update — pet name: <pet-name>\""]
terraform_data.after (local-exec): <timestamp>: AFTER random_pet create/update — pet name: <pet-name>
terraform_data.after: Creation complete after 0s [id=<id>]
```

**New way:**

```
Plan: 1 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.

random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]
Action started: action.local_command.notify (triggered by random_pet.this)
Action action.local_command.notify (triggered by random_pet.this):

<timestamp>: AFTER — random_pet create/update complete

Action complete: action.local_command.notify (triggered by random_pet.this)
```

**Old way — force replace:**

```
Plan: 1 to add, 0 to change, 1 to destroy.

terraform_data.after: Destroying... [id=<id>]
terraform_data.after: Destruction complete after 0s
terraform_data.after: Creating...
terraform_data.after: Provisioning with 'local-exec'...
terraform_data.after (local-exec): Executing: ["/bin/sh" "-c" "echo \"$(date): AFTER random_pet create/update — pet name: <pet-name>\""]
terraform_data.after (local-exec): <timestamp>: AFTER random_pet create/update — pet name: <pet-name>
terraform_data.after: Creation complete after 0s [id=<id>]
```

**New way — invoke standalone:**

```
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.

Action started: action.local_command.notify (triggered by CLI)
Action action.local_command.notify (triggered by CLI):

<timestamp>: AFTER — random_pet create/update complete

Action complete: action.local_command.notify (triggered by CLI)
```

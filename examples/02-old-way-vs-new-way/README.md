# Old Way vs New Way

A side-by-side comparison of running code after a `random_pet` resource is created or updated, using two different approaches.

## What It Demonstrates

- **Old way** ([`old-way/`](old-way/)) — `terraform_data` + `local-exec` provisioners. A separate `terraform_data.after` resource with `triggers_replace` tied to the target resource's output value.
- **New way** ([`new-way/`](new-way/)) — `action` blocks with the `local_command` action type, attached to the resource's `lifecycle` block via `action_trigger` with `events = [after_create, after_update]`.

> **Note:** If you are familiar with `null_resource`, the syntax of the old way is nearly identical — `terraform_data` is its modern replacement. Both use `provisioner "local-exec"` and `triggers_replace` (or `triggers` for `null_resource`).

## Key Points

**Old way — pros**

- No additional providers required
- Works with most Terraform versions

**Old way — cons**

- Brittle: trigger inputs must manually mirror every input that could change the target resource and can easily fall out of sync
- Logic is spread across disconnected resources
- `terraform_data` replaces on change rather than running a discrete action
- Triggering can affect other resource changes, making plan intent hard to read
- Plan shows 2 resources instead of 1, obscuring the actual intent
- Output is harder to parse:
  ```
  terraform_data.after: Provisioning with 'local-exec'...
  terraform_data.after (local-exec): Executing: ["/bin/sh" "-c" "echo \"$(date): AFTER ...\""]
  ```

**New way — pros**

- Logic is co-located with the resource — easier to read, maintain, and reason about
- Triggers are tied directly to lifecycle events, not synchronized inputs
- Less brittle: no risk of trigger drift
- Plan clearly shows `1 resource + 1 action`
- Output is cleaner:
  ```
  Action started: action.local_command.notify (triggered by random_pet.this)
  Action complete: action.local_command.notify (triggered by random_pet.this)
  ```
- Actions can be invoked standalone with `-invoke` (no resource churn)

**New way — cons**

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

To force re-run the old-way provisioner:

```shell
cd old-way
terraform apply -replace=terraform_data.after
```

![demo](../../assets/02-old-way-vs-new-way-03.gif)

To invoke the new-way action standalone (no resource changes):

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

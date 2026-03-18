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
terraform apply -replace=random_pet.this

# New way
cd new-way
terraform init
terraform apply
terraform apply -replace=random_pet.this
```

To invoke new-way actions standalone (no resource changes):

```shell
cd new-way
terraform apply -invoke=action.local_command.notify
```

Compare the plan output between the two approaches — notice how the old way shows 2 resources while the new way shows 1 resource with 1 action.

# Hello Action

The simplest possible Terraform Action — a single `after_create` hook that prints a message after a resource is created.

## What It Demonstrates

- The `action` block with `local_command` type
- The `action_trigger` inside a resource's `lifecycle` block
- The `after_create` event

## Usage

```shell
terraform init
terraform apply
```

To force the resource to be recreated (triggering actions again):

```shell
terraform apply -replace=random_pet.this
```

To invoke the action standalone (no resource changes):

```shell
terraform apply -invoke=action.local_command.hello
```

## Expected Output

During `terraform apply`, after the `random_pet` resource is created, you should see:

```
Action started: action.local_command.hello (triggered by random_pet.this)
Action action.local_command.hello (triggered by random_pet.this):

Hello from Terraform Actions!

Action complete: action.local_command.hello (triggered by random_pet.this)
```

The plan summary will show:

```
Plan: 1 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
```

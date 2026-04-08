# Hello Action

The simplest possible Terraform Action — a single `after_create` hook that prints a message after a resource is created.

## What It Demonstrates

- The `action` block with `local_command` type
- The `action_trigger` inside a resource's `lifecycle` block
- The `after_create` event

## Key Points

- This is the smallest viable Terraform Action — one resource, one trigger, one action
- The `local_command` action type runs commands on the machine executing Terraform
- A single `after_create` trigger fires once per resource creation
- The same action can be re-triggered with `-replace` or invoked standalone with `-invoke`

## Usage

```shell
terraform init
terraform apply
```

![terraform apply](../../assets/01-hello-action-01.gif)

To force the resource to be recreated (triggering actions again):

```shell
terraform apply -replace=random_pet.this
```

![terraform apply -replace](../../assets/01-hello-action-02.gif)

To invoke the action standalone (no resource changes):

```shell
terraform apply -invoke=action.local_command.hello
```

![terraform apply -invoke](../../assets/01-hello-action-03.gif)

## Expected Output

**Default apply:**

```
Plan: 1 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]
Action started: action.local_command.hello (triggered by random_pet.this)
Action action.local_command.hello (triggered by random_pet.this):

Hello from Terraform Actions!

Action complete: action.local_command.hello (triggered by random_pet.this)
```

**Force recreate:**

```
Plan: 1 to add, 0 to change, 1 to destroy. Actions: 1 to invoke.
random_pet.this: Destroying... [id=<pet-name>]
random_pet.this: Destruction complete after 0s
random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]
Action started: action.local_command.hello (triggered by random_pet.this)
Action action.local_command.hello (triggered by random_pet.this):

Hello from Terraform Actions!

Action complete: action.local_command.hello (triggered by random_pet.this)
```

**Invoke standalone:**

```
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Action started: action.local_command.hello (triggered by CLI)
Action action.local_command.hello (triggered by CLI):

Hello from Terraform Actions!

Action complete: action.local_command.hello (triggered by CLI)
```

# For-Each Resource (Single Action)

A `random_pet` resource with `for_each` that triggers a **single, non-`for_each`** action. The same action block is invoked once per resource instance.

## What It Demonstrates

- `for_each` on a resource that has an `action_trigger`
- One action definition shared across many resource instances
- Targeting a specific resource instance with `-replace` and `-invoke`

## Key Points

- The action is defined **once**, but fires once per `random_pet` instance during apply
- Because the action itself has no `for_each`, `-invoke` takes the action address with no key
- To re-trigger for one instance only, use `-replace` with the instance key in quotes
- Actions are **not resource-aware** — they have no built-in context about which resource (or instance) triggered them. With a single action and a `for_each` resource, there is **no workaround**: the action can only reference the full `random_pet.this` map and cannot tell which instance fired it. If you need per-instance data inside the action, use the [10b-foreach-action](../10b-foreach-action/) pattern, where a shared `for_each` key bridges the gap

## Usage

```shell
terraform init

# Apply — creates all pets, runs the greet action once per instance
terraform apply
```

Re-trigger the action for a single resource instance:

```shell
terraform apply -replace='random_pet.this["bravo"]'
```

Invoke the (single) action standalone:

```shell
terraform apply -invoke=action.local_command.greet
```

## Expected Output

**Initial apply:**

```
random_pet.this["alpha"]: Creating...
random_pet.this["bravo"]: Creating...
random_pet.this["charlie"]: Creating...
random_pet.this["alpha"]: Creation complete after 0s [id=<pet-name-a>]
random_pet.this["bravo"]: Creation complete after 0s [id=<pet-name-b>]
random_pet.this["charlie"]: Creation complete after 0s [id=<pet-name-c>]
Action started: action.local_command.greet (triggered by random_pet.this["alpha"])
Action action.local_command.greet (triggered by random_pet.this["alpha"]):

=== Greet Action ===
All random_pet instances:
  alpha => <pet-name-a>
  bravo => <pet-name-b>
  charlie => <pet-name-c>
(Note: a non-for_each action cannot tell which specific instance triggered it)
====================

Action complete: action.local_command.greet (triggered by random_pet.this["alpha"])
... (repeats for "bravo" and "charlie") ...

Apply complete! Resources: 3 added, 0 changed, 0 destroyed. Actions: 3 invoked.
```

**Replace one instance:**

```
random_pet.this["bravo"]: Destroying... [id=<pet-name-b>]
random_pet.this["bravo"]: Creating...
random_pet.this["bravo"]: Creation complete after 0s [id=<pet-name-b2>]
Action started: action.local_command.greet (triggered by random_pet.this["bravo"])
=== Greet Action ===
All random_pet instances:
  alpha => <pet-name-a>
  bravo => <pet-name-b2>
  charlie => <pet-name-c>
(Note: a non-for_each action cannot tell which specific instance triggered it)
====================

Apply complete! Resources: 1 added, 0 changed, 1 destroyed. Actions: 1 invoked.
```

**Invoke standalone:**

```
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.
Action started: action.local_command.greet (triggered by CLI)
=== Greet Action ===
All random_pet instances:
  alpha => <pet-name-a>
  bravo => <pet-name-b2>
  charlie => <pet-name-c>
(Note: a non-for_each action cannot tell which specific instance triggered it)
====================

Apply complete! Resources: 0 added, 0 changed, 0 destroyed. Actions: 1 invoked.
```

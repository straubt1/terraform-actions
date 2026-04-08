# For-Each Resource and Action

A `random_pet` resource with `for_each` paired with an action that **also** uses `for_each`. Each resource instance triggers its matching action instance, and each action instance carries data specific to its key.

## What It Demonstrates

- `for_each` on both the resource and the action
- Pairing instances with `action.local_command.greet[each.key]` inside the trigger
- Targeting a specific action instance with `-invoke`

## Key Points

- The action gets its own `for_each` and accesses `each.key` inside `config`
- Inside `action_trigger`, reference the matching instance with `action.local_command.greet[each.key]`
- `-invoke` requires the full instance address including the key in quotes
- Actions are **not resource-aware** — they have no built-in context about which resource (or instance) triggered them. The workaround is to use the shared `for_each` key to look up the resource by address inside the action: `random_pet.this[each.key].id`
- The resource and the action **must use the same `for_each` keys** (both source from `var.pets` here) so the 1:1 pairing — `random_pet.this["bravo"]` ↔ `action.local_command.greet["bravo"]` — actually resolves
- This pattern is useful when each resource needs an action with **different** inputs (per-instance data, scripts, or arguments) — vs 10a where one shared action runs for all instances

## Usage

```shell
terraform init

# Apply — creates all pets, runs each pet's matching action instance
terraform apply
```

![demo](../../assets/10b-foreach-action-01.gif)

Re-trigger one resource (and its matching action) only:

```shell
terraform apply -replace='random_pet.this["bravo"]'
```

![demo](../../assets/10b-foreach-action-02.gif)

Invoke a specific action instance standalone:

```shell
terraform apply -invoke='action.local_command.greet["bravo"]'
```

![demo](../../assets/10b-foreach-action-03.gif)

## Expected Output

**Initial apply:**

```
Plan: 3 to add, 0 to change, 0 to destroy. Actions: 3 to invoke.

random_pet.this["bravo"]: Creating...
random_pet.this["alpha"]: Creating...
random_pet.this["charlie"]: Creating...
random_pet.this["alpha"]: Creation complete after 0s [id=<pet-name-a>]
random_pet.this["bravo"]: Creation complete after 0s [id=<pet-name-b>]
random_pet.this["charlie"]: Creation complete after 0s [id=<pet-name-c>]
Action started: action.local_command.greet["bravo"] (triggered by random_pet.this["bravo"])
Action started: action.local_command.greet["alpha"] (triggered by random_pet.this["alpha"])
Action started: action.local_command.greet["charlie"] (triggered by random_pet.this["charlie"])
Action action.local_command.greet["bravo"] (triggered by random_pet.this["bravo"]):

=== Greet Action ===
Key:      bravo
Pet name: <pet-name-b>
====================

Action action.local_command.greet["alpha"] (triggered by random_pet.this["alpha"]):

=== Greet Action ===
Key:      alpha
Pet name: <pet-name-a>
====================

Action complete: action.local_command.greet["alpha"] (triggered by random_pet.this["alpha"])
Action action.local_command.greet["charlie"] (triggered by random_pet.this["charlie"]):

=== Greet Action ===
Key:      charlie
Pet name: <pet-name-c>
====================

Action complete: action.local_command.greet["charlie"] (triggered by random_pet.this["charlie"])
Action complete: action.local_command.greet["bravo"] (triggered by random_pet.this["bravo"])
```

**Replace one instance:**

```
Plan: 1 to add, 0 to change, 1 to destroy. Actions: 1 to invoke.

random_pet.this["bravo"]: Destroying... [id=<pet-name-b>]
random_pet.this["bravo"]: Destruction complete after 0s
random_pet.this["bravo"]: Creating...
random_pet.this["bravo"]: Creation complete after 0s [id=<pet-name-b2>]
Action started: action.local_command.greet["bravo"] (triggered by random_pet.this["bravo"])
Action action.local_command.greet["bravo"] (triggered by random_pet.this["bravo"]):

=== Greet Action ===
Key:      bravo
Pet name: <pet-name-b2>
====================

Action complete: action.local_command.greet["bravo"] (triggered by random_pet.this["bravo"])
```

**Invoke a specific instance standalone:**

```
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.

Action started: action.local_command.greet["bravo"] (triggered by CLI)
Action action.local_command.greet["bravo"] (triggered by CLI):

=== Greet Action ===
Key:      bravo
Pet name: <pet-name-b2>
====================

Action complete: action.local_command.greet["bravo"] (triggered by CLI)
```

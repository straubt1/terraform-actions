# API Call

An action that makes a real HTTP request to a public REST endpoint and prints the response. Uses [httpbin.org/bearer](https://httpbin.org/bearer) — a public testing service that accepts any `Authorization: Bearer <token>` header and echoes it back as JSON. No signup, no real secret.

## What It Demonstrates

- Calling an external REST API from inside an action
- Passing a "secret" (bearer token) to the request via a Terraform variable
- Inline bash + `curl` as a lightweight pattern for HTTP-in-an-action

## Key Points

- `httpbin.org/bearer` is a public echo service — the token is **not real** and is safe to commit
- Override the token via CLI: `terraform apply -var api_token="my-token"`
- For production use, the token should come from a secret store (e.g. `data.vault_generic_secret`, env var, or `-var` from a CI secret), not a default
- This example uses `local_command` + `curl` because it is portable and will work for a generic API call. In a real project, prefer a provider-native action type when one exists — it will handle authentication, retries, and errors far better than shelling out to `curl`. Check the documentation of whichever provider owns the API you're calling for supported action types.

## Usage

```shell
terraform init

# Apply — creates a random_pet and calls the API
terraform apply
```

![demo](../../assets/11-api-01.gif)

Re-trigger the API call by replacing the resource:

```shell
terraform apply -replace=random_pet.this
```

![demo](../../assets/11-api-02.gif)

Invoke the API call standalone, optionally overriding the token:

```shell
terraform apply -invoke=action.local_command.call_api
terraform apply -invoke=action.local_command.call_api -var api_token="another-token"
```

![demo](../../assets/11-api-03.gif)

## Expected Output

**Apply:**

```
Plan: 1 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.

random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name>]
Action started: action.local_command.call_api (triggered by random_pet.this)
Action action.local_command.call_api (triggered by random_pet.this):

=== Calling https://httpbin.org/bearer ===
{
  "authenticated": true,
  "token": "demo-token-not-a-real-secret"
}

===========================================

Action complete: action.local_command.call_api (triggered by random_pet.this)
```

**Replace:**

```
Plan: 1 to add, 0 to change, 1 to destroy. Actions: 1 to invoke.

random_pet.this: Destroying... [id=<pet-name>]
random_pet.this: Destruction complete after 0s
random_pet.this: Creating...
random_pet.this: Creation complete after 0s [id=<pet-name-2>]
Action started: action.local_command.call_api (triggered by random_pet.this)
Action action.local_command.call_api (triggered by random_pet.this):

=== Calling https://httpbin.org/bearer ===
{
  "authenticated": true,
  "token": "demo-token-not-a-real-secret"
}

===========================================

Action complete: action.local_command.call_api (triggered by random_pet.this)
```

**Invoke standalone (default token, then override):**

```
Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.

Action started: action.local_command.call_api (triggered by CLI)
Action action.local_command.call_api (triggered by CLI):

=== Calling https://httpbin.org/bearer ===
{
  "authenticated": true,
  "token": "demo-token-not-a-real-secret"
}

===========================================

Action complete: action.local_command.call_api (triggered by CLI)


Plan: 0 to add, 0 to change, 0 to destroy. Actions: 1 to invoke.

Action started: action.local_command.call_api (triggered by CLI)
Action action.local_command.call_api (triggered by CLI):

=== Calling https://httpbin.org/bearer ===
{
  "authenticated": true,
  "token": "another-token"
}

===========================================

Action complete: action.local_command.call_api (triggered by CLI)
```

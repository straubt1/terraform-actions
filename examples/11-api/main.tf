terraform {
  required_version = ">= 1.11"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Fake bearer token. httpbin.org/bearer accepts ANY value here and echoes it
# back — there is no real account or secret. Safe to commit as-is.
variable "api_token" {
  description = "Bearer token sent to httpbin.org/bearer (any value works — endpoint is a public echo service)"
  type        = string
  default     = "demo-token-not-a-real-secret"
}

resource "random_pet" "this" {
  lifecycle {
    action_trigger {
      events  = [after_create, after_update]
      actions = [action.local_command.call_api]
    }
  }
}

# Calls https://httpbin.org/bearer with a Bearer token and pretty-prints the
# JSON response. httpbin.org is a public testing service maintained for exactly
# this kind of demo — no signup, no real auth.
action "local_command" "call_api" {
  config {
    command = "bash"
    arguments = ["-c",
      <<-EOF
      echo "=== Calling https://httpbin.org/bearer ==="
      curl -sS \
        -H "Authorization: Bearer ${var.api_token}" \
        -H "Accept: application/json" \
        https://httpbin.org/bearer
      echo ""
      echo "==========================================="
    EOF
    ]
  }
}

output "pet_name" {
  value = random_pet.this.id
}

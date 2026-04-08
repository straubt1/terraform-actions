terraform {
  required_version = ">= 1.14"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.8"
    }
  }
}

variable "pets" {
  description = "Set of pet keys to create"
  type        = set(string)
  default     = ["alpha", "bravo", "charlie"]
}

# for_each on the resource AND on the action — each resource instance pairs
# with its matching action instance via each.key.
resource "random_pet" "this" {
  for_each = var.pets

  lifecycle {
    action_trigger {
      events  = [after_create, after_update]
      actions = [action.local_command.greet[each.key]]
    }
  }
}

# for_each on the action — one action instance per key, each carrying its own data.
action "local_command" "greet" {
  for_each = var.pets

  config {
    command = "bash"
    arguments = ["-c",
      <<-EOF
      echo "=== Greet Action ==="
      echo "Key:      ${each.key}"
      echo "Pet name: ${random_pet.this[each.key].id}"
      echo "===================="
    EOF
    ]
  }
}

output "pet_names" {
  value = { for k, p in random_pet.this : k => p.id }
}

terraform {
  required_version = ">= 1.11"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

variable "pets" {
  description = "Set of pet keys to create"
  type        = set(string)
  default     = ["alpha", "bravo", "charlie"]
}

# for_each on the resource — each instance triggers the SAME single action.
resource "random_pet" "this" {
  for_each = var.pets

  lifecycle {
    action_trigger {
      events  = [after_create, after_update]
      actions = [action.local_command.greet]
    }
  }
}

# A single action (not for_each). It runs once per triggering resource instance.
action "local_command" "greet" {
  config {
    command = "bash"
    arguments = ["-c",
      <<-EOF
      echo "=== Greet Action ==="
      echo "All random_pet instances:"
      %{ for k, p in random_pet.this ~}
      echo "  ${k} => ${p.id}"
      %{ endfor ~}
      echo "(Note: a non-for_each action cannot tell which specific instance triggered it)"
      echo "===================="
    EOF
    ]
  }
}

output "pet_names" {
  value = { for k, p in random_pet.this : k => p.id }
}

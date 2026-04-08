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

# A normal resource — but NO action_trigger is attached to it.
# The actions below exist independently and are only invoked manually.
resource "random_pet" "this" {}

# These actions are NOT attached to any resource lifecycle.
# They can only be run via: terraform apply -invoke=<action address>
action "local_command" "health_check" {
  config {
    command   = "echo"
    arguments = ["$(date): Running health check — all systems operational"]
  }
}

action "local_command" "cache_clear" {
  config {
    command = "bash"
    arguments = ["-c",
      <<-EOF
      echo "$(date): Clearing cache..."
      echo "Cache cleared successfully."
    EOF
    ]
  }
}

output "pet_name" {
  value = random_pet.this.id
}

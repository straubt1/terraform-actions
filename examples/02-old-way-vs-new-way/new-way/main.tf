terraform {
  required_version = ">= 1.11"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

resource "random_pet" "this" {
  lifecycle {
    action_trigger {
      events  = [after_create, after_update]
      actions = [action.local_command.notify]
    }
  }
}

action "local_command" "notify" {
  config {
    command   = "bash"
    arguments = ["scripts/notify.sh"]
  }
}

output "pet_name" {
  value = random_pet.this.id
}

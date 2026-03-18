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
      events  = [before_create, before_update]
      actions = [action.local_command.before]
    }

    action_trigger {
      events  = [after_create, after_update]
      actions = [action.local_command.after]
    }
  }
}

action "local_command" "before" {
  config {
    command   = "bash"
    arguments = ["${path.module}/scripts/before.sh"]
  }
}

action "local_command" "after" {
  config {
    command   = "bash"
    arguments = ["${path.module}/scripts/after.sh"]
  }
}

output "pet_name" {
  value = random_pet.this.id
}

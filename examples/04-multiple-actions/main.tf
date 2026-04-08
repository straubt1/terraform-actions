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

resource "random_pet" "this" {
  lifecycle {
    # Multiple actions on the same event — they execute in the order listed.
    action_trigger {
      events = [before_create, before_update]
      actions = [
        action.local_command.backup,
        action.local_command.validate
      ]
    }

    action_trigger {
      events  = [after_create, after_update]
      actions = [action.local_command.report]
    }
  }
}

action "local_command" "backup" {
  config {
    command   = "bash"
    arguments = ["${path.module}/scripts/backup.sh"]
  }
}

action "local_command" "validate" {
  config {
    command   = "bash"
    arguments = ["${path.module}/scripts/validate.sh"]
  }
}

action "local_command" "report" {
  config {
    command   = "bash"
    arguments = ["${path.module}/scripts/report.sh"]
  }
}

output "pet_name" {
  value = random_pet.this.id
}

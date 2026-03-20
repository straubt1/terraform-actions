terraform {
  required_version = ">= 1.11"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

variable "environment" {
  description = "Target environment (dev, staging, prod). Passed to action scripts to control behavior."
  type        = string
  default     = "prod"
}

variable "send_notifications" {
  description = "Whether to send notifications after resource changes. Controls the after_create/after_update action."
  type        = bool
  default     = true
}

resource "random_pet" "this" {
  lifecycle {
    action_trigger {
      events  = [before_create, before_update]
      actions = [action.local_command.check_env]
    }

    action_trigger {
      events    = [after_create, after_update]
      actions   = [action.local_command.log_change]
      condition = var.send_notifications
    }
  }
}

action "local_command" "check_env" {
  config {
    command   = "bash"
    arguments = ["${path.module}/scripts/check_env.sh", var.environment]
  }
}

action "local_command" "log_change" {
  config {
    command   = "bash"
    arguments = ["${path.module}/scripts/log_change.sh", var.environment]
  }
}

output "pet_name" {
  value = random_pet.this.id
}

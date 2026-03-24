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
  description = "Target environment name, injected as an env var into the action script"
  type        = string
  default     = "dev"
}

variable "log_level" {
  description = "Log level for the action script"
  type        = string
  default     = "info"
}

resource "random_pet" "this" {
  lifecycle {
    action_trigger {
      events  = [after_create, after_update]
      actions = [action.local_command.report]
    }
  }
}

# Injects environment variables via inline exports, then calls an external script.
# The script reads values from the environment — no positional arguments needed.
action "local_command" "report" {
  config {
    command = "bash"
    arguments = ["-c",
      <<-EOF
      export PET_NAME="${random_pet.this.id}"
      export ENVIRONMENT="${var.environment}"
      export LOG_LEVEL="${var.log_level}"
      ${path.module}/scripts/report.sh
    EOF
    ]
  }
}

output "pet_name" {
  value = random_pet.this.id
}

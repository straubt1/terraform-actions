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

resource "random_pet" "this" {
  lifecycle {
    action_trigger {
      events  = [after_create, after_update]
      actions = [action.local_command.report]
    }
  }
}

# Injects environment variables via inline exports, then calls an external script.
# PET_NAME and ENVIRONMENT come from Terraform; LOG_LEVEL is inherited from the
# parent shell (e.g., `LOG_LEVEL=debug terraform apply`) — no TF variable needed.
action "local_command" "report" {
  config {
    command = "bash"
    arguments = ["-c",
      <<-EOF
      export PET_NAME="${random_pet.this.id}"
      export ENVIRONMENT="${var.environment}"
      ${path.module}/scripts/report.sh
    EOF
    ]
  }
}

output "pet_name" {
  value = random_pet.this.id
}

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

# Injects environment variables natively via the `environment` map (available in
# hashicorp/local >= 2.8.0). PET_NAME and ENVIRONMENT are set by Terraform;
# LOG_LEVEL is inherited from the parent shell (e.g., `LOG_LEVEL=debug terraform apply`)
# — no TF variable and no inline `export` wrapper needed.
action "local_command" "report" {
  config {
    environment = {
      PET_NAME    = random_pet.this.id
      ENVIRONMENT = var.environment
    }
    command = "${path.module}/scripts/report.sh"
  }
}

output "pet_name" {
  value = random_pet.this.id
}

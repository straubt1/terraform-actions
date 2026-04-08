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
    action_trigger {
      events  = [after_create]
      actions = [action.local_command.hello]
    }
  }
}

action "local_command" "hello" {
  config {
    command   = "echo"
    arguments = ["Hello from Terraform Actions!"]
  }
}

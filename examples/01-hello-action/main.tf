terraform {
  required_version = ">= 1.11"
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

terraform {
  required_version = ">= 1.11"
}

variable "message" {
  description = "A message to pass to the action. Override via CLI: -var message=\"from CLI\""
  type        = string
  default     = "default from .tf file"
}

variable "log_level" {
  description = "Log level for the action script. Override via CLI: -var log_level=\"debug\""
  type        = string
  default     = "info"
}

# Invoke with: terraform apply -invoke=action.local_command.greet
# Override variables: terraform apply -invoke=action.local_command.greet -var message="hello from CLI"
action "local_command" "greet" {
  config {
    command   = "bash"
    arguments = ["${path.module}/scripts/greet.sh", var.message, var.log_level]
    stdin     = var.message
  }
}

# Invoke with: terraform apply -invoke=action.local_command.info
action "local_command" "info" {
  config {
    command = "bash"
    arguments = ["-c",
      <<-EOF
      echo "=== Action Variables Demo ==="
      echo "Message:   ${var.message}"
      echo "Log Level: ${var.log_level}"
      echo "============================="
    EOF
    ]
  }
}

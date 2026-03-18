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
      actions = [action.local_command.inline_script]
    }
  }
}

# Inline bash script — no external script file needed.
# Useful for short, self-contained logic that doesn't warrant a separate file.
action "local_command" "inline_script" {
  config {
    command = "bash"
    arguments = ["-c",
      <<-EOF
      echo "=== Inline Action Output ==="
      echo "Timestamp: $(date)"
      echo "Pet name:  ${random_pet.this.id}"
      echo "============================"
    EOF
    ]
  }
}

output "pet_name" {
  value = random_pet.this.id
}

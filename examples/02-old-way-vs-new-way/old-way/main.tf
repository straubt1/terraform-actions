terraform {
  required_version = ">= 1.11"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# The actual resource we care about.
resource "random_pet" "this" {}

# After: runs after the target resource via triggers_replace on its output.
# If you use null_resource instead of terraform_data, the syntax is nearly identical.
resource "terraform_data" "after" {
  triggers_replace = [random_pet.this.id]

  provisioner "local-exec" {
    command = "echo \"$(date): AFTER random_pet create/update — pet name: ${random_pet.this.id}\""
  }
}

output "pet_name" {
  value = random_pet.this.id
}

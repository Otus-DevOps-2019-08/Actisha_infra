terraform {
  # Версия terraform
  required_version = "~> 0.12"
  backend "gcs" {
    bucket = "sweetops-storage-hanna"
    prefix = "terraform/prod"
  }
}


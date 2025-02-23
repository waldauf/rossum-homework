terraform {
  required_version = "~> 1.7"
  required_providers {
    # https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.21.0"
    }
    # https://registry.terraform.io/providers/hashicorp/random/latest
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "postgresql" {
  host     = "localhost"
  port     = 5432
  user     = "root"
  password = "root"
  sslmode  = "disable"
}

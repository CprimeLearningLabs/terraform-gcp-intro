terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 2.3.0"
    }
  }
  backend "gcs" {
    bucket  = "tf-state-000000"
    prefix  = "terraform/state"
  }
  required_version = "> 1.0.0"
}

provider "random" {
}

resource "random_integer" "number" {
  min     = 1
  max     = 100
}

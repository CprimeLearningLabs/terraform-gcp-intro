locals {
  region         = var.region
  project        = "tf-project-XX"
  instance_image = "projects/rocky-linux-cloud/global/images/rocky-linux-8-v20220719"
  size_spec = {
    low = 1,
    medium = 2,
    high = 3
  }
  cluster_size   = try(coalesce(var.node_count, lookup(local.size_spec,var.load_level)), 1)
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    google = {
      source = "hashicorp/google"
      version = "4.31.0"
    }
  }
  backend "gcs" {
    # bucket  = "cprimelearning-tflabs-NN"
    prefix  = "terraform/state"
  }
  required_version = "> 1.0.0"
}

provider "random" {
}

provider "google" {
  project     = local.project
  region      = local.region
}

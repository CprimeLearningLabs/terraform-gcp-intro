locals {
  region         = var.region
  project        = "tf-project-000000"
  instance_image = "projects/rocky-linux-cloud/global/images/rocky-linux-8-v20220719"
  cluster_size   = "2"
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 2.3.0"
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

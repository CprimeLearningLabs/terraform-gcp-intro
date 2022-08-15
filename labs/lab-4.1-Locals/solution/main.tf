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
  # project     = "my-project-id"
  region      = "us-central1"
}

locals {
  region = "us-west-2"
  environment = "Lab"
  instance_ami = "ami-03d5c68bab01f3496"  # ubuntu OS
}

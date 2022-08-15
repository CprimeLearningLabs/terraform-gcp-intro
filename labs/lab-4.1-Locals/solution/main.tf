terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 2.3.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
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

provider "aws" {
  region = local.region
  default_tags {
    tags = {
      Name = "Terraform-Labs"
      Environment = local.environment
    }
  }
}

locals {
  region = "us-west-2"
  environment = "Lab"
  instance_ami = "ami-03d5c68bab01f3496"  # ubuntu OS
}

# provider.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Use appropriate version constraint
    }
  }
  required_version = ">= 1.2.0"  # Specify minimum Terraform version
}

provider "aws" {
  region = "eu-north-1"
}
terraform {
  required_version = ">= 1.5.6" # Task 3
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
terraform {
  required_version = ">= 1.5.6" # Task 3
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      tf_purpose = "training"
    }
  }
}

data "aws_ssm_parameter" "test" {
    name = "ami-id"
}

output "parameter_value" {
    description = "SSM Parameter ami-id"
    value = data.aws_ssm_parameter.test.value
    sensitive = true
}
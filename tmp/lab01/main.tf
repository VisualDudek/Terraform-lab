terraform {
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
      purpose = "training"
    }
  }
  ignore_tags {
    keys = ["Creator"]
  }
}

locals {
  name_prefix = "awsninja12"
  tag_key_name = "Name"
}

variable "name_prefix" {
  type = string
  default = "awsninja12"
  description = "Prefix added for name of every resource"
}

variable "number_of_servers" {
  type = number
  description = "Number of machines to create"
  validation {
    condition = var.number_of_servers > 0 && var.number_of_servers < 3
    error_message = "Number of servers should be between 1-2 inclucive"
  }
}

resource "aws_instance" "app_server" {
  instance_type = "t3.micro"
  tags = {
    "${local.tag_key_name}" = "${local.name_prefix}-web-server-${count.index}"
  }
  ami      = "ami-01dd271720c1ba44f"
  key_name = "shared-for-workshops"
  vpc_security_group_ids = [
    aws_security_group.allow_all.id
  ]
  count = var.number_of_servers
}

resource "aws_security_group" "allow_all" {
  name = "${local.name_prefix}-allow-all"

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

output "server_ip" {
  description = "Public IP of created server"
  value = formatlist(
    "Machine with name %s has public ip: %s",
    aws_instance.app_server[*].tags["${local.tag_key_name}"],
    aws_instance.app_server[*].public_ip,
  )
}
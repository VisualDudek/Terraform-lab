packer {
  required_plugins {
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "prefix" {
  type    = string
  default = "awsninja12"
}

variable "version" {
  type    = string
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "amazon_linux_apache" {
  ami_name      = "${var.prefix}-amazon-linux-apache-${var.version}-${local.timestamp}"
  instance_type = "t3.micro"
  source_ami    = "ami-057b6e529186a8233"
  ssh_username  = "ec2-user"
  tags = {
    purpose = "training"
  }
}
 
source "amazon-ebs" "ubuntu_linux_apache" {
  ami_name      = "${var.prefix}-ubuntu-linux-apache-${var.version}-${local.timestamp}"
  instance_type = "t3.micro"
  source_ami_filter {
    filters = {
      name = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  tags = {
    purpose = "training"
  }
}

build {
  sources = [
    "source.amazon-ebs.amazon_linux_apache",
    "source.amazon-ebs.ubuntu_linux_apache"
  ]

  provisioner "ansible" {
    playbook_file = "./configure-apache.yml"
  }
}
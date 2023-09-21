# --- Task 9 ---
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# --- ---

provider "aws" {
  default_tags { # --- Task 4 ---
    tags = {
      tf_purpose = "training"
    }
  }
}

resource "aws_instance" "amz_linux" {
  instance_type = local.instance_type # Task 6
  # instance_type = "t3.micro"  
  ami = "ami-0b0d560d43e65a601"

  tags = {
    Name = "${var.name_prefix}-${var.distro}-Example" # Task 6
    # Name = "Example"
    CreatedDate = timestamp() # --- Task 8 ---
  }
  vpc_security_group_ids = [
    aws_security_group.allow_all.id
  ] # Task 7

  count = 0 # Task 11
}

# --- Task 12 ---
locals {
 tag_key_name = "Name"
}

# Task 12: var
variable "number_of_servers" {
  type = number
  default = 1
  description = "Number of instances to create"
  validation {
    condition     = var.number_of_servers > 0 && var.number_of_servers < 3
    error_message = "Number of servers should be between 1-2 inclucive"
  }
}

# Task 12: var
variable "image_version" {
  type    = string
}

# Task 12: data "aws_ami"
data "aws_ami" "server_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["${var.name_prefix}-${var.distro}-linux-apache-${var.image_version}-*"]
  }
  owners = [ "self" ]
}

# Task 12: ec2 instnace
resource "aws_instance" "web-server" {
  instance_type = local.instance_type
  ami           = data.aws_ami.server_ami.id
  count = var.number_of_servers

  vpc_security_group_ids = [
    aws_security_group.allow_all.id
  ]

  tags = {
    (local.tag_key_name) = "${var.name_prefix}-${var.distro}-web-server-${count.index}"
    CreatedDate = timestamp()
  }
}

# Task 12: output
output "web_server-server_ip" {
  description = "Public IP of created WEB server"
  value = aws_instance.amz_linux[*].public_ip
}
# --- ---

# --- Task 6 ---
locals {
  instance_type = "t3.micro"
}

variable "name_prefix" {
  type        = string
  default     = "awsninja12"
  description = "Prefix added for name of every resource"
}

variable "distro" {
  type = string
  validation {
    condition     = var.distro == "ubuntu" || var.distro == "amazon"
    error_message = "Provide dostro: ubuntu or amazon, not ${var.distro}"
  }
}

# --- Task 2 ---
output "server_ip" {
  description = "Public IP of created server"
  # value       = aws_instance.amz_linux.public_ip    
  value = aws_instance.amz_linux[*].public_ip # Task 11
}

# --- Task 3 ---
data "external" "ami_id" {
  program = ["bash", "${path.module}/get_latest_amz23_ami_id.sh"]
}

output "ami_id_from_script" {
  description = "Latest AMZ 2023 Linux from script"
  value       = data.external.ami_id.result["ami_id"]
}

# --- Task 5 ---
data "aws_ami" "latest_ubunut" {
  most_recent = true
  name_regex  = "^ubuntu/images/hvm-ssd/ubuntu*"
  # name_regex = "^amazon/ubuntu/images/hvm-ssd/ubuntu*"
  owners = ["099720109477"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  # --- minimort ---
  # filter {
  #   name = "root-device-type"
  #   values = ["ebs"]
  # }
}

# --- Task 7 ---
resource "aws_security_group" "allow_all" {
  name = "${var.name_prefix}-allow-all"

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
# --- ---

output "ami_id_from_data_source" {
  description = "Latest Ubuntu Linux from Data Source"
  value       = data.aws_ami.latest_ubunut.id
}
locals {
  tag_key_name = "Name"
}

data "aws_ami" "server_ami" {
  filter {
    name   = "name"
    values = ["${var.distro}-linux-apache-${var.app_version}-*"]
  }
  owners = ["self"]
}

resource "aws_instance" "app_server" {
  instance_type = "t3.micro"
  tags = {
    # "${local.tag_key_name}" = "${var.name_prefix}-web-server-${count.index}"
    (local.tag_key_name) = "${var.name_prefix}-web-server-${count.index}"
  }
  # ami      = "ami-01dd271720c1ba44f"
  ami      = data.aws_ami.server_ami.id
  key_name = "shared-for-workshops"
  vpc_security_group_ids = [
    aws_security_group.allow_all.id
  ]
  count = var.number_of_servers

  subnet_id = random_shuffle.subnets.result[count.index]
}

resource "random_shuffle" "subnets" {
    input = var.subnet_ids
    result_count = 2
}

resource "aws_security_group" "allow_all" {
  name = "${var.name_prefix}-allow-all"

  vpc_id = var.vpc_id

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
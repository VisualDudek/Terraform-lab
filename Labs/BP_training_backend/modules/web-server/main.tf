locals {
 tag_key_name = "Name"
 instance_type = "t3.micro"
}

data "aws_ami" "server_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["${var.name_prefix}-${var.distro}-linux-apache-${var.image_version}-*"]
  }
  owners = [ "self" ]
}

# --- Task 10 ---
resource "random_shuffle" "subnets" {
 input = var.public_subnet_ids
 result_count = var.number_of_servers
}

# --- ----

resource "aws_instance" "web-server" {
  instance_type = local.instance_type
  ami           = data.aws_ami.server_ami.id
  count = var.number_of_servers
  # subnet_id = var.public_subnet_ids[0] # Task 7
  subnet_id = random_shuffle.subnets.result[count.index] # Task 10

  vpc_security_group_ids = [
    aws_security_group.allow_all.id
  ]

  tags = {
    (local.tag_key_name) = "${var.name_prefix}-${var.distro}-web-server-${count.index}"
    CreatedDate = timestamp()
  }
}

resource "aws_security_group" "allow_all" {
  name = "${var.name_prefix}-${var.sg_prexif_name}-allow-all" # Task 9
  vpc_id = var.vpc_id   # Task 7

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
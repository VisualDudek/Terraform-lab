provider "aws" {
  region = "eu-north-1"
  default_tags {              # --- Task 4 ---
    tags = {
      tf_purpose = "training"
    }
  }
}

resource "aws_instance" "amz_linux" {
  instance_type = "t3.micro"
  ami           = "ami-0b0d560d43e65a601"

  tags = {
    Name = "Example"
  }
}

# --- Task 2 ---
output "server_ip" {
  description = "Public IP of created server"
  value       = aws_instance.amz_linux.public_ip
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
  name_regex = "^ubuntu/images/hvm-ssd/ubuntu*"
  # name_regex = "^amazon/ubuntu/images/hvm-ssd/ubuntu*"
  owners = ["099720109477"]

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  
  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  # --- minimort ---
  # filter {
  #   name = "root-device-type"
  #   values = ["ebs"]
  # }
}

output "ami_id_from_data_source" {
  description = "Latest Ubuntu Linux from Data Source"
  value       = data.aws_ami.latest_ubunut.id
}
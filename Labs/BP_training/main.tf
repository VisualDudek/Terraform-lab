provider "aws" {
  region = "eu-north-1"
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

output "ami_id" {
  description = "Latest AMZ 2023 Linux"
  value       = data.external.ami_id.result["ami_id"]
}
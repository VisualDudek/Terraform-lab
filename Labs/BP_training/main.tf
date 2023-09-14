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

output "server_ip" {
  description = "Public IP of created server"
  value       = aws_instance.amz_linux.public_ip
}
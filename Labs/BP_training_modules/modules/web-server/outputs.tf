output "web_server-server_ip" {
  description = "Public IP of created WEB server"
  value       = aws_instance.web-server[*].public_ip
}

# Task 10
output "shuffle_result" {
  description = "Result of shuffle fn."
  value = random_shuffle.subnets.result
}
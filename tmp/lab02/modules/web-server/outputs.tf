output "server_ip" {
  description = "Public IP of created server"
  value = formatlist(
    "Machine with name %s has public ip: %s",
    aws_instance.app_server[*].tags["${local.tag_key_name}"],
    aws_instance.app_server[*].public_ip,
  )
}
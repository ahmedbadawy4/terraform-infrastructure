output "atlantis_server_public_ip" {
  value = aws_instance.atlantis.public_ip
  description = "The public IP of the Atlantis server"
}

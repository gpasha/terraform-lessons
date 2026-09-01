output "web_server_instance_id" {
  value = aws_instance.my_web_server.id
}

output "web_server_security_group_id" {
  value = aws_security_group.my_web_server_security_group.id
}


output "web_server_security_group_arn" {
  value = aws_security_group.my_web_server_security_group.arn
}

output "web_server_elastic_ip_address" {
  value = aws_eip.my_static_ip.public_ip
}

output "web_server_url" {
  value = "http://${aws_eip.my_static_ip.public_ip}"
  description = "The URL of the web server"
}

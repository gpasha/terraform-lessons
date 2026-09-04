output "web_load_balancer_url" {
  value = "http://${aws_lb.web.dns_name}"
}

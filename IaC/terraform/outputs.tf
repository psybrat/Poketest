output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}

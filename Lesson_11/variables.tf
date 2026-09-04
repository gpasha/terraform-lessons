variable "aws_region" {
  description = "The AWS region to deploy the resources to"
  type    = string # string, number, boolean, list, map, set, object (string - by default)
  default = "ca-central-1"
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type    = map(string)
  default = {
    Owner = "Pavel"
    Project = "Terraform Web Cluster"
  }
}

variable "instance_type" {
  description = "The instance type to deploy the resources to"
  type    = string
  default = "t3.micro"
}

variable "enable_monitoring" {
  description = "Whether to enable monitoring for the resources"
  type    = bool
  default = false
}

variable "allowed_ports" {
  description = "The allowed ports to deploy the resources to"
  type    = list(number)
  default = [22, 80, 443] # 22 - SSH, 80 - HTTP, 443 - HTTPS
}
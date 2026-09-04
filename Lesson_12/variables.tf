variable "owner" {
  description = "The owner of the resources"
  type    = string
  default = "Pavel"
}

variable "environment" {
  description = "The environment of the resources"
  type    = string
  default = "Development"
}

variable "project_name" {
  description = "The name of the project"
  type    = string
  default = "Terraform Static IP"
}
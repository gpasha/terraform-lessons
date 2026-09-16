provider "aws" {
  region = "eu-central-1"
}

# 1. Create a new resource "aws_instance" "web" {}
# 2. terraform init
# 3. terraform import aws_instance.web i-081720d39920a9281
# 4. resource "aws_instance" "web" {
#   instance_type = "t3.micro"
#   ami = "ami-081720d39920a9281"
#     tags = {
#       Name = "web"
#   }
# }

resource "aws_instance" "web" {
  instance_type = "t3.micro"
  ami = "ami-081720d39920a9281"
  tags = {
    Name = "Web Server"
    Company = "Software Inc."
    Owner = "John Doe"
  }
}
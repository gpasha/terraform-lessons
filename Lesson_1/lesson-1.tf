provider "aws" {}

resource "aws_instance" "my_ubuntu_instance" {
  count         = 2
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.micro"

  tags = {
    Name = "my_ubuntu_instance"
    Project = "Terraform Lesson 1"
  }
}

resource "aws_instance" "my_amazon_linux_instance" {
  ami           = "ami-0332d564d76dbd8d6"
  instance_type = "t3.small"

  tags = {
    Name = "my_amazon_linux_instance"
    Project = "Terraform Lesson 1"
  }
}

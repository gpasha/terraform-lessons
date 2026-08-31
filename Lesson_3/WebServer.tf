provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "my_web_server" {
  ami           = "ami-0004a9f3eb59c2f39"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_web_server_security_group.id]
  user_data = templatefile("user-data.sh.tpl", {
    first_name = "John"
    last_name = "Doe"
    other_names = ["Jane", "Jim", "Jill"]
  })

  tags = {
    Name = "my_ubuntu_instance"
    Project = "Terraform Lesson 2"
  }
}

resource "aws_security_group" "my_web_server_security_group" {
  name = "my_web_server_security_group"
  description = "Security group for my web server"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_web_server_security_group"
    Project = "Terraform Lesson 2"
  }
}
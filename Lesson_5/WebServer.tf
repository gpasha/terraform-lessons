provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_web_server.id
}

resource "aws_instance" "my_web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_web_server_security_group.id]
  user_data_replace_on_change = true
  user_data = templatefile("user-data.sh.tpl", {
    first_name  = "John"
    last_name   = "Doe"
    other_names = ["Jane", "Jim", "Jill", "Mark", "Luke"]
  })

  tags = {
    Name = "my_web_server"
  }

  lifecycle {
    # prevent_destroy = true
    # ignore_changes = [user_data]
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_web_server_security_group" {
  name        = "my_web_server_security_group"
  description = "Security group for my web server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "my_web_server_security_group"
    Project = "Terraform Lesson 2"
  }
}

output "web_server_url" {
  value = "http://${aws_instance.my_web_server.public_ip}"
}

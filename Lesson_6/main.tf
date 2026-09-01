provider "aws" {
  region = "eu-central-1"
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_web_server.id
}

resource "aws_instance" "my_web_server" {
  ami           = "ami-0303e2e4a29f041a3"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_web_server_security_group.id]

  tags = {  
    Name = "my_web_server"
  }

  depends_on = [aws_instance.my_application_server]
}

resource "aws_instance" "my_application_server" {
  ami           = "ami-0303e2e4a29f041a3"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_web_server_security_group.id]

  tags = {  
    Name = "my_application_server"
  }

  depends_on = [aws_instance.my_database_server]
}

resource "aws_instance" "my_database_server" {
  ami           = "ami-0303e2e4a29f041a3"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_web_server_security_group.id]

  tags = {  
    Name = "my_database_server"
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

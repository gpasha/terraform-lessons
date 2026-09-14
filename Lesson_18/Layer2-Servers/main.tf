provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-remote-state-lesson-s3-716084143036-eu-central-1-an"
    key = "dev/servers/terraform.tfstate"
    region = "eu-central-1"
  }
}

# Data Sources ================================
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-remote-state-lesson-s3-716084143036-eu-central-1-an"
    key = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "aws_ami" "amazon_linux_default_latest" {
  owners = ["137112412989"]
  most_recent = true
  filter {
    name = "name"
    values = ["al2023-ami-*-kernel-6.18-x86_64"]
  }
}

# Resources ================================
resource "aws_instance" "web_server" {
  ami = data.aws_ami.amazon_linux_default_latest.id
  instance_type = "t3.micro"
  subnet_id = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  security_groups = [aws_security_group.web_server.id]
  user_data = <<EOF
#!/bin/bash
sudo yum update -y && sudo yum install -y httpd
echo "<h1>Deployed via Terraform</h1>" > /var/www/html/index.html
sudo service httpd start
sudo chkconfig httpd on
EOF

  tags = {
    Name = "web_server"
  }
}

resource "aws_security_group" "web_server" {
  name = "web_server_security_group"
  description = "Security group for web server"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr_block]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_server_security_group"
    Owner = "Pavel"
  }
}

# Outputs ================================
output "web_server_security_group_id" {
  value = aws_security_group.web_server.id
}

output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}
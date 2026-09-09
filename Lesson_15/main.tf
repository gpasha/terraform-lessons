provider "aws" {
  region = "eu-central-1"
}

// Conditions
variable "env" {
  default = "prod"
}

variable "prod_name" {
  default = "Pasha"
}

variable "nonprod_name" {
  default = "Vasya"
}

variable "allow_port_list" {
  default = {
    "prod" = [80, 443]
    "dev" = [22, 80, 443, 9092, 8080]
    "staging" = [22, 80, 443]
  }
}
resource "aws_instance" "bastion_server" {
  count = var.env == "dev" ? 1 : 0
  ami = "ami-0d5d2ee1f39ef7a8b"
  instance_type = "t3.micro"
  tags = {
    Name = "my_bastion_server"
  }
}

// Lookups
variable "ec2_sizes" {
  default = {
    "prod" = "t3.large"
    "staging" = "t3.medium"
    "dev" = "t3.micro"
  }
}

resource "aws_instance" "my_server_lookup" {
  ami = "ami-0d5d2ee1f39ef7a8b"
  instance_type = lookup(var.ec2_sizes, var.env)
  tags = {
    Name = "my_server_${lookup(var.ec2_sizes, var.env)}"
  }
}


resource "aws_security_group" "dynamic_security_group" {
  name = "dynamic_security_group"
  description = "Dynamic security group"

  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env)
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dynamic_security_group"
  }
}
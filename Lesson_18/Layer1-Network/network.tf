provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-remote-state-lesson-s3-716084143036-eu-central-1-an"
    key = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

# Variables ================================
variable "env" {
  type = string
  default = "dev"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Resources ================================
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-VPC"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-Internet-Gateway"
  }
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-Public-Subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.env}-Public-Route-Table"
  }
}

resource "aws_route_table_association" "public_routes" {
  count = length(aws_subnet.public_subnet[*].id)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet[count.index].id
}

# Outputs
output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr_block" {
  value =  aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}
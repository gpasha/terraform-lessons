provider "aws" {
  region = "eu-central-1"
}

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

# Public Subnet and Routing
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

# NAT Gateway EIP  with Elastic IP
resource "aws_eip" "nat_eip" {
  count = length(var.private_subnet_cidr)
  domain = "vpc"
  tags = {
    Name = "${var.env}-NAT-Gateway-EIP-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count = length(var.private_subnet_cidr)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id = aws_subnet.public_subnet[count.index].id
  tags = {
    Name = "${var.env}-NAT-Gateway-${count.index + 1}"
  }
}

# Private Subnet and Routing
resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.env}-Private-Subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "private_subnets_route_table" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }
  tags = {
    Name = "${var.env}-Private-Subnets-Route-Table-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private_subnets_routes" {
  count = length(aws_subnet.private_subnets[*].id)
  route_table_id = aws_route_table.private_subnets_route_table[count.index].id
  subnet_id = aws_subnet.private_subnets[count.index].id
}
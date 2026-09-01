provider "aws" {}

data "aws_availability_zones" "working" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpcs" "all" {}

data "aws_vpc" "prod" {

  tags = {
    Name = "Prod"
  }
}

resource "aws_subnet" "prod_subnet_1" {
  vpc_id = data.aws_vpc.prod.id
  cidr_block = cidrsubnet(data.aws_vpc.prod.cidr_block, 1, 0)
  availability_zone = data.aws_availability_zones.working.names[0]
  tags = {
    Name = "Prod Subnet 1 in ${data.aws_availability_zones.working.names[0]}"
    Account = data.aws_caller_identity.current.account_id
    Region = data.aws_region.current.description
  }
}

resource "aws_subnet" "prod_subnet_2" {
  vpc_id = data.aws_vpc.prod.id
  cidr_block = cidrsubnet(data.aws_vpc.prod.cidr_block, 1, 1)
  availability_zone = data.aws_availability_zones.working.names[1]
  tags = {
    Name = "Prod Subnet 2 in ${data.aws_availability_zones.working.names[1]}"
    Account = data.aws_caller_identity.current.account_id
    Region = data.aws_region.current.description
  }
}

output "data_aws_vpc_prod" {
  value = data.aws_vpc.prod.id
}

output "data_aws_vpc_prod_cidr_block" {
  value = data.aws_vpc.prod.cidr_block
}

output "data_aws_availability_zones_working" {
  value = data.aws_availability_zones.working.names
}

output "data_aws_caller_identity_current" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region_current_name" {
  value = data.aws_region.current.name
}

output "data_aws_region_current_description" {
  value = data.aws_region.current.description
}

output "data_aws_vpcs_all" {
  value = data.aws_vpcs.all.ids
}

output "aws_subnet_prod_subnet_1" {
  value = aws_subnet.prod_subnet_1.id
}

output "aws_subnet_prod_subnet_2" {
  value = aws_subnet.prod_subnet_2.id
}

output "aws_subnet_prod_subnet_1_cidr_block" {
  value = aws_subnet.prod_subnet_1.cidr_block
}

output "aws_subnet_prod_subnet_2_cidr_block" {
  value = aws_subnet.prod_subnet_2.cidr_block
}
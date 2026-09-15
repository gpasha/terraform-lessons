provider "aws" {
  region = "eu-central-1"
}

data "terraform_remote_state" "globalvars" {
  backend = "s3"
  config = {
    bucket = "terraform-state-bucket-globalvars-716084143036-eu-central-1-an"
    key    = "globalvars/terraform.tfstate"
    region = "eu-central-1"
  }
}

locals {
  company_name = data.terraform_remote_state.globalvars.outputs.company_name
  owner = data.terraform_remote_state.globalvars.outputs.owner
  tags = data.terraform_remote_state.globalvars.outputs.tags
}

resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Stack2-VPC1"
    Company = local.company_name
    Owner = local.owner
  }
}

resource "aws_vpc" "vpc2" {
  cidr_block = "10.0.0.0/16"
  tags = merge(local.tags, {
    Name = "Stack2-VPC2"
  })
}

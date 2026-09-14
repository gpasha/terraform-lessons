provider "aws" {
  region = "eu-central-1"
}

# module "vpc_default" {
#   source = "../modules/aws_network"
# }

module "vpc_dev" {
  # source = "../modules/aws_network" # Local module
  source = "git@github.com:gpasha/terraform-modules.git//aws_network" # Remote module
  env = "dev"
  vpc_cidr = "10.100.0.0/16"
  public_subnet_cidr = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidr = []
}

module "vpc_prod" {
  # source = "../modules/aws_network" # Local module
  source = "git@github.com:gpasha/terraform-modules.git//aws_network" # Remote module
  env = "prod"
  vpc_cidr = "10.100.0.0/16"
  public_subnet_cidr = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
  private_subnet_cidr = ["10.100.11.0/24", "10.100.12.0/24", "10.100.13.0/24"]
}

module "vpc_test" {
  # source = "../modules/aws_network"
  source = "git@github.com:gpasha/terraform-modules.git//aws_network" # Remote module
  env = "staging"
  vpc_cidr = "10.100.0.0/16"
  public_subnet_cidr = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidr = ["10.100.11.0/24", "10.100.12.0/24"]
}

# Outputs ================================================
# Can use outputs from the outputs of the modules

output "vpc_prod_public_subnet_ids" {
  value = module.vpc_prod.public_subnet_ids
}

output "vpc_dev_public_subnet_ids" {
  value = module.vpc_dev.public_subnet_ids
}

output "vpc_prod_private_subnet_ids" {
  value = module.vpc_prod.private_subnet_ids
}

output "vpc_dev_private_subnet_ids" {
  value = module.vpc_dev.private_subnet_ids
}

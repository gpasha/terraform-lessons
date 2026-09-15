provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-globalvars-716084143036-eu-central-1-an"
    key    = "globalvars/terraform.tfstate"
    region = "eu-central-1"
  }
}

output "company_name" {
  value = "Software Inc."
}

output "owner" {
  value = "John Doe"
}

output "tags" {
  value = {
    Project = "Assemply-1016"
    CostCenter = "R&D"
    Country = "United States"
  }
}

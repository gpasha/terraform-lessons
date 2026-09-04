provider "aws" {
  region = "eu-central-1"
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  full_project_name = "${var.project_name} - ${var.environment}"
  project_owner = "${var.owner} of the project ${var.project_name}"
}

locals {
  City = "Frankfurt"
  Country = "Germany"
  Region = data.aws_region.current.name
  AvailabilityZones = join(", ", data.aws_availability_zones.available.names)
  Location = "In ${local.Region} there are AZ: ${local.AvailabilityZones}"
}

resource "aws_eip" "my_static_ip" {
  tags = {
    Name = "Static IP"
    Owner = var.owner
    # Project = "${var.project_name} - ${var.environment}"
    Project = local.full_project_name
    ProjectOwner = local.project_owner
    City = local.City
    Country = local.Country
    AvailabilityZones = local.AvailabilityZones
    Location = local.Location
  }
}
provider "aws" {
  region = "eu-central-1"
}

# variable "name" {
#   default = "Vasya"
# }

# Error: Failed to query available provider packages: provider "registry.terraform.io/hashicorp/random" not found
# resource "random_string" "rds_password" {
#   length = 12
#   special = true
#   override_special = "!@#$"
#   keepers = {
#     keeper_name = var.name
#     # keeper_smth = var.smth
#   }
# }

resource "aws_ssm_parameter" "rds_password" {
  name = "/prod/mysql"
  description = "Master Password for RDS MySQL"
  type = "SecureString"
  # value = random_string.rds_password.result
  value = "random_string.rds_password.result"
}

data "aws_ssm_parameter" "my_rds_password" {
  name = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}

output "rds_password" {
  value = data.aws_ssm_parameter.my_rds_password.value
  sensitive = true
}

resource "aws_db_instance" "default" {
  identifier = "prod-rds"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  parameter_group_name = "default.mysql5.7"
  allocated_storage = 20
  storage_type = "gp2"
  db_name = "prod"
  username = "admin"
  password = data.aws_ssm_parameter.my_rds_password.value
  skip_final_snapshot = true
  apply_immediately = true
}
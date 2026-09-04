# How to apply variables from the command line
# 1. Using -var flag
# terraform apply -var="aws_region=eu-central-1" -var="instance_type=t3.micro"
# 2. Using environment variables
# export TF_VAR_aws_region=eu-central-1
# export TF_VAR_instance_type=t3.micro
# terraform apply
# 3. Using auto.tfvars file (for case with multiple auto.tfvars files)
# terraform apply -var-file="dev.auto.tfvars"
# terraform apply -var-file="prod.auto.tfvars"
# terraform apply -var-file="*.auto.tfvars"

aws_region = "eu-central-1"
instance_type = "t3.small"
common_tags = {
  Owner = "Pavel"
  Project = "Terraform Web Cluster with Variables"
  Environment = "Production"
}
enable_monitoring = true
allowed_ports = [80, 443]
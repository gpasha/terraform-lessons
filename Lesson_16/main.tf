provider "aws" {
  region = "eu-central-1"
}

variable "aws_users" {
  type = list(string)
  default = ["john", "jane", "doe", "jill", "jack", "jerry"]
}

resource "aws_iam_user" "aws_users" {
  count = length(var.aws_users)
  name = element(var.aws_users, count.index)
}

output "aws_users_output" {
  value = aws_iam_user.aws_users
}

output "aws_users_ids_output" {
  value = aws_iam_user.aws_users[*].id
}

output "aws_users_arns_output" {
  value = [
    for user in aws_iam_user.aws_users :
      "Username: ${user.name} with ARN: ${user.arn}"
  ]
}

output "aws_users_maps_output" {
  value = {
    for user in aws_iam_user.aws_users :
      user.unique_id => user.id
  }
}

output "aws_users_with_condition_length_output" {
  value = [
    for user in aws_iam_user.aws_users :
      user.name if length(user.name) == 4
  ]
}

resource "aws_instance" "my_server" {
  count = 3
  ami = "ami-03b2339b9507d3747"
  instance_type = "t3.micro"
  tags = {
    Name = "my_server_${count.index + 1}"
  }
}

output "aws_server_ids_and_ips_output" {
  value = {
    for server in aws_instance.my_server :
      server.id => server.public_ip
  }
}
provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu_latest" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
  }
}

data "aws_ami" "amazon_linux_latest" {
  owners = ["137112412989"]
  most_recent = true
  filter {
    name = "name"
    values = ["al2023-ami-*-kernel-6.18-x86_64"]
  }
}

data "aws_ami" "windows_latest" {
  owners = ["801119661308"]
  most_recent = true
  filter {
    name = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}

output "aws_ami_ubuntu_latest_id" {
  value = data.aws_ami.ubuntu_latest.id
}

output "aws_ami_ubuntu_latest_name" {
  value = data.aws_ami.ubuntu_latest.name
}

output "aws_ami_amazon_linux_latest_id" {
  value = data.aws_ami.amazon_linux_latest.id
}

output "aws_ami_amazon_linux_latest_name" {
  value = data.aws_ami.amazon_linux_latest.name
}

output "aws_ami_windows_latest_id" {
  value = data.aws_ami.windows_latest.id
}

output "aws_ami_windows_latest_name" {
  value = data.aws_ami.windows_latest.name
}
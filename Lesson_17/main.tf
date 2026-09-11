provider "aws" {
  region = "eu-central-1"
  # access_key  = "xxxxxxx...xxxx"
  # secret_key  = "xxxxxxx...xxxx"

  # assume_role {
  #   role_arn = "arn:aws:iam::716084143036:user/terraform_admin"
  #   session_name = "terraform_admin_session"
  # }
}

provider "aws" {
  region = "ca-central-1"
  alias = "CANADA"
}

provider "aws" {
  region = "us-east-1"
  alias = "USA"
}

# ================================

data "aws_ami" "amazon_linux_default_latest" {
  owners = ["137112412989"]
  most_recent = true
  filter {
    name = "name"
    values = ["al2023-ami-*-kernel-6.18-x86_64"]
  }
}

data "aws_ami" "amazon_linux_canada_latest" {
  provider = aws.CANADA
  owners = ["137112412989"]
  most_recent = true
  filter {
    name = "name"
    values = ["al2023-ami-*-kernel-6.18-x86_64"]
  }
}

data "aws_ami" "amazon_linux_usa_latest" {
  provider = aws.USA
  owners = ["137112412989"]
  most_recent = true
  filter {
    name = "name"
    values = ["al2023-ami-*-kernel-6.18-x86_64"]
  }
}

resource "aws_instance" "my_server_default" {
  # ami = "ami-03b2339b9507d3747"
  ami = data.aws_ami.amazon_linux_default_latest.id
  instance_type = "t3.micro"
  tags = {
    Name = "My Default Server"
  }
}

resource "aws_instance" "my_server_canada" {
  provider = aws.CANADA
  # ami = "ami-06af26bdf96183d41"
  ami = data.aws_ami.amazon_linux_canada_latest.id
  instance_type = "t3.micro"
  tags = {
    Name = "My Canada Server"
  }
}

resource "aws_instance" "my_server_usa" {
  provider = aws.USA
  # ami = "ami-0354c98ae10b02961"
  ami = data.aws_ami.amazon_linux_usa_latest.id
  instance_type = "t3.micro"
  tags = {
    Name = "My USA Server"
  }
}
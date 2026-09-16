provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "node1" {
  instance_type = "t3.micro"
  ami = "ami-081720d39920a9281"
  tags = {
    Name = "Node1"
    Company = "Software Inc."
    Owner = "John Doe"
  }
}

resource "aws_instance" "node2" {
  instance_type = "t3.micro"
  ami = "ami-081720d39920a9281"
  tags = {
    Name = "Node2"
    Company = "Software Inc."
    Owner = "John Doe"
  }
}

resource "aws_instance" "node3" {
  instance_type = "t3.micro"
  ami = "ami-081720d39920a9281"
  tags = {
    Name = "Node3"
    Company = "Software Inc."
    Owner = "John Doe"
  }
  depends_on = [aws_instance.node1, aws_instance.node2]
}

# need to re-create the instance 1
# terraform apply => will see mistake (node3 depends on node1 and node2)
# terraform taint aws_instance.node1
# terraform apply

# OR

# terraform apply -replace aws_instance.node1
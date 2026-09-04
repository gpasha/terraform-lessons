provider "aws" {
  region = "eu-central-1"
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo 'Hello, World in $(date)' >> log.txt"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping -c 3 google.com"
  }
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command = "print('Hello, World')"
    interpreter = ["python", "-c"]
  }
}

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo $PATH $NAME $HOME >> vars.txt"
    environment = {
      PATH = "/bin:/usr/bin:/usr/local/bin"
      NAME = "Pavel"
      HOME = "/home/pavel"
    }
  }
}

resource "aws_instance" "my_server" {
  ami = "ami-0d5d2ee1f39ef7a8b"
  instance_type = "t3.micro"

  provisioner "local-exec" {
    command = "echo 'Hello from AWS instance'"
  }
}

resource "null_resource" "command6" {
  provisioner "local-exec" {
    command = "echo 'Terraform has finished at $(date)' >> log.txt"
  }

  depends_on = [null_resource.command1, null_resource.command2, null_resource.command3, null_resource.command4, aws_instance.my_server]
}

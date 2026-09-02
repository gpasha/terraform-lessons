provider "aws" {
  region = "ca-central-1"
}

data "aws_availability_zones" "available" {}

data "aws_ami" "amazon_linux_latest" {
  owners = ["137112412989"]
  most_recent = true
  filter {
    name = "name"
    values = ["al2023-ami-*-kernel-6.18-x86_64"]
  }
}

resource "aws_security_group" "dynamic_security_group" {
  name = "dynamic_security_group"
  description = "Dynamic security group"

  dynamic "ingress" {
    for_each = [80, 443]
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dynamic_security_group"
  }
}
# Deprecated in favor of aws_launch_template
# resource "aws_launch_configuration" "web" {
#   name = "WebServer-LaunchConfiguration"
#   image_id = data.aws_ami.amazon_linux_latest.id
#   instance_type = "t3.micro"
#   security_groups = [aws_security_group.dynamic_security_group.id]
#   user_data = file("user_data.sh")

#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_launch_template" "web" {
  # name = "WebServer-LaunchTemplate"
  name_prefix   = "WebServer-LaunchTemplate-"
  image_id      = data.aws_ami.amazon_linux_latest.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.dynamic_security_group.id]
  user_data     = filebase64("user_data.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name = "AutoScalingGroup-${aws_launch_template.web.name}"
  # launch_configuration = aws_launch_configuration.web.name # Used for aws_launch_configuration,Deprecated in favor of aws_launch_template
  launch_template {
    id = aws_launch_template.web.id
    version = "$Latest"
  }
  min_size = 2
  max_size = 2
  desired_capacity = 2
  min_elb_capacity = 2
  health_check_type = "ELB"
  vpc_zone_identifier = [aws_default_subnet.default_az_1.id, aws_default_subnet.default_az_2.id]
  load_balancers = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
      Name = "WebServer-in-ASG"
      Owner = "John Doe"
    }
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web" {
  name = "WebServer-LoadBalancer"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups = [aws_security_group.dynamic_security_group.id]
  listener {
    instance_port = 80
    instance_protocol = "HTTP"
    lb_port = 80
    lb_protocol = "HTTP"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
  tags = {
    Name = "WebServer-LoadBalancer"
  }
}

resource "aws_default_subnet" "default_az_1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az_2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

output "web_load_balancer_url" {
  value = "http://${aws_elb.web.dns_name}"
}
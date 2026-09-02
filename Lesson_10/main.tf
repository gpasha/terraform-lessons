provider "aws" {
  region = "ca-central-1"

  default_tags {
    tags = {
      Owner = "Pavel"
      Project = "Terraform Web Cluster"
    }
  }
}

#===============================================

data "aws_availability_zones" "working" {}

data "aws_ami" "amazon_linux_latest" {
  owners = ["137112412989"]
  most_recent = true
  filter {
    name = "name"
    values = ["al2023-ami-*-kernel-6.18-x86_64"]
  }
}

#===============================================

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az_1" {
  availability_zone = data.aws_availability_zones.working.names[0]
}

resource "aws_default_subnet" "default_az_2" {
  availability_zone = data.aws_availability_zones.working.names[1]
}

#===============================================

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
    Name = "Web Security Group"
  }
}

#===============================================

resource "aws_launch_template" "web" {
  name = "WebServer-LaunchTemplate"
  image_id = data.aws_ami.amazon_linux_latest.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.dynamic_security_group.id]
  user_data = filebase64("${path.module}/user_data.sh")
  lifecycle {
    create_before_destroy = true
  }
}

#===============================================

resource "aws_autoscaling_group" "web" {
  name = "AutoScalingGroup-${aws_launch_template.web.latest_version}"
  min_size = 2
  max_size = 2
  min_elb_capacity = 2
  health_check_type = "ELB"
  vpc_zone_identifier = [aws_default_subnet.default_az_1.id, aws_default_subnet.default_az_2.id]
  target_group_arns = [aws_lb_target_group.web.arn]

  launch_template {
    id = aws_launch_template.web.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = {
      Name = "WebServer in ASG-v.${aws_launch_template.web.latest_version}"
      Project = "AutoScalingGroup for WebServer"
    }
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }
}

#===============================================

resource "aws_lb" "web" {
  name = "WebServer-ELB"
  load_balancer_type = "application"
  security_groups = [aws_security_group.dynamic_security_group.id]
  subnets = [aws_default_subnet.default_az_1.id, aws_default_subnet.default_az_2.id]
}

#===============================================

resource "aws_lb_target_group" "web" {
  name = "WebServer-TargetGroup"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_default_vpc.default.id
  deregistration_delay = 10
}

#===============================================

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

#===============================================

output "web_load_balancer_url" {
  value = aws_lb.web.dns_name
}
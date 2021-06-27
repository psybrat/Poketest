provider "aws" {
  region = "eu-central-1"
}

locals {
  AWS_SSH_KEY_NAME = "ssh-key-frankfurt"
  APP_NAME = "Pokemon-api"
  OWNER = "psybrat"
}


terraform {
  backend "s3" {
    bucket = "pokemon-terraform-state"
    key = "dev/terraform.tfstate"
    region = "eu-central-1"
  }
}


data "aws_availability_zones" "available" {}

data "aws_ami" "latest_ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}


resource "aws_launch_configuration" "Ubuntu_poketest" {
  name_prefix = "${local.APP_NAME}-LC-"
  image_id = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_server.id]
  key_name = local.AWS_SSH_KEY_NAME
  user_data = file("CodeDeployInstall.sh")
  iam_instance_profile = aws_iam_instance_profile.code_deploy_instance.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name = "ASG-${aws_launch_configuration.Ubuntu_poketest.name}"
  launch_configuration = aws_launch_configuration.Ubuntu_poketest.name
  max_size = 2
  min_size = 2
  min_elb_capacity = 2
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  health_check_type = "ELB"
  load_balancers = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
      Name = "${local.APP_NAME}-ASG"
      Owner = local.OWNER
      APP = local.APP_NAME
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
  name = "${local.APP_NAME}-ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups = [aws_security_group.web_server.id]

  dynamic "listener" {
    for_each = ["80", "8000"]
    content {
      instance_port = listener.value
      instance_protocol = "http"
      lb_port = listener.value
      lb_protocol = "http"
    }
  }

  health_check {
    healthy_threshold = 2
    interval = 10
    target = "HTTP:80/"
    timeout = 3
    unhealthy_threshold = 2
  }
  tags = {
    Name = "${local.APP_NAME}-ELB"
    APP = local.APP_NAME
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}


resource "aws_security_group" "web_server" {
  name = "${local.APP_NAME} Security group"
  description = "Security group for ${local.APP_NAME}"

  dynamic "ingress" {
    for_each = ["8000", "80", "22"]
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



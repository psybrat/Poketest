provider "aws" {
  region = "eu-central-1"
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

resource "aws_s3_bucket" "state_bucket" {
  bucket = "pokemon-terraform-state"
  acl = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}


resource "aws_launch_configuration" "Ubuntu_poketest" {
  name_prefix = "Poketest-api-server-Highly-Available-LC-"
  image_id = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_server.id]
  key_name = "ssh-key-frankfurt"
  user_data = file("main_test.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name = "ASG-$(aws_launch_configuration.Ubuntu_poketest.name)"
  launch_configuration = aws_launch_configuration.Ubuntu_poketest.name
  max_size = 2
  min_size = 2
  min_elb_capacity = 2
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  health_check_type = "ELB"
  load_balancers = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
      Name = "api-server-in-ASG"
      Owner = "psybrat"
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
  name = "api-server-on-ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups = [aws_security_group.web_server.id]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    interval = 10
    target = "HTTP:80/"
    timeout = 3
    unhealthy_threshold = 2
  }
  tags = {
    Name = "Poketest-api-server-Highly-Available-ELB"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}


resource "aws_security_group" "web_server" {
  name = "Poketest Security group"
  description = "Security group for Poketest app"

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


output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}

provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "latest_ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "Ubuntu_poketest" {
  ami = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "Poketest"
  }
}

resource "aws_security_group" "web_server" {
  name = "Poketest Security group"
  description = "Security group for Poketest app"

  ingress {
    from_port = 8000
    protocol = "tcp"
    to_port = 8000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
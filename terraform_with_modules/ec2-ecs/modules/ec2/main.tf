data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.aminame]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.owner] # Canonical
}

resource "aws_iam_instance_profile" "ecs" {
  name = "bastion_profile"
  role = "${aws_iam_role.ecs_role_custom.name}"
}

resource "aws_key_pair" "ecsec2" {
  key_name   = "${var.keyname}"
  public_key = "${var.pubkey}"
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "instance" {
  ami                    = data.aws_ami.ami.id
  instance_type          = "t2.micro"
  subnet_id              = "${var.public_subnets}"
  vpc_security_group_ids = [aws_default_security_group.default.id]
  key_name = "${aws_key_pair.ecsec2.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}" #Administrative Access

  tags = {
    Name = "ServerInstance"
  }
}


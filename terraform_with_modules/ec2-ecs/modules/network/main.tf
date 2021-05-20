data "aws_availability_zones" "available" {}

#Create VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.cidr
  
  tags = {
    Name = "terraform_vpc"
  }
}

#Creating Public subnets
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.terraform_vpc.id
  count = length(var.public_subnet)
  # cidr_block = var.public_subnet[count.index]
  cidr_block = element(values(var.public_subnet), count.index)
  map_public_ip_on_launch = "true"
  availability_zone = "${element(keys(var.public_subnet), count.index)}"

  tags = {
    Name = "public_subnet_${count.index}"
  }
}

#Creating Private subnets
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.terraform_vpc.id
  count = length(var.private_subnet)
  # cidr_block = var.private_subnet[count.index]
  cidr_block = element(values(var.private_subnet), count.index)
  map_public_ip_on_launch = "false"
  availability_zone = "${element(keys(var.public_subnet), count.index)}"

  tags = {
    Name = "private_subnet-${count.index}"
  }
}

#Creating public Security Group
  resource "aws_security_group" "archeplay_SG_public" {
  name = "archeplay_SG_public"
  description = "Public subnets SG"
  vpc_id = aws_vpc.terraform_vpc.id

  ingress{
    from_port = "443"
    to_port = "443"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "archeplay_SG_public"
  }

}

#Creating private Security Group
resource "aws_security_group" "archeplay_SG_private" {
  name = "archeplay_SG_private"
  description = "Private subnet SG"
  vpc_id = aws_vpc.terraform_vpc.id

  ingress{
    from_port = "443"
    to_port = "443"
    protocol = "tcp"
    security_groups = [aws_security_group.archeplay_SG_public.id]
  }
  ingress{
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    security_groups = [aws_security_group.archeplay_SG_public.id]
  }
  ingress{
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    security_groups = [aws_security_group.archeplay_SG_public.id]
  }
  egress{
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "archeplay_SG_private"
  }

}

#Creating IGW to get access over internet
resource "aws_internet_gateway" "archeplay_igw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "archeplay_igw"
  }
  
}

#Creating route table
resource "aws_route_table" "archeplay_rt" {
  vpc_id = aws_vpc.terraform_vpc.id
}

#Route table association
resource "aws_route_table_association" "vpc_rt_association" {
  count = length(aws_subnet.public_subnet)
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.archeplay_rt.id
}

#Establishing connection through route tables
resource "aws_route" "route" {
  route_table_id = aws_route_table.archeplay_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.archeplay_igw.id
}
provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./modules/network"
  cidr = "10.0.0.0/24"
  public_subnet  = {"us-east-1e" = "10.0.0.0/26", "us-east-1f" = "10.0.0.64/26"}
  private_subnet  = {"us-east-1e" = "10.0.0.128/26", "us-east-1f" = "10.0.0.192/26"}
  bucket = "archeplays3buckettest"

  
}

module "ec2" {
  source = "./modules/ec2"
  aminame = "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
  owner = "099720109477"

  #aminame = "amzn2-ami-hvm*"
  #owner = "amazon"
}

module "ececs2" {
  source = "./modules/ecs"
  aminame = "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
  owner = "099720109477"

  #aminame = "amzn2-ami-hvm*"
  #owner = "amazon"
}



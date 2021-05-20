provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./modules/network"
  cidr = "10.0.0.0/24"
  public_subnet  = {"us-east-1e" = "10.0.0.0/26", "us-east-1f" = "10.0.0.64/26"}
  private_subnet  = {"us-east-1e" = "10.0.0.128/26", "us-east-1f" = "10.0.0.192/26"}
}

module "ec2" {
  source = "./modules/ec2"
  vpcid = module.network.vpcid
  aminame = "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
  owner = "099720109477"
  keyname = "mounika-dev"
  public_subnets = module.network.public_subnet

  #aminame = "amzn2-ami-hvm*"
  #owner = "amazon"
}


module "ecs" {
  source = "./modules/ecs"
}
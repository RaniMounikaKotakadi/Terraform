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

module "image" {
  source = "./modules/image"
  ami = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  instance_type = "t2.micro"
  subnet_id = module.network.public_subnet_id
  security_groups = module.network.public_security_groups

}

module "deploy" {
  source = "./modules/deploy"
  image_id = module.image.wordpress_ami
  key_name = "docker-practice"
  security_groups = module.network.private_security_groups
  subnets = module.network.public_subnet
  instances = module.image.source_instance_id
  vpc_zone_identifier = module.network.private_subnet
}

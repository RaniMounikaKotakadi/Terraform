
module "ec2" {
  source = "./modules/ec2"
  region = "us-east-1"
  # aminame = "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
  # owner = "099720109477"

  aminame = "amzn2-ami-hvm*"
  owner = "amazon"
}

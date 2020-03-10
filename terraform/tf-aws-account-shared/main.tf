locals {
	region_code = "ew2"
	env = "u"
	groupname = "ops"
}

module "key" {
   source           = "../tf-aws-modules/tf-aws-ssh-key"
   keyname          = "jenkins.pem"
   publickey        = var.public_key
}

module "vpc" {
 	source = "../tf-aws-modules/tf-aws-vpc"
	vpc_cidr = "10.0.0.0/16"
	region_code = local.region_code
	env = local.env
	groupname = local.groupname
	az = ["eu-west-2a", "eu-west-2b"]
 }

module "jenkins" {
	source   =  "../tf-aws-modules/tf-aws-compute"
	instance_count   =  1
	availability_zone = "eu-west-2a"
	instance_name =  "jenkins"
	ami = "ami-0389b2a3c4948b1a0"
	instance_type = "t2.micro"
	masterkey = module.key.key_id
	voltype = "gp2"
	size = 20
	group_name = "Ops-group"
	allowed_ports = ["8080","443","80","22"]
	whitelisted_ip = ["0.0.0.0/0"]
	user_data = file("./userdata.txt")
	subnet             = "${element(split(",",module.vpc.public_ids), 0)}"
	vpc_id             = module.vpc.vpc_id
	region_code = local.region_code
	env = local.env
	groupname = local.groupname
}


#EC2 instance template
module "sg" {
    source           = "../tf-aws-security-group"
    instance_name    = var.instance_name
    allowed_ports    = var.allowed_ports
    whitelisted_ip   = var.whitelisted_ip
    region_code      = var.region_code
    env              = var.env
    groupname        = var.groupname
    vpc_id           = var.vpc_id
}

resource "aws_instance" "instance" {
    count                  = var.instance_count
    ami                    = var.ami
    availability_zone      = var.availability_zone
    instance_type          = var.instance_type
    key_name               = var.masterkey
    vpc_security_group_ids = [module.sg.sg_id]
    subnet_id              = var.subnet
    iam_instance_profile   = var.profile
    private_ip             = var.private_ip
    ebs_optimized          = var.ebs_optimized
    user_data              = var.user_data
   root_block_device {
    volume_size           = var.size
    volume_type           = var.voltype
  }
    tags = {
            Name  = "ec2-${var.region_code}-${var.env}-${var.groupname}-group-${var.instance_name}"
            group = var.group_name
         }

}

resource "aws_eip" "eip" {
    instance = element(aws_instance.instance.*.id, count.index)
    vpc      = true
    count    = var.instance_count
    tags = {
        Name = "eip-${var.region_code}-${var.env}-${var.groupname}-group-${var.instance_name}"
    }
}

variable "availability_zone" {

}

variable "instance_name" {

}

variable "ami" {

}

variable "instance_type" {

}

variable "masterkey" {

}

#variable "sgs" { type="list" }
variable "profile" {
  default=""
}

variable "subnet" {
  default=""
}

variable "size" {

}

variable "voltype" {

}

variable "private_ip" {
  default=""
}

variable "instance_count" {

}

variable "ebs_optimized" {
  default=false
}

variable "group_name" {

}

variable "allowed_ports" {
  type= list(string)
}

variable "whitelisted_ip" {
  type= list(string)
}

variable "user_data" {

}
variable "region_code" {

}
variable "env" {

}
variable "groupname" {

}
variable "vpc_id" {}

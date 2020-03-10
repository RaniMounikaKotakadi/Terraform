variable "vpc_cidr" {}
variable "region_code" {}
variable "env" {}
variable "groupname" {}
variable "az" { type = list(string)}
variable "single_nat_gw" {
    type = string
    default = "true"
}
variable "single_subnet" {
    type = string
    default = "true"
}

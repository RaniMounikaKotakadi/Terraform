variable "image_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "security_groups" {
  type = string
}

variable "subnets" {
  type = string
}

variable "instances" {
  type = string
}

# variable "bucket" {
#   type = string
# }
variable "vpc_zone_identifier" {
  type = any
}

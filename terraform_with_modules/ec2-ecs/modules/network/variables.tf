#Variales for network
variable "cidr" {
  type = string
}
variable "public_subnet" {
  type = map
}

variable "private_subnet" {
  type = map
}
#VPC Creation
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "vpc-${var.region_code}-${var.env}-${var.groupname}-group"
    }
}

# Internet-gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "igw-${var.region_code}-${var.env}-${var.groupname}-group"
    }
}

#Public Subnets
resource "aws_subnet" "public_subnet" {
  count                   = var.single_subnet ? 1 : length(var.az)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = var.az[count.index]

  tags = {
      Name = "subnets-${var.region_code}-${var.env}-${var.groupname}-group-public"
    }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
     Name = "rt-${var.region_code}-${var.env}-${var.groupname}-group-public"
  }
}


resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}


# # Private Subnets
# resource "aws_subnet" "private_subnet" {
#   count                   = length(var.az)
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
#   map_public_ip_on_launch = false
#   availability_zone       = var.az[count.index]

#   tags = {
#       Name = "subnets-${var.region_code}-${var.env}-${var.groupname}-group-private"
#   }
# }

# resource "aws_route_table" "private_rt" {
#   count = length(aws_nat_gateway.nat_gw)

#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gw.*.id[count.index]
#   }

#   tags = {
#       Name = "rt-${var.region_code}-${var.env}-${var.groupname}-group-private"
#   }
# }

# resource "aws_route_table_association" "private_rt_assoc" {
#   count          = length(aws_subnet.private_subnet)
#   subnet_id      = aws_subnet.private_subnet.*.id[count.index]
#   route_table_id = var.single_nat_gw ? aws_route_table.private_rt.*.id[0] : aws_route_table.private_rt.*.id[count.index]
# }

# #NAT Gateways
# resource "aws_eip" "nat_gw_ip" {
#     count = var.single_nat_gw ? 1 : length(var.az)
#     vpc = true
#     tags = {
#         Name = "nat_gw_eip-${var.region_code}-${var.env}-${var.groupname}-group"
#     }
# }

# resource "aws_nat_gateway" "nat_gw" {
#     count = var.single_nat_gw ? 1 : length(var.az)
#     allocation_id = aws_eip.nat_gw_ip.*.id[count.index]
#     subnet_id   = aws_subnet.public_subnet.*.id[count.index]
#     tags = {
#         Name = "nat_gw-${var.region_code}-${var.env}-${var.groupname}-group"
#     }
# }
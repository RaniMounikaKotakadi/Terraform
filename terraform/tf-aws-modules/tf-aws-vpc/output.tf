output "vpc_id" {
    value = aws_vpc.main.id
}

output "public_ids" {
 value = "${join(",",aws_subnet.public_subnet.*.id) }"
}

#output "private_ids" {
# value = "${join(",",aws_subnet.private_subnet.*.id) }"
#}

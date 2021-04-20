output "private_subnet" {
  value = element(aws_subnet.private_subnet[*].id, 0)
}

output "public_subnet_id" {
  value = element(aws_subnet.public_subnet[*].id, 0)
}

output "public_subnet" {
  value = element(aws_subnet.public_subnet[*].id, 0)
}

output "public_security_groups" {
  value = aws_security_group.archeplay_SG_public.id
}

output "private_security_groups" {
  value = aws_security_group.archeplay_SG_private.id
}
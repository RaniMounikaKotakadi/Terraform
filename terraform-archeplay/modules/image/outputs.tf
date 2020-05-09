output "wordpress_ami" {
  value = aws_ami_from_instance.wordpress_ami.id
}

output "source_instance_id" {
  value = aws_ami_from_instance.wordpress_ami.source_instance_id
}





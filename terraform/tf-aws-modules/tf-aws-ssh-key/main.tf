resource "aws_key_pair" "key" {
    key_name = var.keyname
    public_key = var.publickey
}

output "key_id" {
       value = aws_key_pair.key.id
}

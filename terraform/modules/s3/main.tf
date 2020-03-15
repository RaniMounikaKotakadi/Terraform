resource "aws_s3_bucket" "s3-test-bucket" {
    count = var.create_bucket ? 1 : 0

    bucket = var.bucket
    acl = var.acl
    versioning {
    enabled = true
  }
    tags = var.tags

}

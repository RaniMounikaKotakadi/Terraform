provider "aws" {
  region = "us-west-2"
}
resource "aws_s3_bucket" "s3-test-bucket" {
  bucket = "mouni-test-s3-terraform-bucket"
  acl = "private"
  versioning {
    enabled = true
  }

  tags = {
    Name = "mouni-test-s3-terraform-bucket"
  }

}
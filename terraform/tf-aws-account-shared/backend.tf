provider "aws" {
  region  = var.region
  version = "~> 2.7"
}

# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM RUNTIME REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # The use of conditional values was introduced in Terraform 0.8.0
  required_version = ">= 0.12.0"

  backend "s3" {
    bucket = "restless-terraform-tr-state"
    key    = "master.tfstate"
    region = "eu-west-2"
  }
}

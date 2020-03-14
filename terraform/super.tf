provider "aws" {
  region = "us-east-1"
}
module "ec2" {
  source = "./modules/ec2"
  # aminame = "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
  # owner = "099720109477"

  aminame = "amzn2-ami-hvm*"
  owner = "amazon"
}

module "lambda" {
  source = "./modules/lambda"

  function_name      = "lambda_function_name"
  filename           = "./modules/lambda/testFunc.zip"
  description        = "This module creates lambda function"
  handler            = "test.testFunc"
  runtime            = "nodejs12.x"
  memory_size        = "128"
  concurrency        = "5"
  lambda_timeout     = "20"
  log_retention      = "1"
  role_arn           = module.lambda_role.role_arn

}
module "lambda_role"{
  source = "./modules/lambda-role"

}

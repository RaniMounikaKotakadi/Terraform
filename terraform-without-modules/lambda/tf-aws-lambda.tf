resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
      {
          "Action": "sts:AssumeRole",
          "Principal": {
              "Service": "lambda.amazonaws.com"
           },
      "Effect": "Allow",
      "Sid": ""
       }
      ]
}
EOF
}

resource "aws_lambda_function" "test-lambda"{
    function_name = "lambda_function_name"
    filename      = "testFunc.zip"
    role = "${aws_iam_role.iam_for_lambda.arn}"
    runtime = "nodejs12.x"
    handler = "test.testFunc"
    
}
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

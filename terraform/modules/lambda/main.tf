resource aws_lambda_function this {
  function_name                  = format("%s", var.function_name)
  filename                       = var.filename
  description                    = var.description
  role                           = var.role_arn
  handler                        = var.handler
  runtime                        = var.runtime
  publish                        = var.publish
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.concurrency
  timeout                        = var.lambda_timeout
  tags                           = var.tags
  source_code_hash               = var.source_code_hash

}

resource aws_lambda_function_event_invoke_config this {
  function_name                = aws_lambda_function.this.function_name
  qualifier                    = aws_lambda_function.this.version
  maximum_event_age_in_seconds = var.event_age_in_seconds
  maximum_retry_attempts       = var.retry_attempts
}

resource aws_lambda_function_event_invoke_config latest {
  function_name                = aws_lambda_function.this.function_name
  qualifier                    = "$LATEST"
  maximum_event_age_in_seconds = var.event_age_in_seconds
  maximum_retry_attempts       = var.retry_attempts
}
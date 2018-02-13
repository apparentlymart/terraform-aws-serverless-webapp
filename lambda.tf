
resource "aws_lambda_function" "main" {
  function_name = "${var.lambda_function_name}"
  description   = "${var.description}"
  tags          = "${var.tags}"

  s3_bucket = "${var.artifact_s3_bucket}"
  s3_key    = "${var.artifact_s3_object_key}"

  runtime     = "${var.lambda_runtime}"
  handler     = "${var.lambda_handler}"
  memory_size = "${var.lambda_memory_size}"
  timeout     = "${var.lambda_timeout}"
  role        = "${var.lambda_execution_role}"
  environment {
    variables = "${var.environment_variables}"
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.main.arn}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.proxy.id}/*/*/*"
}

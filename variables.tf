variable "description" {
  description = "Description used for both the AWS Lambda function and the API Gateway \"REST API\"."
  default     = ""
}

variable "lambda_function_name" {
  description = "The name to use for the created AWS Lambda function."
}

variable "lambda_execution_role" {
  description = "The ARN of an IAM role to use as the execution role for the created AWS Lambda function."
}

variable "lambda_runtime" {
  description = "Keyword representing the AWS Lambda runtime environment to use."
}

variable "lambda_handler" {
  description = "Address of the handler function within the Lambda function's code package. The interpretation of this string depends on the selected runtime."
}

variable "lambda_memory_size" {
  description = "Amount of RAM available to the Lambda function in megabytes."
  default     = 128
}

variable "lambda_timeout" {
  description = "Maximum number of seconds the function is allowed to run for on each invocation."
  default     = 3
}

variable "environment_variables" {
  description = "Map of environment variables to set when executing the Lambda function code."
  type        = map(string)

  # FIXME: We need to set a placeholder value as the default because Terraform
  # won't let us have the environment block with an empty map inside.
  default = {
    "TF_LAMBDA_SERVERLESS__" = "true"
  }
}

variable "api_gateway_name" {
  description = "The name to use for the created Amazon API Gateway \"REST API\" object."
}

variable "artifact_s3_bucket" {
  description = "The name of the S3 bucket that contains AWS Lambda function packages."
}

variable "artifact_s3_object_key" {
  description = "The path of the object within artifact_s3_bucket that will be used as the Lambda function code package."
}

variable "domain_name" {
  description = "A custom domain name to publish the application at."
  default     = ""
}

variable "acm_certificate_arn" {
  description = "ARN of an ACM certificate to use for the custom domain name, if set. This variable is required if domain_name is set."
  default     = ""
}

variable "tags" {
  description = "Map of tags to apply to all objects that support tags."
  default     = {}
  type        = map(string)
}

variable "rest_api_endpoint_type" {
  description = "The type of rest API to create. Valid values are EDGE, REGIONAL or PRIVATE."
  default     = "EDGE"
  type        = string
}

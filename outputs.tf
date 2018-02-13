
output "public_base_url" {
  description = "The primary base URL for the application. If a custom domain name is set then this refers to that domain name, and otherwise it is an alias for test_base_url."
  value       = "${var.domain_name != "" ? "https://${var.domain_name}" : "${aws_api_gateway_deployment.main.invoke_url}"}"
}

output "test_base_url" {
  description = "A base URL that can be used for testing when the configured domain name is not yet pointing to the application."
  value = "${aws_api_gateway_deployment.main.invoke_url}"
}

output "route53_alias_hostname" {
  description = "If a custom domain name is set, a hostname that should be used as the target of a Route53 alias to point a DNS record at the application."
  value = "${element(concat(aws_api_gateway_domain_name.public.*.cloudfront_domain_name, list("")), 0)}"
}

output "route53_alias_host_id" {
  description = "If a custom domain name is set, the host id that contains the hostname given in route53_alias_hostname."
  value = "${element(concat(aws_api_gateway_domain_name.public.*.cloudfront_domain_name, list("")), 0)}"
}

output "lambda_function_arn" {
  description = "The ARN of the AWS Lambda function."
  value       = "${aws_lambda_function.main.arn}"
}

output "source_code_base64sha256" {
  description = "Base64-encoded SHA256 hash of the function source code package."
  value       = "${aws_lambda_function.main.source_code_hash}"
}

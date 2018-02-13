# Terraform AWS Lambda Serverless Application Module

This repository contains an opinionated Terraform module for deploying
"serverless" web applications to AWS Lambda and exposing them publicly using
AWS API Gateway running in its proxy mode.

The main "opinion" of this module is that the AWS Lambda versioning and
API Gateway "stage" concepts are not important when you are using Terraform,
since your Terraform configuration ought to be under version control and so you
can easily recover older versions and apply them. This module expects that
you will upload code packages to S3 and treat them as immutable once uploaded,
and thus the S3 object key will change for each new version to be deployed.

A less significant "opinion" is that if you use a custom domain name then you
will use ACM for its TLS certificate.

## Usage

The following example deploys a NodeJS-based Lambda function and creates a
public-facing API Gateway proxy in front of it.

```hcl
provider "aws" {
  region = "us-east-1"
}

module "app" {
  source = "apparentlymart/serverless-webapp/aws"

  lambda_function_name   = "TerraformServerlessExample"
  lambda_execution_role  = "${aws_iam_role.lambda_exec.arn}"
  lambda_runtime         = "nodejs4.3"
  lambda_handler         = "main.handler"

  api_gateway_name       = "TerraformServerlessExample"

  artifact_s3_bucket     = "terraform-serverless-example"
  artifact_s3_object_key = "v1.0.0/example.zip"
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"

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

output "base_url" {
  value = "${module.app.public_base_url}"
}
```

## Limitations

This module cannot currently configure the following aspects of an AWS Lambda
function:

* Dead Letter Configuration
* VPC integration
* KMS Key ARN
* Tracing Configuration

These are omitted because due to current limitations of Terraform (as of
version 0.11) it is not possible to conditionally set these optional settings
based on whether particular variables are set.

Additionally, if no `environment_variables` argument is set, this module will
create a placeholder variable called `TF_LAMBDA_SERVERLESS__` to work around
a limitation where the environment map may not be explicitly set to empty.
This will be removed in a future version once the underlying limitation has
been addressed, and so applications should not rely on it.


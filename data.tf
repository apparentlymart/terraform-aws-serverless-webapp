data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

data "aws_s3_bucket_object" "artifact" {
  bucket = var.artifact_s3_bucket
  key    = var.artifact_s3_object_key
}
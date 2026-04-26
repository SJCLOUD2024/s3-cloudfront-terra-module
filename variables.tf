# ==============================================================================
# ROOT: variables.tf
# ==============================================================================

variable "aws_region" {
  description = "AWS region for the S3 bucket. CloudFront is always global."
  type        = string
  default     = "eu-west-2" # London
}

variable "project_name" {
  description = "Used to name the CloudFront distribution and OAC."
  type        = string
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name for the static site."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

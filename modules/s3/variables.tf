# ==============================================================================
# MODULE: s3 — variables
# ==============================================================================

variable "bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution. Used to scope the bucket policy to this distribution only."
  type        = string
}

variable "tags" {
  description = "Tags applied to all S3 resources."
  type        = map(string)
  default     = {}
}

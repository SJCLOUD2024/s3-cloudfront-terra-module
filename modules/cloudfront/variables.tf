# ==============================================================================
# MODULE: cloudfront — variables
# ==============================================================================

variable "name" {
  description = "Unique name used to label the CloudFront distribution and OAC."
  type        = string
}

variable "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 origin bucket (from the s3 module output)."
  type        = string
}

variable "tags" {
  description = "Tags applied to all CloudFront resources."
  type        = map(string)
  default     = {}
}

# Uncomment if using a custom domain with ACM:
# variable "acm_certificate_arn" {
#   description = "ACM certificate ARN. Must be created in us-east-1 for CloudFront."
#   type        = string
# }

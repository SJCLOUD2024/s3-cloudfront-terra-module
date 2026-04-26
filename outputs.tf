# ==============================================================================
# ROOT: outputs.tf
# ==============================================================================

output "s3_bucket_name" {
  description = "S3 bucket name."
  value       = module.s3.bucket_id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN."
  value       = module.s3.bucket_arn
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID. Use this when running cache invalidations."
  value       = module.cloudfront.distribution_id
}

output "cloudfront_url" {
  description = "Your public-facing CloudFront URL (UK-only access)."
  value       = "https://${module.cloudfront.domain_name}"
}

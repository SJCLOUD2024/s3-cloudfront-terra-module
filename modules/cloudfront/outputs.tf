# ==============================================================================
# MODULE: cloudfront — outputs
# ==============================================================================

output "distribution_id" {
  description = "CloudFront distribution ID. Use this for cache invalidations after deployments."
  value       = aws_cloudfront_distribution.site.id
}

output "distribution_arn" {
  description = "CloudFront distribution ARN. Passed to the S3 module to scope the bucket policy."
  value       = aws_cloudfront_distribution.site.arn
}

output "domain_name" {
  description = "CloudFront endpoint URL. This is your public-facing site URL."
  value       = aws_cloudfront_distribution.site.domain_name
}

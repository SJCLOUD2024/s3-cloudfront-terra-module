# ==============================================================================
# MODULE: s3 — outputs
# ==============================================================================

output "bucket_id" {
  description = "S3 bucket name / ID."
  value       = aws_s3_bucket.site.id
}

output "bucket_arn" {
  description = "S3 bucket ARN."
  value       = aws_s3_bucket.site.arn
}

output "bucket_regional_domain_name" {
  description = "Regional domain name used as the CloudFront origin."
  value       = aws_s3_bucket.site.bucket_regional_domain_name
}

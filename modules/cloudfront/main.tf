# ==============================================================================
# MODULE: cloudfront
# Creates a CloudFront distribution with:
#   - OAC (Origin Access Control) for private S3 access
#   - UK-only geo restriction (whitelist GB)
#   - HTTPS enforced
#   - SPA-friendly error handling (403/404 → index.html)
# ==============================================================================

# OAC replaces the legacy OAI — uses SigV4 signing, AWS recommended approach
resource "aws_cloudfront_origin_access_control" "site" {
  name                              = "${var.name}-oac"
  description                       = "OAC for ${var.name} static site"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Managed cache policy — "CachingOptimized" is an AWS-managed policy ID
data "aws_cloudfront_cache_policy" "caching_optimised" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "site" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  comment             = "${var.name} static site"

  # --- Origin: private S3 bucket, accessed via OAC ---
  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_id                = "s3-${var.name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.site.id
  }

  # --- Geo restriction: UK only ---
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["GB"]
    }
  }

  # --- Default cache behaviour ---
  default_cache_behavior {
    target_origin_id       = "s3-${var.name}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimised.id
  }

  # --- SPA support: intercept S3 403/404s and serve index.html ---
  # Required for React Router — without this, deep links return an error
  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  # --- TLS certificate ---
  # Uses CloudFront's default cert (*.cloudfront.net).
  # For a custom domain, comment this out and use the acm_certificate_arn block below.
  viewer_certificate {
    cloudfront_default_certificate = true

    # Custom domain example (ACM cert must be in us-east-1):
    # acm_certificate_arn      = var.acm_certificate_arn
    # ssl_support_method       = "sni-only"
    # minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = var.tags
}

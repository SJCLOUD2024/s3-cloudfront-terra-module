# ==============================================================================
# MODULE: s3
# Creates a private, encrypted S3 bucket for static site hosting.
# Access is granted to CloudFront via a bucket policy using OAC.
# ==============================================================================

resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name
  tags   = var.tags

  # Allows terraform destroy to delete the bucket even when it contains
  # objects and versions. Without this, versioned buckets block deletion.
  force_destroy = true
}

# Block all public access — CloudFront accesses via OAC, not public URLs
resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# SSE-S3 encryption (AES-256). Swap sse_algorithm to "aws:kms" if you need KMS.
resource "aws_s3_bucket_server_side_encryption_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Versioning — allows rollback of static assets
resource "aws_s3_bucket_versioning" "site" {
  bucket = aws_s3_bucket.site.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Least privilege bucket policy:
# Only allows s3:GetObject from CloudFront's service principal,
# scoped to this specific CloudFront distribution via AWS:SourceArn.
data "aws_iam_policy_document" "site" {
  statement {
    sid    = "AllowCloudFrontOACReadOnly"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.site.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [var.cloudfront_distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id
  policy = data.aws_iam_policy_document.site.json

  # Public access block must exist before the policy can be applied
  depends_on = [aws_s3_bucket_public_access_block.site]
}

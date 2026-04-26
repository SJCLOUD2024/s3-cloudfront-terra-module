# ==============================================================================
# ROOT: main.tf
# Calls the cloudfront and s3 modules and wires them together.
#
# Dependency order:
#   1. CloudFront module runs first — produces the distribution ARN
#   2. S3 module uses that ARN to scope the bucket policy to this distribution only
#
# This creates a chicken-and-egg situation that Terraform handles correctly
# because CloudFront's ARN is known at plan time (before apply).
# ==============================================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ------------------------------------------------------------------------------
# CloudFront module
# Must be called before S3 so its ARN can be passed into the S3 bucket policy.
# ------------------------------------------------------------------------------
module "cloudfront" {
  source = "./modules/cloudfront"

  name                           = var.project_name
  s3_bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  tags                           = var.tags
}

# ------------------------------------------------------------------------------
# S3 module
# Receives the CloudFront distribution ARN to lock down the bucket policy.
# ------------------------------------------------------------------------------
module "s3" {
  source = "./modules/s3"

  bucket_name                 = var.bucket_name
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
  tags                        = var.tags
}

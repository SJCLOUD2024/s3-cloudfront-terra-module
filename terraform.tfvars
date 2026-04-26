# ==============================================================================
# terraform.tfvars — fill in your values
# ==============================================================================

aws_region   = "eu-west-2"
project_name = "my-project"
bucket_name  = "my-company-static-site-prod" # must be globally unique

tags = {
  Project     = "my-project"
  ManagedBy   = "terraform"
  Environment = "prod"
  Team        = "frontend"
}

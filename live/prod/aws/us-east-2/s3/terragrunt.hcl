# Inherit common settings
include {
  path = find_in_parent_folders()
}

# Use the official AWS S3 bucket community module
terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git//?ref=v3.6.0"
}

locals {
    env = read_terragrunt_config(find_in_parent_folders("env.hcl")).local.env
    region = read_terragrunt_config(find_in_parent_folders("region.hcl")).local.aws_region
}

inputs = {
  bucket                  = "my-${local.env}-s3-bucket-unique-name" # Change to a globally unique bucket name
  versioning              = { enabled = true }
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  # Add more module inputs as needed
}

# Inherit common settings
include {
	path = find_in_parent_folders()
}

terraform {
	source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-policy?ref=v5.0.0"
}

dependency "s3" {
	config_path = "../../s3"
	mock_outputs = {
		bucket_arn = "arn:aws:s3:::mock-bucket"
	}
}

inputs = {
	name        = "s3-access"
	path        = "/"
	description = "IAM policy for S3 bucket access"
	policy      = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Effect = "Allow"
				Action = [
					"s3:GetObject",
					"s3:PutObject",
					"s3:ListBucket"
				]
				Resource = [
					dependency.s3.outputs.bucket_arn,
					"${dependency.s3.outputs.bucket_arn}/*"
				]
			}
		]
	})
}

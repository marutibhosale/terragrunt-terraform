# Inherit common settings
include {
	path = find_in_parent_folders()
}

terraform {
	source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-role?ref=v5.39.0"
}

dependency "policy" {
	config_path = "../policy"
	mock_outputs = {
		policy_arn = "arn:aws:iam::123456789012:policy/mock-s3-access"
	}
}

inputs = {
	name = "ec2-role"
	assume_role_policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Effect = "Allow"
				Principal = {
					Service = "ec2.amazonaws.com"
				}
				Action = "sts:AssumeRole"
			}
		]
	})
	policy_arns = [dependency.policy.outputs.policy_arn]
}

# Inherit common settings
include {
	path = find_in_parent_folders()
}

terraform {
	source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git//?ref=v5.1.0"
}

dependency "vpc" {
	config_path = "../../../vpc"
	mock_outputs = {
		vpc_id = "vpc-12345678"
	}
}

inputs = {
	name        = "ec2-sg"
	description = "Security group for EC2 instances"
	vpc_id      = dependency.vpc.outputs.vpc_id

	ingress_with_cidr_blocks = [
		{
			from_port   = 22
			to_port     = 22
			protocol    = "tcp"
			cidr_blocks = "0.0.0.0/0"
			description = "Allow SSH from anywhere"
		},
		{
			from_port   = 80
			to_port     = 80
			protocol    = "tcp"
			cidr_blocks = "0.0.0.0/0"
			description = "Allow HTTP from anywhere"
		},
		{
			from_port   = 443
			to_port     = 443
			protocol    = "tcp"
			cidr_blocks = "0.0.0.0/0"
			description = "Allow HTTPS from anywhere"
		}
	]

	egress_with_cidr_blocks = [
		{
			from_port   = 0
			to_port     = 0
			protocol    = "-1"
			cidr_blocks = "0.0.0.0/0"
			description = "Allow all outbound traffic"
		}
	]
}

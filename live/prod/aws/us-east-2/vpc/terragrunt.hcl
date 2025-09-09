# Inherit common settings
include {
	path = find_in_parent_folders()
}


terraform {
	source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git//?ref=v5.8.1"
}

locals {
    env = read_terragrunt_config(find_in_parent_folders("env.hcl")).local.env
    region = read_terragrunt_config(find_in_parent_folders("region.hcl")).local.aws_region
}

inputs = {
	name = "${local.env}-vpc"
	cidr = "192.168.0.0/16"

	azs = [
		"${local.region}a",
		"${local.region}b",
		"${local.region}c"
	]

	public_subnets = [
		"192.168.1.0/24",
		"192.168.2.0/24",
		"192.168.3.0/24"
	]
	private_subnets = [
		"192.168.101.0/24",
		"192.168.102.0/24",
		"192.168.103.0/24"
	]

	enable_nat_gateway     = true
	single_nat_gateway    = true
	enable_vpn_gateway    = false
	enable_dns_hostnames  = true
	enable_dns_support    = true
	map_public_ip_on_launch = true

	tags = {
		Environment = local.env
		Terraform   = "true"
	}
}

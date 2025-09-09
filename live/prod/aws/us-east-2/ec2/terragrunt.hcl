# Dependency for public subnet
dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    public_subnets = ["subnet-xxxxxxxx"]
  }
}

# Dependency for security group
dependency "ec2_sg" {
  config_path = "../security-group/ec2"
  mock_outputs = {
    security_group_id = "sg-xxxxxxxx"
  }
}

# Dependency for IAM role
dependency "ec2_role" {
  config_path = "../iam/role"
  mock_outputs = {
    iam_instance_profile = "ec2-instance-profile"
  }
}
# Inherit common settings
include {
  path = find_in_parent_folders()
}
# Terragrunt configuration for EC2 module
terraform {
  source = "../../../../../modules/aws/ec2"
}

locals {
    env = read_terragrunt_config(find_in_parent_folders("env.hcl")).local.env
    region = read_terragrunt_config(find_in_parent_folders("region.hcl")).local.aws_region
}

inputs = {
  key_name             = "${local.env}-ec2-key"
  #ami_id               = data.aws_ami.ubuntu_20_04.id # Or hardcode if not using data source in Terragrunt
  instance_type        = "t3.micro"
  subnet_id            = dependency.vpc.outputs.public_subnets[0]
  security_group_ids   = [dependency.ec2_sg.outputs.security_group_id]
  iam_instance_profile = dependency.ec2_role.outputs.iam_instance_profile
}

variable "subnet_id" {
	description = "The VPC Subnet ID to launch the instance in"
	type        = string
}

variable "security_group_ids" {
	description = "A list of security group IDs to associate with the instance"
	type        = list(string)
}

variable "iam_instance_profile" {
	description = "The IAM instance profile to associate with the instance"
	type        = string
	default     = null
}
variable "key_name" {
	description = "Name for the EC2 key pair"
	type        = string
}



variable "ami_id" {
	description = "AMI ID for the EC2 instance"
	type        = string
}

variable "instance_type" {
	description = "EC2 instance type"
	type        = string
}

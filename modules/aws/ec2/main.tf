data "aws_ami" "ubuntu_20_04" {
	most_recent = true
	owners      = ["099720109477"] # Canonical

	filter {
		name   = "name"
		values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
	}

	filter {
		name   = "virtualization-type"
		values = ["hvm"]
	}
}
resource "tls_private_key" "ec2_key" {
	algorithm = "RSA"
	rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
	key_name   = var.key_name
	public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_secretsmanager_secret" "ec2_key" {
	name = "${var.key_name}-private-key"
}

resource "aws_secretsmanager_secret_version" "ec2_key" {
	secret_id     = aws_secretsmanager_secret.ec2_key.id
	secret_string = tls_private_key.ec2_key.private_key_pem
}

resource "aws_instance" "this" {
	ami                         = data.aws_ami.ubuntu_20_04.id
	instance_type               = var.instance_type
	key_name                    = aws_key_pair.ec2_key.key_name
	subnet_id                   = var.subnet_id
	vpc_security_group_ids      = var.security_group_ids
	iam_instance_profile        = var.iam_instance_profile
	# ...existing code...
}

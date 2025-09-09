output "ec2_key_secret_arn" {
	description = "ARN of the secret storing the EC2 private key"
	value       = aws_secretsmanager_secret.ec2_key.arn
}

variable "project_name" {
  description = "The name of the project to which the secrets belong."
  type        = string

}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod) for which the secrets are being created."
  type        = string

}
variable "public_subnet_ids" {
  description = "A list of public subnet IDs for the EC2 instances."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the EC2 instances."
  type        = list(string)

}

variable "bastion_sg_id" {
  description = "The security group ID for the bastion host."
  type        = string
}

variable "backend_sg_id" {
  description = "The security group ID for the backend EC2 instances."
  type        = string

}

variable "instance_profile_name" {
  description = "The name of the IAM instance profile to be attached to the EC2 instances."
  type        = string
}

variable "secret_name" {
  description = "The name of the secret in AWS Secrets Manager that contains the database credentials."
  type        = string

}

variable "aws_region" {
  description = "The AWS region where the EC2 instances will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The EC2 instance type to be used for the backend instances."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "The name of the SSH key pair to be used for accessing the EC2 instances."
  type        = string
  default     = "crud-pipeline-key"

}
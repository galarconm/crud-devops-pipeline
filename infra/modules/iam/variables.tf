variable "project_name" {
    description = "The name of the project to which the secrets belong."
    type        = string
  
}

variable "environment" {
    description = "The environment (e.g., dev, staging, prod) for which the secrets are being created."
    type        = string
  
}

variable "secret_arn" {
    description = "ARN of the Secrets Manager secret this EC2 is allowed to read"
    type = string
  
}
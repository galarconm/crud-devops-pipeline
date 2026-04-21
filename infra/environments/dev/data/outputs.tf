
output "rds_endpoint" {
    value = module.rds.endpoint
    description = "RDS hostname — saved for reference"
}

output "db_name" {
    value = module.rds.db_name
    description = "The name of the RDS database"
  
}

output "secret_arn" {
    value = module.secrets.secret_arn
    description = "Secret ARN - saved for reference"
  
}

output "secret_name" {
    value = module.secrets.secret_name
    description = "Secret name - used by EC2 user_data to fetch credentials"
  
}

output "instance_profile_name" {
    value = module.iam.instance_profile_name
    description = "IAM instance profile name — attached to the backend EC2"
  
}

output "db_instance_id" {
    description = "RDS instance identifier — used by CloudWatch alarms"
    value       = "crud-pipeline-dev-db"
  
}
variable "db_password" {
  type        = string
  description = "The password for the RDS database instance. Please ensure this is a secure password and do not hardcode it in your Terraform files."
  sensitive   = true

}
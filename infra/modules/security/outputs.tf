output "alb_sg_id" {
  value       = aws_security_group.alb.id
  description = "value of the alb security group id"

}

output "bastion_sg_id" {
  value       = aws_security_group.bastion.id
  description = "value of the bastion security group id"

}

output "backend_sg_id" {
  value       = aws_security_group.backend.id
  description = "value of the backend security group id"

}

output "rds_sg_id" {
  value       = aws_security_group.rds.id
  description = "value of the rds security group id"

}

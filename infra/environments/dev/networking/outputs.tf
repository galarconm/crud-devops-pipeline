output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
  
}

output "public_subnet_ids" {
    description = "The IDs of the public subnets"
    value       = module.vpc.public_subnet_ids
  
}

output "private_subnet_ids" {
    description = "The IDs of the private subnets"
    value       = module.vpc.private_subnet_ids
  
}

output "alb_sg_id" {
  value = module.sg.alb_sg_id
  description = "value of the alb security group id"    
  
}

output "bastion_sg_id" {
  value = module.sg.bastion_sg_id
  description = "value of the bastion security group id"    
  
}

output "backend_sg_id" {
  value = module.sg.backend_sg_id
  description = "value of the backend security group id"    
  
}

output "rds_sg_id" {
  value = module.sg.rds_sg_id
  description = "value of the rds security group id"    
  
}

output "alb_dns_name" {
    description = "ALB DNS name - use this to test the application"
    value = module.alb.alb_dns_name
  
}

output "bastion_public_ip" {

    description = "Bastion Host public IP - SSH entry point"
    value = module.ec2.bastion_public_ip
  
}

output "backend_private_ip" {
    description = "Backend EC2 private IP - only reachable via Bastion Host"
    value = module.ec2.backend_private_ip
  
}
output "bastion_public_ip" {
    value = aws_instance.bastion.public_ip
    description = "The public IP address of the bastion host."
  
}

output "backend_private_ip" {
    value = aws_instance.backend.private_ip
    description = "The private IP address of the backend EC2 instance."
  
}

output "backend_instance_id" {
    value = aws_instance.backend.id
    description = "The ID of the backend EC2 instance."
  
}
variable "project_name"{ 
    type = string 
    description = "The name of the project. This will be used as a prefix for all resources created by this module."
    }

variable "environment"{ 
    type = string 
    description = "The environment in which the ALB will be deployed."
    }

variable "vpc_id"{ 
    type = string 
    description = "The ID of the VPC in which the ALB will be deployed."
    }

variable "public_subnet_ids"{ 
    type = list(string) 
    description = "The IDs of the public subnets in which the ALB will be deployed."
    }

variable "alb_sg_id"{ 
    type = string 
    description = "The ID of the security group for the ALB."
    }
    
variable "backend_instance_id"{ 
    type = string 
    description = "The ID of the backend EC2 instance."
    }
 
terraform {
  required_version = " >= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project     = "crud-pipeline"
      Environment = "dev"
      ManagedBy   = "Terraform"
    }

  }
}

locals {
  name        = "crud-devops-pipeline"
  environment = "dev"
}

module "vpc" {
  source = "../../../modules/vpc"

  project_name         = local.name
  environment          = local.environment
  vpc_cidr_block       = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "sg" {
  source = "../../../modules/security"

  project_name = local.name
  environment  = local.environment
  vpc_id       = module.vpc.vpc_id
  your_ip      = var.your_ip #"212.104.181.149" # Replace with your actual IP address

}

terraform {
  backend "s3" {
    bucket         = "crud-devops-pipeline-bucket"
    key            = "dev/networking/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "crud-devops-pipeline-locks"
    encrypt        = true
  }
}
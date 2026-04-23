terraform {
  required_version = ">= 1.0.0, < 2.0.0"

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

#terraform remote state
data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = "crud-devops-pipeline-bucket"
    key    = "dev/networking/terraform.tfstate"
    region = "us-east-1"
  }

}

module "rds" {
  source = "../../../modules/rds"

  project_name      = "crud-devops-pipeline"
  environment       = "dev"
  subnets_ids       = data.terraform_remote_state.networking.outputs.private_subnet_ids
  security_group_id = data.terraform_remote_state.networking.outputs.rds_sg_id
  instance_class    = "db.t3.small"
  allocated_storage = 20
  db_name           = "cruddb"
  db_username       = "crudadmin"
  db_password       = var.db_password


}

module "secrets" {
  source = "../../../modules/secrets"

  project_name = "crud-devops-pipeline"
  environment  = "dev"
  db_username  = "crudadmin"
  db_password  = var.db_password
  db_host      = module.rds.endpoint
  db_name      = module.rds.db_name
}

module "iam" {
  source = "../../../modules/iam"

  project_name = "crud-devops-pipeline"
  environment  = "dev"
  secret_arn   = module.secrets.secret_arn

}

terraform {
  backend "s3" {
    bucket         = "crud-devops-pipeline-bucket"
    key            = "dev/data/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "crud-devops-pipeline-locks"
    encrypt        = true

  }
}



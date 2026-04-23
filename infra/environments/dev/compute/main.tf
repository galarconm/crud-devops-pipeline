terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws",
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

terraform {
  backend "s3" {
    bucket         = "crud-devops-pipeline-bucket"
    key            = "dev/compute/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "crud-devops-pipeline-locks"
    encrypt        = true

  }
}

data "terraform_remote_state" "data" {
  backend = "s3"
  config = {
    bucket = "crud-devops-pipeline-bucket"
    key    = "dev/data/terraform.tfstate"
    region = "us-east-1"
  }

}

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "crud-devops-pipeline-bucket"
    key    = "dev/networking/terraform.tfstate"
    region = "us-east-1"

  }

}

module "ec2" {
  source = "../../../modules/ec2"

  project_name          = "crud-devops-pipeline"
  environment           = "dev"
  public_subnet_ids     = data.terraform_remote_state.networking.outputs.public_subnet_ids
  private_subnet_ids    = data.terraform_remote_state.networking.outputs.private_subnet_ids
  bastion_sg_id         = data.terraform_remote_state.networking.outputs.bastion_sg_id
  backend_sg_id         = data.terraform_remote_state.networking.outputs.backend_sg_id
  instance_profile_name = data.terraform_remote_state.data.outputs.instance_profile_name
  secret_name           = data.terraform_remote_state.data.outputs.secret_name

}

module "alb" {
  source = "../../../modules/alb"

  project_name        = "crud-devops-pipeline"
  environment         = "dev"
  vpc_id              = data.terraform_remote_state.networking.outputs.vpc_id
  public_subnet_ids   = data.terraform_remote_state.networking.outputs.public_subnet_ids
  alb_sg_id           = data.terraform_remote_state.networking.outputs.alb_sg_id
  backend_instance_id = module.ec2.backend_instance_id

}

module "monitoring" {
  source = "../../../modules/monitoring"

  project_name        = "crud-devops-pipeline"
  environment         = "dev"
  db_instance_id      = data.terraform_remote_state.data.outputs.db_instance_id
  backend_instance_id = module.ec2.backend_instance_id
  alb_arn_suffix      = module.alb.alb_arn_suffix
  alert_email         = var.alert_email

}


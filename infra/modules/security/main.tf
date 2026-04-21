locals {
  name = "${var.project_name}-${var.environment}"

}

resource "aws_security_group" "alb" {
  name        = "${local.name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"

  }

}

resource "aws_security_group" "bastion" {
    name        = "${local.name}-bastion-sg"
    description = "Security group for Bastion Host"
    vpc_id = var.vpc_id

    ingress {
        description = "Allow SSH traffic"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.your_ip}/32"]

    }

    egress {
        description = "Allow all outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "${local.name}-bastion-sg"
    }

  
}


resource "aws_security_group" "backend" {
    name        = "${local.name}-backend-sg"
    description = "Security group for Backend Instances"
    vpc_id = var.vpc_id

    ingress {
        description = "Allow traffic from ALB"
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        security_groups = [aws_security_group.alb.id]

    }

    ingress {
        description = "Allow SSH traffic from Bastion"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.bastion.id]

    }

    egress {
        description = "Allow all outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }

    tags = {
      Name = "${local.name}-backend-sg"
    }
  
}

resource "aws_security_group" "rds" {
    name        = "${local.name}-rds-sg"
    description = "Security group for RDS Instances"
    vpc_id = var.vpc_id

    ingress {
        description = "Allow traffic from Backend Instances"
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        security_groups = [aws_security_group.backend.id]

    }

    # egress {
    #     description = "Allow all outbound traffic"
    #     from_port = 0
    #     to_port = 0
    #     protocol = "-1"
    #     cidr_blocks = ["0.0.0.0/0"]
    # }

    tags = {
      Name = "${local.name}-rds-sg"
    }

}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

}

locals {
  name = "${var.project_name}-${var.environment}"
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.bastion_sg_id]
  key_name               = var.key_name
  tags = {
    Name = "${local.name}-bastion"
  }

}

resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.backend_sg_id]
  key_name               = var.key_name
  iam_instance_profile   = var.instance_profile_name
  user_data = base64encode(<<-USERDATA
        #!/bin/bash
        apt-get update -y
        curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
        apt-get install -y nodejs awscli git
        npm install -g pm2
        
        SECRET=$(aws secretsmanager get-secret-value \
         --secret-id ${var.secret_name} \
         --region ${var.aws_region} \
         --query SecretString \
         --output text)

        DB_HOST=$(echo $SECRET | python3 -c "import sys, json; print(json.load(sys.stdin)['host'])")
        DB_USER=$(echo $SECRET | python3 -c "import sys, json; print(json.load(sys.stdin)['username'])")
        DB_PASS=$(echo $SECRET | python3 -c "import sys, json; print(json.load(sys.stdin)['password'])")
        DB_NAME=$(echo $SECRET | python3 -c "import sys, json; print(json.load(sys.stdin)['dbname'])")

        cd /home/ubuntu
        git clone https://github.com/galarconm/crud-devops-pipeline.git app
        cd app/apps/backend && npm ci
        DATABASE_URL=postgres://$DB_USER:$DB_PASS@$DB_HOST:5432/$DB_NAME \
            pm2 start index.js --name crud-backend
        pm2 startup && pm2 save
    USERDATA          
  )

  tags = {
    Name = "${local.name}-backend"
  }

}
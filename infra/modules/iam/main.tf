locals {
  name = "${var.project_name}-${var.environment}"
}

resource "aws_iam_role" "backend" {
    name = "${local.name}-backend-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
    })
  
}

resource "aws_iam_role_policy" "secrets" {
    name = "${local.name}-secrets-policy"
    role = aws_iam_role.backend.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
            Resource = var.secret_arn
    }]
    })
  
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
    role       = aws_iam_role.backend.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  
}

resource "aws_iam_instance_profile" "backend" {
    name = "${local.name}-backend-profile"
    role = aws_iam_role.backend.name
  
}
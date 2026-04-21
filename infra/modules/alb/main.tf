locals { 
    name = "${var.project_name}-${var.environment}" 
}

resource "aws_lb" "main" {
    name = local.name
    internal = false
    load_balancer_type = "application"
    security_groups = [var.alb_sg_id]
    subnets = var.public_subnet_ids

    tags = {
      Name = "${local.name}-alb"
    }
  
}

resource "aws_lb_target_group" "backend" {
    name = "${local.name}-tg"
    port = 3000
    protocol = "HTTP"
    vpc_id = var.vpc_id
    health_check {
      path = "/healthz"
      healthy_threshold = 2 
      unhealthy_threshold = 2
      timeout = 5
      interval = 30 #
    }

    tags = {
      Name = "${local.name}-tg"
    }
  
}

resource "aws_lb_target_group_attachment" "backend" {
    target_group_arn = aws_lb_target_group.backend.arn
    target_id = var.backend_instance_id
    port = 3000
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.main.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.backend.arn
    }
  
}
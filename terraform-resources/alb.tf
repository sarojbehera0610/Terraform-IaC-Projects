# ──────────────────────────────────────────
# APPLICATION LOAD BALANCER
# ──────────────────────────────────────────
resource "aws_lb" "main" {
  name               = var.alb_name
  internal           = false          # false = internet-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public2.id]

  enable_deletion_protection = false

  tags = {
    Name = var.alb_name
  }
}

# ──────────────────────────────────────────
# TARGET GROUP
# ALB forwards traffic to this target group
# ASG registers instances into this group
# ──────────────────────────────────────────
resource "aws_lb_target_group" "main" {
  name     = var.tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  # Health check — ALB checks if instance is healthy
  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = var.tg_name
  }
}

# ──────────────────────────────────────────
# LISTENER
# ALB listens on port 80 and forwards to target group
# ──────────────────────────────────────────
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# ──────────────────────────────────────────
# OUTPUTS
# ──────────────────────────────────────────
output "alb_dns_name" {
  description = "DNS name of the ALB — use this to access your app"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.main.arn
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.main.arn
}

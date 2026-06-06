# ──────────────────────────────────────────
# FETCH DEFAULT VPC AUTOMATICALLY
# ──────────────────────────────────────────
data "aws_vpc" "default" {
  default = true
}

# ──────────────────────────────────────────
# FETCH ALL DEFAULT SUBNETS AUTOMATICALLY
# ALB needs minimum 2 subnets in different AZs
# ──────────────────────────────────────────
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

# ──────────────────────────────────────────
# SECURITY GROUP FOR ALB
# ──────────────────────────────────────────
resource "aws_security_group" "alb_sg" {
  name        = "${var.alb_name}-sg"
  description = "Allow HTTP and HTTPS for ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.alb_name}-sg"
    Environment = var.environment
  }
}

# ──────────────────────────────────────────
# APPLICATION LOAD BALANCER
# ──────────────────────────────────────────
resource "aws_lb" "main" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.default.ids   # auto fetched all default subnets

  enable_deletion_protection = false

  tags = {
    Name        = var.alb_name
    Environment = var.environment
  }
}

# ──────────────────────────────────────────
# TARGET GROUP
# ──────────────────────────────────────────
resource "aws_lb_target_group" "main" {
  name     = var.tg_name
  port     = var.tg_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    enabled             = true
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name        = var.tg_name
    Environment = var.environment
  }
}

# ──────────────────────────────────────────
# LISTENER — port 80 forwards to target group
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

# ──────────────────────────────────────────
# FETCH DEFAULT VPC AUTOMATICALLY
# ──────────────────────────────────────────
data "aws_vpc" "default" {
  default = true
}

# ──────────────────────────────────────────
# FETCH ALL DEFAULT SUBNETS AUTOMATICALLY
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
# FETCH LATEST UBUNTU 22.04 AMI AUTOMATICALLY
# ──────────────────────────────────────────
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ──────────────────────────────────────────
# SECURITY GROUP FOR ASG INSTANCES
# ──────────────────────────────────────────
resource "aws_security_group" "asg_sg" {
  name        = "${var.asg_name}-sg"
  description = "Allow SSH HTTP HTTPS for ASG instances"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

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
    Name        = "${var.asg_name}-sg"
    Environment = var.environment
  }
}

# ──────────────────────────────────────────
# LAUNCH TEMPLATE
# defines what instance ASG launches
# ──────────────────────────────────────────
resource "aws_launch_template" "main" {
  name_prefix   = "${var.asg_name}-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.asg_sg.id]
  }

  # user data runs automatically on every new instance boot
  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
    echo "<h1>Hello from $(hostname) - ${var.environment} ASG Instance</h1>" > /var/www/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.asg_name}-instance"
      Environment = var.environment
    }
  }

  tags = {
    Name        = "${var.asg_name}-launch-template"
    Environment = var.environment
  }
}

# ──────────────────────────────────────────
# AUTO SCALING GROUP
# ──────────────────────────────────────────
resource "aws_autoscaling_group" "main" {
  name                      = var.asg_name
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = data.aws_subnets.default.ids
  health_check_type         = "EC2"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.asg_name}-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

# ──────────────────────────────────────────
# SCALE OUT POLICY — add instance when CPU > threshold
# ──────────────────────────────────────────
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.asg_name}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = var.cooldown_period
}

# ──────────────────────────────────────────
# CLOUDWATCH ALARM — CPU HIGH
# ──────────────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.asg_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = var.scale_out_cpu_threshold
  alarm_description   = "Scale out when CPU > ${var.scale_out_cpu_threshold}%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_out.arn]

  tags = {
    Name        = "${var.asg_name}-cpu-high-alarm"
    Environment = var.environment
  }
}

# ──────────────────────────────────────────
# SCALE IN POLICY — remove instance when CPU < threshold
# ──────────────────────────────────────────
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.asg_name}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = var.cooldown_period
}

# ──────────────────────────────────────────
# CLOUDWATCH ALARM — CPU LOW
# ──────────────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.asg_name}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = var.scale_in_cpu_threshold
  alarm_description   = "Scale in when CPU < ${var.scale_in_cpu_threshold}%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_in.arn]

  tags = {
    Name        = "${var.asg_name}-cpu-low-alarm"
    Environment = var.environment
  }
}
